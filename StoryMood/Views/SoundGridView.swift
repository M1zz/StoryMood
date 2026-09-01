import SwiftUI

struct SoundGridView: View {
    let sounds: [SoundEffect]
    let currentlyPlaying: SoundEffect?
    let onTap: (SoundEffect) -> Void
    
    // 동그란 버튼 — 손가락으로 누르기 좋게 조금 크게, 간격은 넉넉히
    private let columns = [
        GridItem(.adaptive(minimum: 104, maximum: 140), spacing: 14)
    ]
    
    var body: some View {
        if sounds.isEmpty {
            ContentUnavailableView {
                Label("검색 결과 없음", systemImage: "magnifyingglass")
            } description: {
                Text("다른 키워드로 검색해보세요")
            }
            .padding(.top, 60)
        } else {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(sounds) { sound in
                    SoundButtonView(
                        sound: sound,
                        isPlaying: currentlyPlaying?.id == sound.id,
                        action: { onTap(sound) }
                    )
                    .id(sound.id)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    ScrollView {
        SoundGridView(
            sounds: SoundLibrary.shared.allSounds.prefix(12).map { $0 },
            currentlyPlaying: nil,
            onTap: { _ in }
        )
    }
}
