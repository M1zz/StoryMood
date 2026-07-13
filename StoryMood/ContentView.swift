import SwiftUI

struct ContentView: View {
    @State private var audioManager = AudioManager()

    var body: some View {
        // 이 앱의 정체성은 "이야기를 읽어 주면 알맞은 타이밍에 효과음이 나는 도구"
        // — 이야기가 첫 화면, 효과음 보드는 보조 도구
        TabView {
            StoryModeView(audioManager: audioManager)
                .tabItem {
                    Label("이야기", systemImage: "book.fill")
                }

            SoundLibraryView(audioManager: audioManager)
                .tabItem {
                    Label("효과음 보드", systemImage: "music.note.list")
                }
        }
        .onAppear {
            // 공연 중 화면 자동 잠금 방지
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}

// MARK: - Sound Library Tab

private struct SoundLibraryView: View {
    @Bindable var audioManager: AudioManager

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            ScrollView {
                VStack(spacing: 12) {
                    // Header
                    HeaderView(
                        totalCount: audioManager.totalSoundCount,
                        missingCount: audioManager.missingCount,
                        availableCount: audioManager.availableCount,
                        showMissingOnly: $audioManager.showMissingOnly,
                        showTaleList: $audioManager.showTaleList
                    )

                    // Search bar
                    SearchBarView(text: $audioManager.searchText)

                    // Mood tabs
                    MoodTabView(
                        moods: audioManager.moods,
                        selectedMood: audioManager.selectedMood,
                        isBGMPlaying: audioManager.isBGMPlaying,
                        onSelect: { audioManager.selectMood($0) }
                    )

                    // Mood description
                    if let mood = audioManager.selectedMood {
                        HStack {
                            Text(mood.description)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(audioManager.filteredSounds.count)개")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(mood.color)
                        }
                        .padding(.horizontal, 16)
                        .transition(.opacity)
                    }

                    // Legend
                    LegendView()

                    // Sound grid
                    SoundGridView(
                        sounds: audioManager.filteredSounds,
                        currentlyPlaying: audioManager.currentlyPlaying,
                        onTap: { audioManager.play($0) }
                    )
                }
            }

            // 고정 하단 레이어
            VStack(spacing: 0) {
                if audioManager.isBGMPlaying, let mood = audioManager.selectedMood {
                    BGMVolumeBar(
                        volume: Binding(
                            get: { audioManager.bgmVolume },
                            set: { audioManager.bgmVolume = $0 }
                        ),
                        color: mood.color
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                NowPlayingView(
                    sound: audioManager.currentlyPlaying,
                    isPlaying: audioManager.isPlaying,
                    onStop: { audioManager.stop() }
                )
            }
            .animation(.easeInOut(duration: 0.25), value: audioManager.isBGMPlaying)
        }
        .sheet(isPresented: $audioManager.showTaleList) {
            TaleListView()
        }
    }
}

// MARK: - Search Bar

private struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("소리 또는 동화 이름으로 검색...", text: $text)
                .font(.system(size: 14))
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - BGM Volume Bar

private struct BGMVolumeBar: View {
    @Binding var volume: Float
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "speaker.fill")
                .font(.system(size: 11))
                .foregroundStyle(color)

            Slider(value: $volume, in: 0...1)
                .tint(color)

            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 11))
                .foregroundStyle(color)

            // 퍼센트 표시
            Text("\(Int(volume * 100))%")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(color)
                .frame(width: 34, alignment: .trailing)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(color.opacity(0.08))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                }
        }
    }
}

// MARK: - Legend

private struct LegendView: View {
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                    .frame(width: 20, height: 14)
                Text("= 음원 미등록 (빨간 테두리)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
                    .frame(width: 20, height: 14)
                Text("= 음원 등록됨")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Tale List Sheet

private struct TaleListView: View {
    @Environment(\.dismiss) private var dismiss
    let tales = FairyTaleReference.allTales
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("이 앱의 사운드는 아래 100권의 동화를 분석하여 구성되었습니다.")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                
                ForEach(tales) { tale in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(tale.nameKo)
                                .font(.system(size: 14, weight: .semibold))
                            Text(tale.nameEn)
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(tale.origin)
                            .font(.system(size: 10, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(Color(.tertiarySystemBackground))
                            )
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("📚 참고 동화 100권")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
