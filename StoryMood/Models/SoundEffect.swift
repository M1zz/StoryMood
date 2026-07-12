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

    /// Check if audio file exists in bundle (Sounds/ subdirectory or root)
    static func checkAudioExists(fileName: String) -> Bool {
        let extensions = ["mp3", "wav", "m4a", "aac", "caf"]
        for ext in extensions {
            if Bundle.main.url(forResource: fileName, withExtension: ext, subdirectory: "Sounds") != nil {
                return true
            }
            if Bundle.main.url(forResource: fileName, withExtension: ext) != nil {
                return true
            }
        }
        return false
    }
}
