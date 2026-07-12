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

    // MARK: - Private

    private let audioManager: AudioManager
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
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

    // MARK: - Story Control

    func startStory(_ script: StoryScript) {
        selectedScript = script
        cues = script.cues
        currentCueIndex = 0
        recognizedText = ""
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
        selectedScript = nil
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
        guard storyState == .listening else { return }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        let task = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }

            if let result {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                    self.checkCurrentCue(in: self.recognizedText)
                }
            }

            if error != nil || result?.isFinal == true {
                DispatchQueue.main.async {
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

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
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
                withAnimation { storyState = .finished }
            }
            return
        }

        if let keyword = cues[currentCueIndex].keyword, text.contains(keyword) {
            triggerCue(at: currentCueIndex)
        }
    }

    // 수동 재생 — 버튼으로 직접 소리 실행 (효과음 큐만 가능)
    func manualPlay(at index: Int) {
        guard index < cues.count, cues[index].hasCue else { return }
        if isListening {
            triggerCue(at: index)
        } else {
            if let soundID = effectiveSoundID(for: cues[index]),
               let sound = SoundLibrary.shared.allSounds.first(where: { $0.id == soundID }) {
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

    private func triggerCue(at index: Int) {
        guard index < cues.count, cues[index].hasCue else { return }

        cues[index].isCompleted = true
        currentCueIndex = index + 1

        // 1) 인식만 중단 — 세션은 .playAndRecord 유지 (전환 없음)
        stopRecognition(restoreSession: false)
        recognizedText = ""

        // 2) 소리 재생 (세션 전환 없으므로 즉시 재생 가능)
        let soundID = effectiveSoundID(for: cues[index])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            if let soundID,
               let sound = SoundLibrary.shared.allSounds.first(where: { $0.id == soundID }) {
                self.audioManager.play(sound)
            }

            // 3) 소리가 어느 정도 재생된 후 인식 재시작
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self, self.storyState == .listening else { return }
                self.beginRecognition()
            }
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
