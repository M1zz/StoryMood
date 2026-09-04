import Foundation
import Observation

/// 동화별 큐 사운드 커스터마이징을 UserDefaults에 저장/불러오기
final class StoryCustomizationStore {

    static let shared = StoryCustomizationStore()

    private let defaultsKey = "storyCueCustomizations"
    private let delayKey = "storyCueDelayCustomizations"
    // [storyID: [cueID: soundID]]
    private var map: [String: [String: String]] = [:]
    // [storyID: [cueID: delay]] — 리허설하며 조정한 큐별 재생 지연
    private var delayMap: [String: [String: Double]] = [:]

    private init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let decoded = try? JSONDecoder().decode([String: [String: String]].self, from: data) {
            map = decoded
        }
        if let data = UserDefaults.standard.data(forKey: delayKey),
           let decoded = try? JSONDecoder().decode([String: [String: Double]].self, from: data) {
            delayMap = decoded
        }
    }

    /// 커스터마이징된 soundID 반환. 없으면 nil
    func customSoundID(forCue cueID: String, story storyID: String) -> String? {
        map[storyID]?[cueID]
    }

    /// 큐 사운드 변경 저장
    func set(soundID: String, forCue cueID: String, story storyID: String) {
        if map[storyID] == nil { map[storyID] = [:] }
        map[storyID]![cueID] = soundID
        persist()
    }

    /// 큐 사운드를 기본값으로 초기화
    func reset(cueID: String, story storyID: String) {
        map[storyID]?.removeValue(forKey: cueID)
        persist()
    }

    /// 해당 큐가 커스터마이징 됐는지 여부
    func isCustomized(cueID: String, story storyID: String) -> Bool {
        map[storyID]?[cueID] != nil
    }

    // MARK: - Delay 커스터마이징 (리허설 중 타이밍 튜닝)

    /// 커스터마이징된 delay 반환. 없으면 nil
    func customDelay(forCue cueID: String, story storyID: String) -> Double? {
        delayMap[storyID]?[cueID]
    }

    func set(delay: Double, forCue cueID: String, story storyID: String) {
        if delayMap[storyID] == nil { delayMap[storyID] = [:] }
        delayMap[storyID]![cueID] = delay
        persistDelays()
    }

    func resetDelay(cueID: String, story storyID: String) {
        delayMap[storyID]?.removeValue(forKey: cueID)
        persistDelays()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(map) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private func persistDelays() {
        if let data = try? JSONEncoder().encode(delayMap) {
            UserDefaults.standard.set(data, forKey: delayKey)
        }
    }
}

// MARK: - 효과음 교체 (전역)

/// 효과음 보드에서 "이 소리 대신 저 소리" 로 갈아끼운 결과를 저장.
/// 동화별 큐 교체(StoryCustomizationStore)와 달리 앱 전체에 적용된다.
@Observable
final class SoundCustomizationStore {

    static let shared = SoundCustomizationStore()

    private let defaultsKey = "soundReplacements"
    /// [원래 soundID: 대신 재생할 soundID]
    private var map: [String: String] = [:]

    private init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            map = decoded
        }
    }

    /// 교체된 soundID. 교체하지 않았으면 nil
    func replacementID(for soundID: String) -> String? {
        map[soundID]
    }

    func isCustomized(_ soundID: String) -> Bool {
        map[soundID] != nil
    }

    /// 교체 저장 — 자기 자신으로 바꾸면 교체 해제
    func set(replacementID: String, for soundID: String) {
        if replacementID == soundID {
            reset(soundID)
            return
        }
        map[soundID] = replacementID
        persist()
    }

    func reset(_ soundID: String) {
        map.removeValue(forKey: soundID)
        persist()
    }

    func resetAll() {
        map.removeAll()
        persist()
    }

    /// 교체까지 반영한 실제 재생 파일명
    func effectiveFileName(for sound: SoundEffect) -> String {
        guard let replacementID = map[sound.id],
              let replacement = SoundLibrary.shared.soundsByID[replacementID] else {
            return sound.fileName
        }
        return replacement.fileName
    }

    /// 교체까지 반영한 실제 사운드 (없으면 원래 사운드)
    func effectiveSound(for sound: SoundEffect) -> SoundEffect {
        guard let replacementID = map[sound.id],
              let replacement = SoundLibrary.shared.soundsByID[replacementID] else {
            return sound
        }
        return replacement
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(map) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
}
