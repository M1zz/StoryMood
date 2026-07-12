import SwiftUI

struct SoundButtonView: View {
    let sound: SoundEffect
    let isPlaying: Bool
    let action: () -> Void

    @State private var isPressed = false
    @State private var wiggle = false

    private var moodColor: Color {
        sound.primaryMoodColor
    }

    private var backgroundImage: UIImage? {
        guard let url = Bundle.main.url(
            forResource: sound.fileName,
            withExtension: "jpg",
            subdirectory: "SoundImages"
        ) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    var body: some View {
        Button(action: {
            isPressed = true
            action()

            let generator = UIImpactFeedbackGenerator(style: sound.hasAudioFile ? .medium : .heavy)
            generator.impactOccurred()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
            }

            if !sound.hasAudioFile {
                withAnimation(.default) { wiggle = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { wiggle = false }
            }
        }) {
            VStack(spacing: 0) {
                // 위쪽: 이미지 영역
                if let img = backgroundImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .clipped()
                        .overlay {
                            if isPlaying {
                                moodColor.opacity(0.3)
                            }
                        }
                } else {
                    moodColor.opacity(isPlaying ? 0.25 : 0.08)
                        .frame(height: 58)
                }

                // 아래쪽: 텍스트 영역
                VStack(spacing: 3) {
                    Text(sound.emoji)
                        .font(.system(size: 22))
                        .scaleEffect(isPlaying ? 1.15 : 1.0)
                        .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: isPlaying)

                    Text(sound.nameKo)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(sound.hasAudioFile ? .primary : .secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)

                    if !sound.hasAudioFile {
                        Text("음원 필요")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.red)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Capsule().fill(.red.opacity(0.1)))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(isPlaying ? moodColor.opacity(0.12) : Color(.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: isPlaying ? moodColor.opacity(0.5) : .black.opacity(0.12),
                radius: isPlaying ? 10 : 4,
                y: isPlaying ? 3 : 2
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        sound.hasAudioFile
                        ? (isPlaying ? moodColor : .clear)
                        : Color.red,
                        lineWidth: sound.hasAudioFile ? (isPlaying ? 2.5 : 0) : 2
                    )
            }
            .overlay {
                if !sound.hasAudioFile {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                        .foregroundColor(.red.opacity(0.7))
                }
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
        .rotationEffect(.degrees(wiggle ? 2 : 0))
        .animation(.spring(response: 0.15, dampingFraction: 0.3), value: wiggle)
    }
}

#Preview {
    HStack {
        SoundButtonView(
            sound: SoundEffect(
                id: "door_knock", nameKo: "똑똑똑 (문 두드리기)", nameEn: "Door Knock",
                emoji: "🚪", fileName: "door_knock", categoryID: "door_house",
                relatedTales: ["빨간모자"], hasAudioFile: false
            ),
            isPlaying: false,
            action: {}
        )
        SoundButtonView(
            sound: SoundEffect(
                id: "ocean_waves", nameKo: "파도 소리", nameEn: "Ocean Waves",
                emoji: "🌊", fileName: "ocean_waves", categoryID: "ocean_water",
                relatedTales: ["인어공주"], hasAudioFile: true
            ),
            isPlaying: true,
            action: {}
        )
    }
    .padding()
}
