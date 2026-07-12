import SwiftUI

// MARK: - StoryModeView (Tab root)

struct StoryModeView: View {
    let audioManager: AudioManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Text("이야기를 읽으며 큐 단어를 말하면\n자동으로 효과음이 재생돼요")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                    ForEach(StoryScript.allScripts) { script in
                        NavigationLink {
                            StoryDetailView(script: script, audioManager: audioManager)
                                .navigationTitle(script.titleKo)
                        } label: {
                            StoryCardView(script: script)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("📖 이야기 모드")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Story Card

private struct StoryCardView: View {
    let script: StoryScript

    var body: some View {
        HStack(spacing: 14) {
            Text(script.emoji)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(script.titleKo)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                Text(script.titleEn)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                Text(script.synopsis)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .padding(.top, 2)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("\(script.cues.count)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.blue)
                Text("큐")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
        }
    }
}

// MARK: - Story Detail View

struct StoryDetailView: View {
    let script: StoryScript
    @Bindable var audioManager: AudioManager
    @State private var storyManager: StoryModeManager
    @State private var editingCueIndex: IdentifiableIndex?

    init(script: StoryScript, audioManager: AudioManager) {
        self.script = script
        self.audioManager = audioManager
        _storyManager = State(initialValue: StoryModeManager(audioManager: audioManager))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // 상단: 시작/듣는중 섹션
                topSection
                    .background(Color(.systemBackground))

                Divider()

                // 큐 목록 (항상 표시, 스크롤 가능)
                cueList
            }

            // 하단 플로팅 영역
            VStack(spacing: 0) {
                // 음원 컨트롤 바 (소리 재생 중일 때)
                if audioManager.currentlyPlaying != nil {
                    PlaybackControlBar(audioManager: audioManager)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // 이야기 종료 버튼
                if storyManager.isListening || storyManager.storyState == .finished {
                    stopButton
                }
            }
            .animation(.easeInOut(duration: 0.2), value: audioManager.currentlyPlaying?.id)
        }
        .navigationTitle(script.titleKo)
        .navigationBarTitleDisplayMode(.inline)
        .alert("오류", isPresented: errorBinding) {
            Button("확인") { storyManager.stopStory() }
        } message: {
            if case .error(let msg) = storyManager.storyState {
                Text(msg)
            }
        }
        .onChange(of: storyManager.storyState) { _, state in
            if state == .finished { }
        }
        .sheet(item: $editingCueIndex) { item in
            let cue = storyManager.cues[item.value]
            let soundID = storyManager.effectiveSoundID(for: cue) ?? cue.soundID ?? ""
            SoundPickerSheet(cue: cue, storyID: script.id, currentSoundID: soundID)
        }
    }

    // MARK: Top Section

    private var topSection: some View {
        VStack(spacing: 12) {
            // 이야기 소개
            HStack(spacing: 12) {
                Text(script.emoji)
                    .font(.system(size: 36))
                Text(script.synopsis)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 16)

            // 시작 / 듣는 중 상태 버튼
            switch storyManager.storyState {
            case .idle, .finished:
                Button {
                    storyManager.startStory(script)
                } label: {
                    Label(
                        storyManager.storyState == .finished ? "다시 시작" : "이야기 시작",
                        systemImage: "mic.fill"
                    )
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 16)

            case .requestingPermission:
                HStack(spacing: 8) {
                    ProgressView().tint(.blue)
                    Text("권한 확인 중...")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)

            case .listening:
                listeningIndicator

            case .error:
                Button {
                    storyManager.startStory(script)
                } label: {
                    Label("다시 시도", systemImage: "arrow.clockwise")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 14)
    }

    // MARK: Listening Indicator

    private var listeningIndicator: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                // 애니메이션 점
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(Color.green)
                            .frame(width: 7, height: 7)
                            .opacity(0.4 + 0.6 * (storyManager.isListening ? 1 : 0))
                    }
                }
                Text("듣는 중...")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.green)

                Spacer()

                Text("\(storyManager.currentCueIndex)/\(storyManager.cues.count) 완료")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            // 인식된 텍스트
            if !storyManager.recognizedText.isEmpty {
                HStack {
                    Image(systemName: "waveform")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Text(storyManager.recognizedText)
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                        .truncationMode(.head)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.green.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }

    // MARK: Cue List

    private var cueList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(storyManager.cues.enumerated()), id: \.element.id) { index, cue in
                        CueRowView(
                            cue: cue,
                            index: index,
                            isCurrent: index == storyManager.currentCueIndex
                                       && cue.hasCue
                                       && storyManager.isListening,
                            isListening: storyManager.isListening,
                            effectiveSoundID: storyManager.effectiveSoundID(for: cue),
                            isCustomized: cue.hasCue && StoryCustomizationStore.shared.isCustomized(cueID: cue.id, story: script.id),
                            onManualPlay: { storyManager.manualPlay(at: index) },
                            onEdit: { editingCueIndex = IdentifiableIndex(index) }
                        )
                        .id(index)
                    }

                    // 완료 메시지
                    if storyManager.storyState == .finished {
                        Label("이야기 끝!", systemImage: "star.fill")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(.yellow)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, storyManager.isListening ? 100 : 24)
            }
            .onChange(of: storyManager.currentCueIndex) { _, newIndex in
                guard newIndex < storyManager.cues.count else { return }
                withAnimation(.easeInOut(duration: 0.4)) {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
    }

    // MARK: Stop Button

    private var stopButton: some View {
        Button {
            storyManager.stopStory()
        } label: {
            Label("이야기 종료", systemImage: "stop.fill")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red.opacity(0.9))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .red.opacity(0.25), radius: 8, y: 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .background(.ultraThinMaterial)
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { if case .error = storyManager.storyState { return true }; return false },
            set: { _ in }
        )
    }
}

// MARK: - Cue Row

private struct CueRowView: View {
    let cue: StoryCue
    let index: Int
    let isCurrent: Bool          // 현재 음성 인식 대기 중인 효과음 큐
    let isListening: Bool
    let effectiveSoundID: String?   // nil이면 순수 낭독 문단
    let isCustomized: Bool
    let onManualPlay: () -> Void
    let onEdit: () -> Void

    private var effectiveSound: SoundEffect? {
        guard let id = effectiveSoundID else { return nil }
        return SoundLibrary.shared.allSounds.first { $0.id == id }
    }

    /// 본문을 키워드 기준으로 분리해 SwiftUI Text로 강조 합성
    private func makeBodyText() -> Text {
        guard let keyword = cue.keyword else {
            // 낭독 문단: 키워드 없음
            return Text(cue.text)
                .font(.system(size: 15))
                .foregroundColor(Color.primary)
        }
        let keywordColor: Color = cue.isCompleted ? .secondary : .blue
        let parts = cue.text.components(separatedBy: keyword)
        var result = Text("")
        for (i, part) in parts.enumerated() {
            result = result + Text(part)
                .font(.system(size: 15))
                .foregroundColor(cue.isCompleted ? Color.secondary : Color.primary)
            if i < parts.count - 1 {
                result = result + Text(keyword)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(keywordColor)
            }
        }
        return result
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // 번호 배지 — 낭독 문단은 회색 점, 효과음 큐는 번호/체크
            ZStack {
                Circle()
                    .fill(badgeColor.opacity(0.15))
                if cue.hasCue {
                    if cue.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.green)
                    } else {
                        Image(systemName: "music.note")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(badgeColor)
                    }
                } else {
                    // 낭독 문단 번호
                    Text("\(index + 1)")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.secondary)
                }
            }
            .frame(width: 26, height: 26)
            .padding(.top, 2)

            VStack(alignment: .leading, spacing: 8) {

                // 낭독 본문 (효과음 큐면 키워드 강조)
                HStack(alignment: .top, spacing: 6) {
                    makeBodyText()
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                    if isCurrent {
                        Image(systemName: "ear.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.blue)
                            .symbolEffect(.pulse)
                            .padding(.top, 2)
                    }
                }

                // 효과음 태그 (효과음 큐 문단만 표시)
                if let sound = effectiveSound {
                    HStack(spacing: 4) {
                        Text(sound.emoji).font(.system(size: 11))
                        Text(sound.nameKo)
                            .font(.system(size: 11, weight: isCustomized ? .semibold : .regular))
                            .foregroundStyle(isCustomized ? Color.orange : Color.secondary)
                        if isCustomized {
                            Image(systemName: "pencil")
                                .font(.system(size: 9))
                                .foregroundStyle(Color.orange)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                }
            }

            Spacer(minLength: 4)

            // 편집·재생 버튼 — 효과음 큐 문단에만 표시
            if cue.hasCue {
                VStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 22))
                            .foregroundStyle(isCustomized ? Color.orange : Color.secondary.opacity(0.6))
                    }
                    .buttonStyle(.plain)

                    Button(action: onManualPlay) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(cue.isCompleted ? Color.secondary.opacity(0.4) : Color.blue)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(rowBackground)
                .overlay {
                    if isCurrent {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.blue.opacity(0.4), lineWidth: 1.5)
                    }
                }
        }
        // 낭독 문단은 흐림 없음, 효과음 큐만 완료 시 흐려짐
        .opacity(cue.hasCue && cue.isCompleted ? 0.4 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isCurrent)
        .animation(.easeInOut(duration: 0.3), value: cue.isCompleted)
    }

    private var badgeColor: Color {
        if !cue.hasCue { return .gray }
        if cue.isCompleted { return .green }
        if isCurrent { return .blue }
        return .orange
    }

    private var rowBackground: Color {
        if isCurrent { return Color.blue.opacity(0.06) }
        if cue.hasCue { return Color(.systemBackground) }
        return Color.clear   // 낭독 문단은 배경 없이 자연스럽게
    }
}

// MARK: - IdentifiableIndex

private struct IdentifiableIndex: Identifiable {
    let id = UUID()
    let value: Int
    init(_ value: Int) { self.value = value }
}

// MARK: - Sound Picker Sheet

private struct SoundPickerSheet: View {
    let cue: StoryCue
    let storyID: String
    let currentSoundID: String

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedID: String

    init(cue: StoryCue, storyID: String, currentSoundID: String) {
        self.cue = cue
        self.storyID = storyID
        self.currentSoundID = currentSoundID
        _selectedID = State(initialValue: currentSoundID)
    }

    private var filteredSounds: [SoundEffect] {
        let all = SoundLibrary.shared.allSounds
        guard !searchText.isEmpty else { return all }
        return all.filter {
            $0.nameKo.localizedCaseInsensitiveContains(searchText) ||
            $0.nameEn.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 현재 큐 정보
                HStack(spacing: 8) {
                    Text("큐:")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text("\"\(cue.keyword ?? "")\"")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                    Spacer()
                    if let defaultID = cue.soundID, selectedID != defaultID {
                        Button("기본값으로") {
                            selectedID = defaultID
                        }
                        .font(.system(size: 12))
                        .foregroundStyle(.orange)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))

                // 검색
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("소리 검색...", text: $searchText)
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

                // 사운드 목록
                List(filteredSounds) { sound in
                    Button {
                        selectedID = sound.id
                    } label: {
                        HStack(spacing: 10) {
                            Text(sound.emoji)
                                .font(.system(size: 20))
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(sound.nameKo)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.primary)
                                Text(sound.nameEn)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if sound.id == selectedID {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(sound.id == selectedID ? Color.blue.opacity(0.06) : nil)
                }
                .listStyle(.plain)
            }
            .navigationTitle("소리 변경")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("적용") {
                        if selectedID == cue.soundID {
                            StoryCustomizationStore.shared.reset(cueID: cue.id, story: storyID)
                        } else {
                            StoryCustomizationStore.shared.set(soundID: selectedID,
                                                               forCue: cue.id, story: storyID)
                        }
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

// MARK: - Playback Control Bar

private struct PlaybackControlBar: View {
    @Bindable var audioManager: AudioManager

    private var progress: Double {
        guard audioManager.soundDuration > 0 else { return 0 }
        return audioManager.soundCurrentTime / audioManager.soundDuration
    }

    var body: some View {
        VStack(spacing: 8) {
            // 사운드 정보 + 정지 버튼
            HStack(spacing: 10) {
                if let sound = audioManager.currentlyPlaying {
                    Text(sound.emoji)
                        .font(.system(size: 20))
                        .scaleEffect(audioManager.isPlaying ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                                   value: audioManager.isPlaying)

                    VStack(alignment: .leading, spacing: 1) {
                        Text(sound.nameKo)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                        // 현재시간 / 전체시간
                        Text("\(formatTime(audioManager.soundCurrentTime)) / \(formatTime(audioManager.soundDuration))")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button { audioManager.stop() } label: {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
            }

            // 재생 진행 바 (탭으로 탐색 가능)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 4)
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * progress, height: 4)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let ratio = max(0, min(1, value.location.x / geo.size.width))
                            audioManager.seekSound(to: audioManager.soundDuration * ratio)
                        }
                )
            }
            .frame(height: 4)

            // 볼륨 슬라이더
            HStack(spacing: 8) {
                Image(systemName: "speaker.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)

                Slider(value: $audioManager.soundVolume, in: 0...1)
                    .tint(.blue)

                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)

                Text("\(Int(audioManager.soundVolume * 100))%")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(width: 34, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    private func formatTime(_ t: TimeInterval) -> String {
        guard t.isFinite && !t.isNaN else { return "0:00" }
        let s = Int(t)
        return String(format: "%d:%02d", s / 60, s % 60)
    }
}

// MARK: - Preview

#Preview("Story Mode Tab") {
    StoryModeView(audioManager: AudioManager())
}

#Preview("Story Detail") {
    NavigationStack {
        StoryDetailView(script: StoryScript.hanselAndGretel, audioManager: AudioManager())
    }
}
