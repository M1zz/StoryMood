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
    /// 소리를 갈아끼우는 중인 버튼
    @State private var editingSound: SoundEffect?

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
                        isBackgroundMusicOnly: audioManager.showBackgroundMusicOnly,
                        onSelect: { audioManager.selectMood($0) },
                        onSelectBackgroundMusic: { audioManager.toggleBackgroundMusicCategory() }
                    )

                    // 배경음악 카테고리 설명
                    if audioManager.showBackgroundMusicOnly {
                        HStack {
                            Text(BackgroundMusicSet.chipDescription)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(audioManager.filteredSounds.count)개")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(BackgroundMusicSet.chipColor)
                        }
                        .padding(.horizontal, 16)
                        .transition(.opacity)
                    }

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
                        onTap: { audioManager.play($0) },
                        onEdit: { editingSound = $0 }
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
        .sheet(item: $editingSound) { sound in
            SoundReplacementSheet(sound: sound, audioManager: audioManager)
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
            
            HStack(spacing: 4) {
                Image(systemName: "hand.tap")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.secondary)
                Text("길게 누르면 소리 바꾸기")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - 효과음 갈아끼우기 시트

private struct SoundReplacementSheet: View {
    let sound: SoundEffect
    @Bindable var audioManager: AudioManager

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedID: String

    init(sound: SoundEffect, audioManager: AudioManager) {
        self.sound = sound
        self.audioManager = audioManager
        _selectedID = State(initialValue:
            SoundCustomizationStore.shared.replacementID(for: sound.id) ?? sound.id)
    }

    /// 음원이 있는 소리만 고를 수 있다
    private var candidates: [SoundEffect] {
        let all = SoundLibrary.shared.allSounds.filter { $0.hasAudioFile }
        guard !searchText.isEmpty else { return all }
        return all.filter {
            $0.nameKo.localizedCaseInsensitiveContains(searchText) ||
            $0.nameEn.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                // 검색
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("바꿔 넣을 소리 검색...", text: $searchText)
                        .font(.system(size: 14))
                        .autocorrectionDisabled()
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                List(candidates) { candidate in
                    HStack(spacing: 10) {
                        Button {
                            selectedID = candidate.id
                        } label: {
                            HStack(spacing: 10) {
                                Text(candidate.emoji)
                                    .font(.system(size: 20))
                                    .frame(width: 32)

                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Text(candidate.nameKo)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(.primary)
                                        if candidate.id == sound.id {
                                            Text("원래 소리")
                                                .font(.system(size: 10, weight: .bold))
                                                .padding(.horizontal, 5)
                                                .padding(.vertical, 1)
                                                .background(Capsule().fill(.orange.opacity(0.15)))
                                                .foregroundStyle(.orange)
                                        }
                                        if candidate.isBackgroundMusic {
                                            Text("배경음악")
                                                .font(.system(size: 10, weight: .bold))
                                                .padding(.horizontal, 5)
                                                .padding(.vertical, 1)
                                                .background(Capsule().fill(BackgroundMusicSet.chipColor.opacity(0.15)))
                                                .foregroundStyle(BackgroundMusicSet.chipColor)
                                        }
                                    }
                                    Text(candidate.nameEn)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if candidate.id == selectedID {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        // 미리 듣기 — 고르기 전에 소리부터 확인 (그 소리의 원본 파일로)
                        Button {
                            audioManager.play(candidate, useCustomization: false)
                        } label: {
                            Image(systemName: audioManager.currentlyPlaying?.id == candidate.id
                                  ? "stop.circle.fill" : "play.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                    .listRowBackground(candidate.id == selectedID ? Color.blue.opacity(0.06) : nil)
                }
                .listStyle(.plain)
            }
            .navigationTitle("효과음 바꾸기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        audioManager.stop()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("적용") {
                        SoundCustomizationStore.shared.set(replacementID: selectedID, for: sound.id)
                        audioManager.stop()
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: 10) {
            Text(sound.emoji).font(.system(size: 24))

            VStack(alignment: .leading, spacing: 2) {
                Text(sound.nameKo)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                HStack(spacing: 4) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                    Text(SoundLibrary.shared.soundsByID[selectedID]?.nameKo ?? sound.nameKo)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(selectedID == sound.id ? .secondary : BackgroundMusicSet.chipColor)
                }
            }

            Spacer()

            if selectedID != sound.id {
                Button("되돌리기") { selectedID = sound.id }
                    .font(.system(size: 12))
                    .foregroundStyle(.orange)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
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
