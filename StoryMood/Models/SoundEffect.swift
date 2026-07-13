import Foundation
import SwiftUI

/// Represents a single sound effect used for storytelling mood creation
struct SoundEffect: Identifiable, Hashable {
    let id: String
    let nameKo: String
    let nameEn: String
    let emoji: String
    let fileName: String  // Expected audio file name (without extension)
    let categoryID: String
    let relatedTales: [String]  // Fairy tale references that use this sound
    let hasAudioFile: Bool  // false = red border (no audio yet)
    
    var displayName: String { nameKo }

    /// Moods this sound belongs to
    var moodIDs: [String] {
        SoundMood.soundMoodMapping[id] ?? []
    }

    /// Primary mood color for UI
    var primaryMoodColor: Color {
        guard let firstID = moodIDs.first else { return .gray }
        return SoundMood.allMoods.first(where: { $0.id == firstID })?.color ?? .gray
    }

    /// 번들 내 모든 오디오 파일 URL을 1회 스캔해 캐시 (fileName → URL)
    /// 확장자 우선순위: mp3 > wav > m4a > aac > caf, 같은 확장자면 Sounds/ 우선
    static let audioURLByFileName: [String: URL] = {
        var map: [String: URL] = [:]
        for ext in ["mp3", "wav", "m4a", "aac", "caf"] {
            let urls = (Bundle.main.urls(forResourcesWithExtension: ext, subdirectory: "Sounds") ?? [])
                     + (Bundle.main.urls(forResourcesWithExtension: ext, subdirectory: nil) ?? [])
            for url in urls {
                let name = url.deletingPathExtension().lastPathComponent
                if map[name] == nil { map[name] = url }
            }
        }
        return map
    }()

    /// Audio file URL for playback (cached lookup)
    static func audioURL(for fileName: String) -> URL? {
        audioURLByFileName[fileName]
    }

    /// Check if audio file exists in bundle (Sounds/ subdirectory or root)
    static func checkAudioExists(fileName: String) -> Bool {
        audioURLByFileName[fileName] != nil
    }
}
