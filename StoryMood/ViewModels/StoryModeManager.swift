import Foundation
import Speech
import AVFoundation
import SwiftUI

@Observable
final class StoryModeManager: NSObject {

    // MARK: - State

    enum StoryState: Equatable {
        case idle
        case requestingPermission
        case listening
        case finished
        case error(String)
    }

    var storyState: StoryState = .idle
    var cues: [StoryCue] = []
    var currentCueIndex: Int = 0
    var recognizedText: String = ""
    var selectedScript: StoryScript?
    /// 마지막으로 실제 발동(소리 재생)된 큐의 인덱스 — 큐시트 자동 스크롤 기준.
    /// currentCueIndex는 낭독 문단을 건너뛰고 다음 효과음 큐로 미리 전진하므로
    /// 스크롤 기준으로 쓰면 시작하자마자 화면이 앞으로 튄다.
    var lastCompletedCueIndex: Int?
    /// 리허설 모드 — 마이크 없이 ▶︎ 버튼으로 진행하며 소리와 흐름을 확인
    var isRehearsal = false

    // MARK: - Private

    private let audioManager: AudioManager
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    /// 인식 세션 세대 번호. 취소된 이전 세션의 늦은 콜백이 이전 누적 텍스트를
    /// 복원하면서 다음 큐를 연쇄 발동시키는 것을 차단한다.
    private var recognitionGeneration = 0
    private var audioEngine = AVAudioEngine()
    private var restartTimer: Timer?
    private let audioQueue = DispatchQueue(label: "StoryModeAudio", qos: .userInitiated)

    // MARK: - Init

    init(audioManager: AudioManager) {
        self.audioManager = audioManager
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
        speechRecognizer?.delegate = self
    }

    // MARK: - Computed

    var isListening: Bool { storyState == .listening }

    var currentCue: StoryCue? {
        guard currentCueIndex < cues.count else { return nil }
        return cues[currentCueIndex]
    }

    /// 다음 발동 대기 중인 효과음 큐 인덱스 — 낭독 문단은 건너뜀.
    /// 매칭은 이 큐 하나만 대상으로 하므로, 더 아래의 키워드가 먼저 발동할 수 없다.
    var awaitingCueIndex: Int? {
        guard isListening else { return nil }
        var i = currentCueIndex
        while i < cues.count {
            if cues[i].hasCue { return i }
            i += 1
        }
        return nil
    }

    /// 대기 중인 큐의 키워드 — 소리가 안 나오면 이 단어를 외쳐서 발동시킬 수 있다
    var awaitingKeyword: String? {
        awaitingCueIndex.flatMap { cues[$0].keyword }
    }

    // MARK: - Story Control

    func startStory(_ script: StoryScript, resumeFrom resumeIndex: Int? = nil) {
        selectedScript = script
        cues = script.cues
        currentCueIndex = 0
        recognizedText = ""
        lastCompletedCueIndex = nil
        isRehearsal = false

        // 이어서 하기 — 저장된 진행 지점까지 완료 처리 후 그 다음부터
        if let resumeIndex, resumeIndex < cues.count {
            for i in 0...resumeIndex where cues[i].hasCue {
                cues[i].isCompleted = true
            }
            currentCueIndex = resumeIndex + 1
            lastCompletedCueIndex = resumeIndex
        }

        storyState = .requestingPermission

        requestPermissions { [weak self] granted in
            guard let self else { return }
            if granted {
                // 세션을 .playAndRecord로 한 번만 설정 — 이야기 전체 동안 유지
                self.activateStorySession { success in
                    if success {
                        self.storyState = .listening
                        self.beginRecognition()
                    } else {
                        self.storyState = .error("오디오 세션을 시작할 수 없어요.")
                    }
                }
            } else {
                self.storyState = .error("음성 인식 권한이 필요합니다.\n설정 > 개인 정보 보호에서 허용해 주세요.")
            }
        }
    }

    func stopStory() {
        stopRecognition(restoreSession: true)
        storyState = .idle
        cues = []
        currentCueIndex = 0
        recognizedText = ""
        lastCompletedCueIndex = nil
        isRehearsal = false
        selectedScript = nil
    }

    /// 리허설 시작 — 마이크·음성 인식 없이 ▶︎ 버튼으로 큐를 직접 발동하며 확인
    func startRehearsal(_ script: StoryScript) {
        selectedScript = script
        cues = script.cues
        currentCueIndex = 0
        recognizedText = ""
        lastCompletedCueIndex = nil
        isRehearsal = true
        storyState = .listening
    }

    /// 상세 화면 진입 시 권한을 미리 요청 — 공연 시작 순간에 팝업이 뜨지 않게
    func preflightPermissions() {
        guard storyState == .idle else { return }
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { return }
            AVAudioApplication.requestRecordPermission { _ in }
        }
    }

    // MARK: - 진행 상황 저장 (이어서 하기)

    /// 저장된 진행 지점(마지막 발동 큐 인덱스). 없으면 nil
    static func savedProgress(for scriptID: String) -> Int? {
        UserDefaults.standard.object(forKey: "story_progress_\(scriptID)") as? Int
    }

    private func saveProgress(_ index: Int) {
        guard !isRehearsal, let id = selectedScript?.id else { return }
        UserDefaults.standard.set(index, forKey: "story_progress_\(id)")
    }

    private func clearProgress() {
        guard let id = selectedScript?.id else { return }
        UserDefaults.standard.removeObject(forKey: "story_progress_\(id)")
    }

    // MARK: - Audio Session

    /// 이야기 모드용 세션 활성화 — 배경에서 실행하여 메인 스레드 블로킹 방지
    private func activateStorySession(completion: @escaping (Bool) -> Void) {
        audioQueue.async {
            #if os(iOS)
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playAndRecord, mode: .default,
                                        options: [.mixWithOthers, .defaultToSpeaker, .allowBluetoothHFP])
                try session.setActive(true)
                DispatchQueue.main.async { completion(true) }
            } catch {
                DispatchQueue.main.async { completion(false) }
            }
            #else
            DispatchQueue.main.async { completion(true) }
            #endif
        }
    }

    // MARK: - Permissions

    private func requestPermissions(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        }
    }

    // MARK: - Recognition (audio work on background queue to avoid main thread freeze)

    private func beginRecognition() {
        guard storyState == .listening, !isRehearsal else { return }
        // 이미 세션이 돌고 있으면 중복 시작 금지 — 50초 자동 재시작과
        // 큐 발동 후 재시작이 겹쳐 세션 2개가 동시에 돌던 문제 방지
        guard recognitionTask == nil else { return }

        recognitionGeneration += 1
        let generation = recognitionGeneration

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        let task = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }

            if let result {
                DispatchQueue.main.async {
                    // 취소된 이전 세대의 늦은 콜백 무시 — 이전 누적 텍스트가 복원되면
                    // 이미 말한 키워드로 다음 큐들이 연쇄 발동(휙휙 넘어감)한다
                    guard generation == self.recognitionGeneration else { return }
                    self.recognizedText = result.bestTranscription.formattedString
                    self.checkCurrentCue(in: self.recognizedText)
                }
            }

            if error != nil || result?.isFinal == true {
                DispatchQueue.main.async {
                    guard generation == self.recognitionGeneration else { return }
                    // recognitionTask가 이미 nil이면 stopRecognition이 호출한 것 → 재시작 생략
                    guard self.storyState == .listening, self.recognitionTask != nil else { return }
                    self.restartAfterDelay()
                }
            }
        }
        recognitionTask = task

        // Audio setup on background queue — prevents main thread freeze
        audioQueue.async { [weak self] in
            guard let self else { return }
            // 이 블록이 실행되기 전에 stopRecognition이 불렸으면 엔진을 켜지 않음
            guard let request = self.recognitionRequest else { return }

            // 매번 새 엔진 생성 — 재사용 시 format이 0 Hz로 캐시되는 버그 방지
            let engine = AVAudioEngine()
            self.audioEngine = engine

            // 세션은 이미 startStory에서 .playAndRecord로 설정됨 → 여기선 건드리지 않음
            // AVAudioPlayer가 재생 중이어도 세션 전환 없으므로 '!pri' 오류 없음

            let inputNode = engine.inputNode
            let format = inputNode.outputFormat(forBus: 0)

            // format이 유효한지 확인 (0 Hz면 세션 문제)
            guard format.sampleRate > 0 else {
                DispatchQueue.main.async {
                    self.storyState = .error("마이크 초기화 실패. 이야기를 다시 시작해 주세요.")
                }
                return
            }

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                // 이 세션의 request에만 공급 — 다른 세션 request로 새는 것 방지
                // (endAudio 이후의 append는 무시되므로 안전)
                request.append(buffer)
            }

            engine.prepare()

            do {
                try engine.start()
            } catch {
                DispatchQueue.main.async {
                    self.storyState = .error("마이크 오류: \(error.localizedDescription)")
                }
                return
            }

            // SFSpeechRecognizer has ~60s limit — restart every 50s
            DispatchQueue.main.async { self.scheduleAutoRestart() }
        }
    }

    private func scheduleAutoRestart() {
        restartTimer?.invalidate()
        restartTimer = Timer.scheduledTimer(withTimeInterval: 50, repeats: false) { [weak self] _ in
            guard let self, self.storyState == .listening else { return }
            self.restartAfterDelay()
        }
    }

    // 60초 제한 등 자연 만료 시 재시작 (세션 유지)
    private func restartAfterDelay() {
        stopRecognition(restoreSession: false)
        recognizedText = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self, self.storyState == .listening else { return }
            self.beginRecognition()
        }
    }

    private func stopRecognition(restoreSession: Bool) {
        // 아직 전달 중인 이전 세션 콜백을 즉시 무효화
        recognitionGeneration += 1

        restartTimer?.invalidate()
        restartTimer = nil

        let engineToStop = audioEngine
        audioQueue.async {
            if engineToStop.isRunning { engineToStop.stop() }
            engineToStop.inputNode.removeTap(onBus: 0)

            #if os(iOS)
            if restoreSession {
                try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default,
                                                                  options: [.mixWithOthers])
                try? AVAudioSession.sharedInstance().setActive(true)
            }
            #endif
        }

        recognitionRequest?.endAudio()
        recognitionRequest = nil
        // task를 먼저 nil → completion handler의 guard에서 재시작 차단
        let taskToCancel = recognitionTask
        recognitionTask = nil
        taskToCancel?.cancel()
    }

    // MARK: - Cue Matching

    private func checkCurrentCue(in text: String) {
        // 소리 없는 낭독 문단은 건너뜀 (자동으로 다음 효과음 큐로 전진)
        while currentCueIndex < cues.count && !cues[currentCueIndex].hasCue {
            currentCueIndex += 1
        }

        guard currentCueIndex < cues.count else {
            if storyState == .listening {
                stopRecognition(restoreSession: true)
                clearProgress()
                withAnimation { storyState = .finished }
            }
            return
        }

        if let keyword = cues[currentCueIndex].keyword,
           Self.normalizedForMatching(text).contains(Self.normalizedForMatching(keyword)) {
            triggerCue(at: currentCueIndex)
        }
    }

    /// 음성 인식 표기 차이를 흡수하는 발음 기반 정규화.
    /// - 공백·문장부호 제거 ("문을 두드렸어요" ↔ "문을두드렸어요")
    /// - 발음이 같은 모음 통일: ㅐ=ㅔ, ㅒ=ㅖ, ㅙ=ㅚ=ㅞ
    ///   (예: 키워드 "새들이"를 STT가 "세들이"로 받아 적어도 매칭됨)
    static func normalizedForMatching(_ s: String) -> String {
        var result = String.UnicodeScalarView()
        for scalar in s.unicodeScalars {
            if CharacterSet.whitespacesAndNewlines.contains(scalar)
                || CharacterSet.punctuationCharacters.contains(scalar) {
                continue
            }
            guard (0xAC00...0xD7A3).contains(scalar.value) else {
                result.append(scalar)
                continue
            }
            let base = scalar.value - 0xAC00
            let jong = base % 28
            var jung = (base / 28) % 21
            let cho = base / 28 / 21
            // 중성 인덱스: ㅐ(1)→ㅔ(5), ㅒ(3)→ㅖ(7), ㅙ(10)·ㅚ(11)→ㅞ(15)
            switch jung {
            case 1: jung = 5
            case 3: jung = 7
            case 10, 11: jung = 15
            default: break
            }
            if let recomposed = Unicode.Scalar(0xAC00 + (cho * 21 + jung) * 28 + jong) {
                result.append(recomposed)
            }
        }
        return String(result)
    }

    // 수동 재생 — 버튼으로 직접 소리 실행 (효과음 큐만 가능)
    func manualPlay(at index: Int) {
        guard index < cues.count, cues[index].hasCue else { return }
        if isListening {
            triggerCue(at: index)
        } else {
            if let soundID = effectiveSoundID(for: cues[index]),
               let sound = SoundLibrary.shared.soundsByID[soundID] {
                audioManager.play(sound)
            }
        }
    }

    /// 커스터마이징 반영된 실제 soundID. 낭독 문단이면 nil 반환
    func effectiveSoundID(for cue: StoryCue) -> String? {
        guard let soundID = cue.soundID else { return nil }
        guard let storyID = selectedScript?.id else { return soundID }
        return StoryCustomizationStore.shared.customSoundID(forCue: cue.id, story: storyID) ?? soundID
    }

    /// 커스터마이징 반영된 실제 delay — 리허설하며 편집 시트에서 조정 가능
    func effectiveDelay(for cue: StoryCue) -> TimeInterval {
        guard let storyID = selectedScript?.id else { return cue.delay }
        return StoryCustomizationStore.shared.customDelay(forCue: cue.id, story: storyID) ?? cue.delay
    }

    private func triggerCue(at index: Int) {
        guard index < cues.count, cues[index].hasCue else { return }

        cues[index].isCompleted = true
        currentCueIndex = index + 1
        lastCompletedCueIndex = index
        saveProgress(index)

        // 1) 인식만 중단 — 세션은 .playAndRecord 유지 (전환 없음)
        stopRecognition(restoreSession: false)
        recognizedText = ""

        // 2) 인식은 소리 재생과 무관하게 곧바로 재개 — 낭독 공백을 없애
        //    바로 붙어 있는 다음 큐도 놓치지 않는다. (예전엔 delay+1.5초를 기다렸음.
        //    자기 효과음이 마이크에 들려도 키워드와 겹칠 확률은 낮음)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self, self.storyState == .listening else { return }
            self.beginRecognition()
        }

        // 3) 큐에 지정된 지연 후 소리 재생 — 조기 키워드 인식 방식
        //    예: "사냥꾼이 총을 탕 하고 쐈어요"에서 "사냥꾼이"를 인식하고
        //    delay(1초) 후 재생하면 "탕" 타이밍에 소리가 맞음
        let soundID = effectiveSoundID(for: cues[index])
        let delay = max(0.1, effectiveDelay(for: cues[index]))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else { return }
            if let soundID,
               let sound = SoundLibrary.shared.soundsByID[soundID] {
                self.audioManager.play(sound)
            }
        }

        // 리허설: 마지막 효과음 큐까지 발동했으면 종료 처리
        if isRehearsal, awaitingCueIndex == nil {
            clearProgress()
            withAnimation { storyState = .finished }
        }
    }
}

// MARK: - SFSpeechRecognizerDelegate

extension StoryModeManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available && storyState == .listening {
            DispatchQueue.main.async {
                self.storyState = .error("음성 인식을 현재 사용할 수 없어요.")
            }
        }
    }
}
