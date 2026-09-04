import Foundation
import AVFoundation
import SwiftUI

@Observable
final class AudioManager {
    
    // MARK: - Properties
    
    var currentlyPlaying: SoundEffect?
    var isPlaying = false
    var selectedMood: SoundMood?
    var searchText = ""
    var showMissingOnly = false
    var showTaleList = false
    /// 배경음악 카테고리만 보기 — 무드 필터와 배타적
    var showBackgroundMusicOnly = false
    
    private var audioPlayer: AVAudioPlayer?
    private var bgmPlayer: AVAudioPlayer?
    // 한 번 만든 플레이어는 재사용 — 탭 → 재생 지연 최소화
    // 효과음/BGM 캐시 분리: 같은 파일이 BGM으로 루프 중일 때 효과음 재생과 충돌 방지
    private var effectPlayerCache: [String: AVAudioPlayer] = [:]
    private var bgmPlayerCache: [String: AVAudioPlayer] = [:]
    private var interruptionObserver: NSObjectProtocol?
    var isBGMPlaying = false
    var bgmVolume: Float = 0.25 {
        didSet { bgmPlayer?.volume = bgmVolume }
    }
    var soundVolume: Float = 1.0 {
        didSet { audioPlayer?.volume = soundVolume }
    }
    var soundDuration: TimeInterval = 0
    var soundCurrentTime: TimeInterval = 0

    private var playbackTimer: Timer?
    /// 재생 길이 제한 타이머 (효과음 3초 / 배경음악 60초)
    private var effectLimitTimer: Timer?
    /// 루프 재생 중에도 진행 시간을 정확히 재기 위한 시작 시각
    private var playStartedAt: Date?

    // MARK: - 재생 길이 규칙
    // 효과음은 길이가 제각각이라 그대로 틀면 "찰칵"처럼 너무 짧거나 30초씩 늘어진다.
    // → 짧으면 3초가 될 때까지 반복하고, 길면 3초에서 페이드아웃으로 끊는다.
    /// 효과음 목표 재생 길이
    private static let effectDuration: TimeInterval = 3.0
    private static let effectFade: TimeInterval = 0.3
    /// 배경음악은 장면 아래 깔리는 소리라 길게 — 60초까지 반복 후 서서히 사라짐
    private static let backgroundMusicDuration: TimeInterval = 60.0
    private static let backgroundMusicFade: TimeInterval = 2.5
    
    // MARK: - Computed
    
    var library: SoundLibrary { .shared }

    var moods: [SoundMood] { SoundMood.allMoods }

    var filteredSounds: [SoundEffect] {
        var sounds = library.allSounds

        if showBackgroundMusicOnly {
            sounds = sounds.filter { $0.isBackgroundMusic }
        } else if let mood = selectedMood {
            sounds = sounds.filter { $0.moodIDs.contains(mood.id) }
        }

        if showMissingOnly {
            sounds = sounds.filter { !$0.hasAudioFile }
        }

        if !searchText.isEmpty {
            sounds = sounds.filter {
                $0.nameKo.localizedCaseInsensitiveContains(searchText) ||
                $0.nameEn.localizedCaseInsensitiveContains(searchText) ||
                $0.relatedTales.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }

        return sounds
    }
    
    var totalSoundCount: Int { library.totalCount }
    var missingCount: Int { library.missingAudioCount }
    var availableCount: Int { totalSoundCount - missingCount }
    
    // MARK: - Init
    
    init() {
        setupAudioSession()
        observeInterruptions()
    }

    deinit {
        if let interruptionObserver {
            NotificationCenter.default.removeObserver(interruptionObserver)
        }
    }
    
    // MARK: - Audio Session
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }
    
    // MARK: - Playback
    
    /// - Parameter useCustomization: false면 갈아끼운 소리를 무시하고 이 소리의 원본 파일을 재생
    ///   (소리를 고르는 시트에서 후보를 미리 들어볼 때)
    func play(_ sound: SoundEffect, useCustomization: Bool = true) {
        // 토글: 이미 재생 중인 소리를 다시 누르면 정지
        if currentlyPlaying?.id == sound.id {
            stop()
            return
        }
        stop()

        // 사용자가 갈아끼운 소리가 있으면 그 파일을 대신 재생한다
        let fileName = useCustomization
            ? SoundCustomizationStore.shared.effectiveFileName(for: sound)
            : sound.fileName

        // 캐시된 URL로 즉시 재생 (번들 탐색 없음)
        guard let url = SoundEffect.audioURL(for: fileName) else {
            // 음원 미등록 — 잠깐 표시해 알려 준다
            withAnimation(.easeInOut(duration: 0.3)) {
                currentlyPlaying = sound
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                withAnimation {
                    self?.currentlyPlaying = nil
                }
            }
            return
        }

        do {
            let player: AVAudioPlayer
            if let cached = effectPlayerCache[fileName] {
                player = cached
                player.stop()
                player.currentTime = 0
            } else {
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                effectPlayerCache[fileName] = player
            }
            player.volume = soundVolume

            // 목표 길이보다 짧은 소리는 반복해서 채운다 — 제한 타이머가 정확히 끊어 준다
            let isBGM = sound.isBackgroundMusic
            let limit = isBGM ? Self.backgroundMusicDuration : Self.effectDuration
            player.numberOfLoops = player.duration < limit - 0.05 ? -1 : 0

            player.play()
            audioPlayer = player
            playStartedAt = Date()
            soundDuration = limit
            soundCurrentTime = 0
            startPlaybackTimer()
            scheduleEffectLimit(isBackgroundMusic: isBGM)

            withAnimation {
                currentlyPlaying = sound
                isPlaying = true
            }
        } catch {
            print("Error playing \(fileName): \(error)")
        }
    }

    /// 재생 길이 제한 — 효과음 3초, 배경음악 60초.
    /// 페이드아웃이 제한 시간 안에 끝나도록 미리 페이드를 시작한다.
    private func scheduleEffectLimit(isBackgroundMusic: Bool) {
        effectLimitTimer?.invalidate()
        effectLimitTimer = nil

        let limit = isBackgroundMusic ? Self.backgroundMusicDuration : Self.effectDuration
        let fade = isBackgroundMusic ? Self.backgroundMusicFade : Self.effectFade
        let player = audioPlayer

        let timer = Timer(timeInterval: max(0.1, limit - fade), repeats: false) { [weak self] _ in
            guard let self, self.audioPlayer === player else { return }
            self.stop(fadeDuration: fade)
        }
        effectLimitTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    /// fadeDuration 미지정 시 배경음악은 1.2초, 효과음은 0.15초 페이드아웃 —
    /// 음악이 뚝 끊기지 않고 항상 부드럽게 사라지도록
    func stop(fadeDuration: TimeInterval? = nil) {
        let isBGM = currentlyPlaying?.isBackgroundMusic ?? false
        let fade = fadeDuration ?? (isBGM ? 1.2 : 0.15)
        effectLimitTimer?.invalidate()
        effectLimitTimer = nil
        playbackTimer?.invalidate()
        playbackTimer = nil
        playStartedAt = nil
        fadeOutAndStop(audioPlayer, fadeDuration: fade)
        audioPlayer = nil
        soundDuration = 0
        soundCurrentTime = 0
        withAnimation {
            currentlyPlaying = nil
            isPlaying = false
        }
    }

    /// 뚝 끊기지 않게 짧은 페이드아웃 후 정지
    private func fadeOutAndStop(_ player: AVAudioPlayer?, fadeDuration: TimeInterval) {
        guard let player else { return }
        guard player.isPlaying else {
            player.stop()
            return
        }
        player.setVolume(0, fadeDuration: fadeDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration + 0.05) { [weak self] in
            // 페이드 도중 캐시에서 재사용됐으면 건드리지 않음
            guard player !== self?.audioPlayer, player !== self?.bgmPlayer else { return }
            player.stop()
        }
    }

    private func startPlaybackTimer() {
        playbackTimer?.invalidate()
        let timer = Timer(timeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self, let player = self.audioPlayer else { return }
            // 짧은 소리는 반복 재생되므로 player.currentTime은 계속 0으로 돌아간다
            // → 실제 흐른 시간으로 진행 바를 채운다
            if let start = self.playStartedAt {
                self.soundCurrentTime = min(Date().timeIntervalSince(start), self.soundDuration)
            } else {
                self.soundCurrentTime = player.currentTime
            }
            // 반복하지 않는 소리가 제한 시간보다 먼저 끝난 경우 (안전장치)
            if !player.isPlaying, player.numberOfLoops == 0 {
                self.stop()
            }
        }
        playbackTimer = timer
        // .common 모드 — 스크롤 중에도 진행 바가 멈추지 않음
        RunLoop.main.add(timer, forMode: .common)
    }

    func seekSound(to time: TimeInterval) {
        guard let player = audioPlayer else { return }
        // 파일보다 긴 목표 길이(반복 재생) 안에서의 이동 — 파일 안 위치로 접어서 넘긴다
        player.currentTime = player.duration > 0 ? time.truncatingRemainder(dividingBy: player.duration) : 0
        playStartedAt = Date().addingTimeInterval(-time)
        soundCurrentTime = time
    }
    
    func selectMood(_ mood: SoundMood?) {
        withAnimation(.easeInOut(duration: 0.25)) {
            showBackgroundMusicOnly = false
            if selectedMood?.id == mood?.id {
                selectedMood = nil
                stopBGM()
            } else {
                selectedMood = mood
                playBGM(mood)
            }
        }
    }

    /// 🎼 배경음악 카테고리 — 무드 필터와 배타적이고, 무드 BGM은 꺼 준다
    func toggleBackgroundMusicCategory() {
        withAnimation(.easeInOut(duration: 0.25)) {
            showBackgroundMusicOnly.toggle()
            if showBackgroundMusicOnly {
                selectedMood = nil
                stopBGM()
            }
        }
    }

    // MARK: - BGM

    func playBGM(_ mood: SoundMood?) {
        stopBGM()
        guard let fileName = mood?.bgmFileName,
              let url = SoundEffect.audioURL(for: fileName) else { return }
        do {
            let player: AVAudioPlayer
            if let cached = bgmPlayerCache[fileName] {
                player = cached
                player.stop()
                player.currentTime = 0
            } else {
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                bgmPlayerCache[fileName] = player
            }
            player.numberOfLoops = -1  // 무드를 끌 때까지 계속 흐른다
            player.volume = bgmVolume
            player.play()
            bgmPlayer = player
            withAnimation { isBGMPlaying = true }
        } catch {
            print("BGM error: \(error)")
        }
    }

    /// 무드 BGM은 시간 제한 없이 — 무드 칩을 다시 눌러 끌 때까지 흐른다
    func stopBGM(fadeDuration: TimeInterval = 1.5) {
        fadeOutAndStop(bgmPlayer, fadeDuration: fadeDuration)
        bgmPlayer = nil
        withAnimation { isBGMPlaying = false }
    }

    // MARK: - Interruption (전화/알람 등)

    private func observeInterruptions() {
        interruptionObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] note in
            self?.handleInterruption(note)
        }
    }

    private func handleInterruption(_ note: Notification) {
        guard let typeValue = note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            // 시스템이 재생을 멈춤 — UI 상태만 동기화
            withAnimation { isPlaying = false }

        case .ended:
            let optionsValue = note.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            try? AVAudioSession.sharedInstance().setActive(true)
            if options.contains(.shouldResume) {
                if isBGMPlaying { bgmPlayer?.play() }
                if currentlyPlaying != nil {
                    audioPlayer?.play()
                    withAnimation { isPlaying = true }
                }
            } else {
                stop()
                stopBGM()
            }

        @unknown default:
            break
        }
    }
}
