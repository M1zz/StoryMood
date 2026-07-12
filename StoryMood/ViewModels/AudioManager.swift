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
        
        // Try to load and play the audio file (Sounds/ subdirectory or root)
        let extensions = ["mp3", "wav", "m4a", "aac", "caf"]
        for ext in extensions {
            let url = Bundle.main.url(forResource: sound.fileName, withExtension: ext, subdirectory: "Sounds")
                   ?? Bundle.main.url(forResource: sound.fileName, withExtension: ext)
            if let url {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.volume = soundVolume
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    soundDuration = audioPlayer?.duration ?? 0
                    soundCurrentTime = 0
                    startPlaybackTimer()

                    withAnimation {
                        currentlyPlaying = sound
                        isPlaying = true
                    }
                    return
                } catch {
                    print("Error playing \(sound.fileName): \(error)")
                }
            }
        }
    }
    
    func stop() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        audioPlayer?.stop()
        audioPlayer = nil
        soundDuration = 0
        soundCurrentTime = 0
        withAnimation {
            currentlyPlaying = nil
            isPlaying = false
        }
    }

    private func startPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let player = self.audioPlayer else { return }
            self.soundCurrentTime = player.currentTime
            if !player.isPlaying {
                self.stop()
            }
        }
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
        guard let fileName = mood?.bgmFileName else { return }
        let extensions = ["mp3", "wav", "m4a", "caf"]
        for ext in extensions {
            let url = Bundle.main.url(forResource: fileName, withExtension: ext, subdirectory: "Sounds")
                   ?? Bundle.main.url(forResource: fileName, withExtension: ext)
            if let url {
                do {
                    bgmPlayer = try AVAudioPlayer(contentsOf: url)
                    bgmPlayer?.numberOfLoops = -1  // 무한 루프
                    bgmPlayer?.volume = bgmVolume
                    bgmPlayer?.prepareToPlay()
                    bgmPlayer?.play()
                    withAnimation { isBGMPlaying = true }
                    return
                } catch {
                    print("BGM error: \(error)")
                }
            }
        }
    }

    func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
        withAnimation { isBGMPlaying = false }
    }
}
