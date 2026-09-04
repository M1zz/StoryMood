import SwiftUI

struct MoodTabView: View {
    let moods: [SoundMood]
    let selectedMood: SoundMood?
    let isBGMPlaying: Bool
    let isBackgroundMusicOnly: Bool
    let onSelect: (SoundMood?) -> Void
    let onSelectBackgroundMusic: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All" button
                MoodChip(
                    emoji: "🎵",
                    name: "전체",
                    color: .blue,
                    isSelected: selectedMood == nil && !isBackgroundMusicOnly,
                    showBGM: false,
                    action: { onSelect(nil) }
                )

                // 배경음악 — 효과음과 규칙이 달라(길게 반복) 따로 뺀 카테고리
                MoodChip(
                    emoji: BackgroundMusicSet.chipEmoji,
                    name: BackgroundMusicSet.chipName,
                    color: BackgroundMusicSet.chipColor,
                    isSelected: isBackgroundMusicOnly,
                    showBGM: false,
                    action: onSelectBackgroundMusic
                )

                ForEach(moods) { mood in
                    MoodChip(
                        emoji: mood.emoji,
                        name: mood.nameKo,
                        color: mood.color,
                        isSelected: !isBackgroundMusicOnly && selectedMood?.id == mood.id,
                        showBGM: isBGMPlaying && selectedMood?.id == mood.id,
                        action: { onSelect(mood) }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Mood Chip

private struct MoodChip: View {
    let emoji: String
    let name: String
    let color: Color
    let isSelected: Bool
    let showBGM: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(emoji)
                    .font(.system(size: 14))
                Text(name)
                    .font(.system(size: 13, weight: isSelected ? .bold : .medium, design: .rounded))
                if showBGM {
                    Image(systemName: "music.note")
                        .font(.system(size: 10, weight: .bold))
                        .symbolEffect(.pulse)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                Capsule()
                    .fill(isSelected ? color.opacity(0.2) : Color(.secondarySystemBackground))
            }
            .overlay {
                Capsule()
                    .stroke(isSelected ? color : .clear, lineWidth: 1.5)
            }
            .foregroundStyle(isSelected ? color : .primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MoodTabView(
        moods: SoundMood.allMoods,
        selectedMood: SoundMood.allMoods.first,
        isBGMPlaying: true,
        isBackgroundMusicOnly: false,
        onSelect: { _ in },
        onSelectBackgroundMusic: {}
    )
}
