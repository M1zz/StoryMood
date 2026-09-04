import SwiftUI

/// 버튼 배경 이미지를 1회만 로드해 재사용 — 렌더링마다 디스크 I/O + JPEG 디코딩 방지
@MainActor
enum SoundImageCache {
    private static var cache: [String: UIImage?] = [:]

    static func image(for fileName: String) -> UIImage? {
        if let cached = cache[fileName] { return cached }
        let url = Bundle.main.url(forResource: fileName, withExtension: "jpg", subdirectory: "SoundImages")
        let image = url.flatMap { UIImage(contentsOfFile: $0.path) }
        cache[fileName] = image
        return image
    }
}

/// 효과음 보드의 동그란 버튼 — 사진 위에 이름을 얹는다.
/// 사진이 없는 효과음은 무드 색 그러데이션 위에 큼직한 이모지로 대신한다.
struct SoundButtonView: View {
    let sound: SoundEffect
    let isPlaying: Bool
    let action: () -> Void
    /// 길게 눌러 "효과음 바꾸기" — 미지정이면 메뉴를 달지 않는다 (프리뷰/재사용용)
    var onEdit: (() -> Void)? = nil

    @State private var isPressed = false
    @State private var wiggle = false

    private var moodColor: Color { sound.primaryMoodColor }
    private var backgroundImage: UIImage? { SoundImageCache.image(for: sound.fileName) }

    /// 다른 소리로 갈아끼운 버튼인가
    private var isCustomized: Bool { SoundCustomizationStore.shared.isCustomized(sound.id) }
    /// 실제로 재생되는 소리 (교체했으면 그 소리)
    private var effectiveSound: SoundEffect { SoundCustomizationStore.shared.effectiveSound(for: sound) }
    /// 교체된 소리에 음원이 있으면 원래 소리에 음원이 없어도 재생된다
    private var canPlay: Bool { SoundEffect.audioURL(for: effectiveSound.fileName) != nil }

    var body: some View {
        Button(action: tapped) {
            VStack(spacing: 6) {
                // 크기는 원(Circle)이 정하고, 사진·글씨는 overlay로 얹는다 —
                // ZStack에 글씨를 넣으면 긴 이름이 원 밖으로 밀려 잘렸다
                Circle()
                    .fill(Color.clear)
                    .aspectRatio(1, contentMode: .fit)
                    .background { circleContent }
                    .overlay {
                        // 글씨가 사진 위에서도 또렷하게 보이도록 아래쪽을 어둡게
                        LinearGradient(
                            colors: [.black.opacity(0.05), .black.opacity(0.28), .black.opacity(0.66)],
                            startPoint: .top, endPoint: .bottom
                        )
                    }
                    .overlay(alignment: .bottom) {
                        Text(sound.nameKo)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.6)
                            .shadow(color: .black.opacity(0.8), radius: 2, y: 1)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 16)
                    }
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(ringColor, lineWidth: ringWidth)
                    }
                    .overlay {
                        if !canPlay {
                            Circle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                                .foregroundColor(.red.opacity(0.8))
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        if isCustomized { customizedBadge }
                    }
                    .shadow(
                        color: isPlaying ? moodColor.opacity(0.55) : .black.opacity(0.15),
                        radius: isPlaying ? 12 : 5,
                        y: isPlaying ? 4 : 2
                    )

                if !canPlay {
                    Text("음원 필요")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.red)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(.red.opacity(0.12)))
                }
            }
        }
        .buttonStyle(.plain)
        .contextMenu { editMenu }
        .scaleEffect(isPressed ? 0.9 : (isPlaying ? 1.04 : 1.0))
        .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPlaying)
        .rotationEffect(.degrees(wiggle ? 2 : 0))
        .animation(.spring(response: 0.15, dampingFraction: 0.3), value: wiggle)
        .accessibilityLabel(isCustomized ? "\(sound.nameKo), \(effectiveSound.nameKo)로 바뀜" : sound.nameKo)
    }

    // MARK: - 효과음 바꾸기

    @ViewBuilder
    private var editMenu: some View {
        if let onEdit {
            Button {
                onEdit()
            } label: {
                Label(isCustomized ? "다른 소리로 바꾸기" : "효과음 바꾸기", systemImage: "arrow.triangle.2.circlepath")
            }

            if isCustomized {
                Text("지금: \(effectiveSound.nameKo)")
                Button(role: .destructive) {
                    SoundCustomizationStore.shared.reset(sound.id)
                } label: {
                    Label("원래 소리로 되돌리기", systemImage: "arrow.uturn.backward")
                }
            }
        }
    }

    /// 갈아끼운 버튼임을 알리는 작은 배지
    private var customizedBadge: some View {
        Image(systemName: "arrow.triangle.2.circlepath")
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(5)
            .background(Circle().fill(BackgroundMusicSet.chipColor))
            .overlay(Circle().stroke(.white.opacity(0.9), lineWidth: 1.5))
            .padding(6)
    }

    // MARK: - Pieces

    @ViewBuilder
    private var circleContent: some View {
        if let img = backgroundImage {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
                .overlay { if isPlaying { moodColor.opacity(0.28) } }
        } else {
            // 사진이 없는 효과음 — 무드 색 그러데이션 + 큼직한 이모지
            ZStack {
                LinearGradient(
                    colors: [moodColor.opacity(isPlaying ? 0.85 : 0.65),
                             moodColor.opacity(isPlaying ? 0.55 : 0.35)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                Text(sound.emoji)
                    .font(.system(size: 38))
                    .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 18)
            }
        }
    }

    private var ringColor: Color {
        if !canPlay { return .clear }   // 빨간 점선 테두리가 따로 그려진다
        return isPlaying ? moodColor : .white.opacity(0.35)
    }

    private var ringWidth: CGFloat { isPlaying ? 3.5 : 1 }

    // MARK: - Action

    private func tapped() {
        isPressed = true
        action()

        UIImpactFeedbackGenerator(style: canPlay ? .medium : .heavy).impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { isPressed = false }

        if !canPlay {
            withAnimation(.default) { wiggle = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { wiggle = false }
        }
    }
}

#Preview {
    HStack(spacing: 12) {
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
    .frame(height: 140)
    .padding()
}
