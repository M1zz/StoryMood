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
    /// 노래가 아닌 효과음의 5초 재생 제한 타이머
    private var effectLimitTimer: Timer?
    /// 무드 BGM 10초 재생 제한 타이머
    private var bgmLimitTimer: Timer?

    /// 5초 제한에서 제외되는 음악 사운드 — 노래/배경 음악은 길게 흐르는 게 정상
    private static let musicSoundIDs: Set<String> = [
        "once_upon_time", "happy_ending", "ballroom_music", "music_box",
        "lullaby", "flute_play", "singing_voice", "harp_strum", "creepy_music",
    ]
    
    // MARK: - Computed
    
    var library: SoundLibrary { .shared }

    var moods: [SoundMood] { SoundMood.allMoods }

    var filteredSounds: [SoundEffect] {
        var sounds = library.allSounds

        if let mood = selectedMood {
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
    
    func play(_ sound: SoundEffect) {
        // 토글: 이미 재생 중인 소리를 다시 누르면 정지
        if currentlyPlaying?.id == sound.id {
            stop()
            return
        }
        stop()
        
        // Check if audio file exists
        guard sound.hasAudioFile else {
            // Provide haptic feedback for missing audio
            withAnimation(.easeInOut(duration: 0.3)) {
                currentlyPlaying = sound
            }
            
            // Flash briefly to indicate missing audio
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                withAnimation {
                    self?.currentlyPlaying = nil
                }
            }
            return
        }
        
        // 캐시된 URL로 즉시 재생 (번들 탐색 없음)
        guard let url = SoundEffect.audioURL(for: sound.fileName) else { return }
        do {
            let player: AVAudioPlayer
            if let cached = effectPlayerCache[sound.fileName] {
                player = cached
                player.stop()
                player.currentTime = 0
            } else {
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                effectPlayerCache[sound.fileName] = player
            }
            player.volume = soundVolume
            player.play()
            audioPlayer = player
            soundDuration = player.duration
            soundCurrentTime = 0
            startPlaybackTimer()
            scheduleEffectLimit(for: sound)

            withAnimation {
                currentlyPlaying = sound
                isPlaying = true
            }
        } catch {
            print("Error playing \(sound.fileName): \(error)")
        }
    }

    /// 재생 시간 제한 — 효과음 5초, 음악(노래) 10초.
    /// 페이드아웃이 제한 시간 안에 끝나도록 미리 페이드를 시작한다.
    private func scheduleEffectLimit(for sound: SoundEffect) {
        effectLimitTimer?.invalidate()
        effectLimitTimer = nil

        let isMusic = Self.musicSoundIDs.contains(sound.id)
        let limit: TimeInterval = isMusic ? 10.0 : 5.0
        let fade: TimeInterval = isMusic ? 2.0 : 0.4

        let timer = Timer(timeInterval: limit - fade, repeats: false) { [weak self] _ in
            guard let self, self.currentlyPlaying?.id == sound.id else { return }
            self.stop(fadeDuration: fade)
        }
        effectLimitTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    /// fadeDuration 미지정 시 음악은 1.2초, 효과음은 0.15초 페이드아웃 —
    /// 음악이 뚝 끊기지 않고 항상 부드럽게 사라지도록
    func stop(fadeDuration: TimeInterval? = nil) {
        let isMusic = currentlyPlaying.map { Self.musicSoundIDs.contains($0.id) } ?? false
        let fade = fadeDuration ?? (isMusic ? 1.2 : 0.15)
        effectLimitTimer?.invalidate()
        effectLimitTimer = nil
        playbackTimer?.invalidate()
        playbackTimer = nil
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
        let timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let player = self.audioPlayer else { return }
            self.soundCurrentTime = player.currentTime
            if !player.isPlaying {
                self.stop()
            }
        }
        playbackTimer = timer
        // .common 모드 — 스크롤 중에도 진행 바가 멈추지 않음
        RunLoop.main.add(timer, forMode: .common)
    }

    func seekSound(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        soundCurrentTime = time
    }
    
    func selectMood(_ mood: SoundMood?) {
        withAnimation(.easeInOut(duration: 0.25)) {
            if selectedMood?.id == mood?.id {
                selectedMood = nil
                stopBGM()
            } else {
                selectedMood = mood
                playBGM(mood)
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
            player.numberOfLoops = -1  // 루프 (10초 제한 타이머가 정리)
            player.volume = bgmVolume
            player.play()
            bgmPlayer = player
            scheduleBGMLimit()
            withAnimation { isBGMPlaying = true }
        } catch {
            print("BGM error: \(error)")
        }
    }

    /// 무드 BGM도 10초 제한 — 8초에 페이드를 시작해 10초 안에 사라짐
    private func scheduleBGMLimit() {
        bgmLimitTimer?.invalidate()
        let timer = Timer(timeInterval: 8.0, repeats: false) { [weak self] _ in
            self?.stopBGM(fadeDuration: 2.0)
        }
        bgmLimitTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    func stopBGM(fadeDuration: TimeInterval = 0.4) {
        bgmLimitTimer?.invalidate()
        bgmLimitTimer = nil
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
