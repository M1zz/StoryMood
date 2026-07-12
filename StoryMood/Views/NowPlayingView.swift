import SwiftUI

struct NowPlayingView: View {
    let sound: SoundEffect?
    let isPlaying: Bool
    let onStop: () -> Void
    
    var body: some View {
        if let sound {
            HStack(spacing: 12) {
                // Emoji + animation
                Text(sound.emoji)
                    .font(.title2)
                    .scaleEffect(isPlaying ? 1.15 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                        value: isPlaying
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(sound.nameKo)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .lineLimit(1)
                    
                    if !sound.hasAudioFile {
                        Text("⚠️ 음원 파일이 아직 등록되지 않았습니다")
                            .font(.system(size: 11))
                            .foregroundStyle(.red)
                    } else {
                        Text("재생 중...")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    
                    // Related tales
                    Text(sound.relatedTales.prefix(3).joined(separator: ", "))
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button(action: onStop) {
                    Image(systemName: "stop.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: -2)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    VStack {
        Spacer()
        NowPlayingView(
            sound: SoundEffect(
                id: "test", nameKo: "똑똑똑 (문 두드리기)", nameEn: "Door Knock",
                emoji: "🚪", fileName: "door_knock", categoryID: "door_house",
                relatedTales: ["빨간모자", "아기돼지 삼형제"], hasAudioFile: false
            ),
            isPlaying: true,
            onStop: {}
        )
    }
}
