import Foundation

/// 동화별 큐 사운드 커스터마이징을 UserDefaults에 저장/불러오기
final class StoryCustomizationStore {

    static let shared = StoryCustomizationStore()

    private let defaultsKey = "storyCueCustomizations"
    // [storyID: [cueID: soundID]]
    private var map: [String: [String: String]] = [:]

    private init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let decoded = try? JSONDecoder().decode([String: [String: String]].self, from: data) {
            map = decoded
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

    private func persist() {
        if let data = try? JSONEncoder().encode(map) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
}
