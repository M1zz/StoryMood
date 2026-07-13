import SwiftUI

// MARK: - StoryModeView (Tab root)

struct StoryModeView: View {
    let audioManager: AudioManager
    @AppStorage("hide_story_howto") private var hideHowTo = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    // 앱 정체성 헤더 — 이 앱이 무엇을 해 주는지 첫 화면에서 한 문장으로
                    VStack(alignment: .leading, spacing: 4) {
                        Text("아이에게 들려줄 이야기를 골라 주세요")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        Text("소리 내어 읽어 주기만 하면, 알맞은 순간에 효과음과 음악이 함께해요")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    if !hideHowTo {
                        HowToCard { hideHowTo = true }
                    }

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
                // 아이패드에서 카드가 화면 폭 전체로 늘어나지 않게 제한 (가운데 정렬)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("📖 오늘의 이야기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - How To Card (처음 사용자 안내)

private struct HowToCard: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("이렇게 사용해요", systemImage: "sparkles")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.blue)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary.opacity(0.5))
                }
                .buttonStyle(.plain)
            }

            howToStep(number: "1", text: "이야기를 고르고 [이야기 시작]을 눌러요")
            howToStep(number: "2", text: "대본을 아이에게 소리 내어 읽어 주세요")
            howToStep(number: "3", text: "파란 굵은 단어를 말하면 효과음이 저절로 나와요")

            Label("소리가 안 나왔을 땐 문단 옆 ▶︎ 버튼을 누르면 돼요", systemImage: "lightbulb")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.blue.opacity(0.06))
        }
        .padding(.horizontal, 16)
    }

    private func howToStep(number: String, text: String) -> some View {
        HStack(spacing: 8) {
            Text(number)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 18, height: 18)
                .background(Circle().fill(Color.blue))
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Story Card

private struct StoryCardView: View {
    let script: StoryScript

    /// 낭독 예상 시간(분) — 동화 구연 속도 분당 약 220자 기준
    private var estimatedMinutes: Int {
        let totalChars = script.cues.reduce(0) { $0 + $1.text.count }
        return max(1, Int((Double(totalChars) / 220.0).rounded()))
    }

    private var soundCueCount: Int {
        script.cues.filter(\.hasCue).count
    }

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
                Text(script.synopsis)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack(spacing: 10) {
                    Label("약 \(estimatedMinutes)분", systemImage: "clock")
                    Label("효과음 \(soundCueCount)개", systemImage: "speaker.wave.2.fill")
                }
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.blue)
                .padding(.top, 2)
            }

            Spacer()

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
    /// 가로 배치 여부 — 아이패드는 가로 회전해도 size class가 .regular이므로
    /// 실제 창 크기(가로 > 세로)로 판단한다. Split View에서도 창 모양 기준으로 동작.
    @State private var isLandscapeWindow = false
    /// "다음 큐" 칩을 탭했을 때 해당 문단으로 스크롤하기 위한 타깃
    @State private var pendingScrollTarget: Int?
    /// 가로(프롬프터) 모드 본문 글자 크기 — 보면대 거리에 맞게 조절, 기기에 저장
    @AppStorage("prompter_font_size") private var prompterFontSize: Double = 22

    private var isPrompter: Bool { isLandscapeWindow }

    init(script: StoryScript, audioManager: AudioManager) {
        self.script = script
        self.audioManager = audioManager
        _storyManager = State(initialValue: StoryModeManager(audioManager: audioManager))
    }

    var body: some View {
        GeometryReader { geo in
            Group {
                if isPrompter {
                    landscapeLayout
                } else {
                    portraitLayout
                }
            }
            .onAppear {
                isLandscapeWindow = geo.size.width > geo.size.height
                // 권한 팝업이 공연 시작 순간에 뜨지 않도록 미리 요청
                storyManager.preflightPermissions()
            }
            .onChange(of: geo.size) { _, size in
                isLandscapeWindow = size.width > size.height
            }
        }
        .navigationTitle(script.titleKo)
        .navigationBarTitleDisplayMode(.inline)
        // 프롬프터 모드는 내비게이션 바·탭 바까지 숨겨 화면 전체를 대본에 사용
        // (세로로 돌리면 다시 나타남)
        .toolbar(isPrompter ? .hidden : .automatic, for: .navigationBar)
        .toolbar(isPrompter ? .hidden : .automatic, for: .tabBar)
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
            SoundPickerSheet(cue: cue, storyID: script.id, currentSoundID: soundID,
                             currentDelay: storyManager.effectiveDelay(for: cue))
        }
    }

    // MARK: Layouts

    /// 세로: 위 컨트롤 + 아래 큐 목록, 하단 플로팅 바
    private var portraitLayout: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                topSection
                    .background(Color(.systemBackground))

                Divider()

                cueList
            }

            VStack(spacing: 0) {
                if audioManager.currentlyPlaying != nil {
                    PlaybackControlBar(audioManager: audioManager)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if storyManager.isListening || storyManager.storyState == .finished {
                    stopButton(bottomPadding: 32)
                        .background(.ultraThinMaterial)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: audioManager.currentlyPlaying?.id)
        }
    }

    /// 가로(공연 프롬프터): 화면 전체가 큐시트 — 컨트롤은 상단 얇은 바 하나로 최소화
    private var landscapeLayout: some View {
        ZStack(alignment: .top) {
            cueList

            prompterTopBar

            // 시작 전에는 화면 한가운데 큰 시작 버튼
            if storyManager.storyState == .idle || storyManager.storyState == .finished {
                prompterStartOverlay
            }

            // 소리 재생 중엔 오른쪽 아래 큰 정지 버튼 — 공연 중 바로 누를 수 있게
            if audioManager.currentlyPlaying != nil {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        prompterStopButton
                    }
                }
                .padding(24)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: audioManager.currentlyPlaying?.id)
        .animation(.easeInOut(duration: 0.2), value: storyManager.storyState)
    }

    /// 화면 중앙의 큰 시작 버튼 (프롬프터 전용)
    private var prompterStartOverlay: some View {
        VStack(spacing: 14) {
            Button {
                storyManager.startStory(script)
            } label: {
                Label(
                    storyManager.storyState == .finished ? "다시 시작" : "이야기 시작",
                    systemImage: "mic.fill"
                )
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .padding(.horizontal, 48)
                .padding(.vertical, 20)
                .background(Color.blue, in: Capsule())
                .foregroundStyle(.white)
                .shadow(color: .blue.opacity(0.35), radius: 12, y: 6)
            }
            .buttonStyle(.plain)

            Text("마이크가 목소리를 들으며 파란 굵은 단어에서 효과음을 틀어 줘요")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            secondaryActions
        }
        .padding(28)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    /// 크고 누르기 쉬운 소리 정지 버튼 (프롬프터 전용)
    private var prompterStopButton: some View {
        Button {
            audioManager.stop()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 28, weight: .bold))
                Text("소리 멈춤")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(width: 92, height: 92)
            .background(Circle().fill(Color.red.opacity(0.9)))
            .shadow(color: .red.opacity(0.35), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }

    /// 프롬프터 상단 바 — 시작/종료, 진행 상태, 재생 중 효과음 칩, 글자 크기
    /// + 듣는 중일 때 대기 키워드·인식된 말 표시 줄
    private var prompterTopBar: some View {
        VStack(spacing: 0) {
            prompterControlRow
            PrompterListeningInfo(
                storyManager: storyManager,
                onKeywordTap: { pendingScrollTarget = storyManager.awaitingCueIndex },
                onKeywordLongPress: {
                    if let i = storyManager.awaitingCueIndex { storyManager.manualPlay(at: i) }
                }
            )
        }
    }

    private var prompterControlRow: some View {
        HStack(spacing: 12) {
            switch storyManager.storyState {
            case .idle, .finished:
                Button {
                    storyManager.startStory(script)
                } label: {
                    Label(storyManager.storyState == .finished ? "다시 시작" : "이야기 시작",
                          systemImage: "mic.fill")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

            case .requestingPermission:
                ProgressView().tint(.blue)

            case .listening:
                Button {
                    storyManager.stopStory()
                } label: {
                    Label("종료", systemImage: "stop.fill")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.red.opacity(0.9))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                HStack(spacing: 6) {
                    Circle()
                        .fill(storyManager.isRehearsal ? Color.orange : Color.green)
                        .frame(width: 8, height: 8)
                    Text(storyManager.isRehearsal ? "리허설 중" : "듣는 중")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(storyManager.isRehearsal ? .orange : .green)
                    Text("\(storyManager.currentCueIndex)/\(storyManager.cues.count)")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }

            case .error:
                Button {
                    storyManager.startStory(script)
                } label: {
                    Label("다시 시도", systemImage: "arrow.clockwise")
                        .font(.system(size: 13, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }

            Spacer()

            // 재생 중인 효과음 — 이름과 정지 버튼만 컴팩트하게
            if let sound = audioManager.currentlyPlaying {
                HStack(spacing: 6) {
                    Text(sound.emoji).font(.system(size: 14))
                    Text(sound.nameKo)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                    Button { audioManager.stop() } label: {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(.secondarySystemBackground))
                .clipShape(Capsule())
                .transition(.opacity)
            }

            fontSizeButtons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .animation(.easeInOut(duration: 0.2), value: audioManager.currentlyPlaying?.id)
    }

    // MARK: Secondary Actions (시작 전 보조 기능)

    /// 이어서 하기 · 리허설 · 사운드 체크
    private var secondaryActions: some View {
        HStack(spacing: 8) {
            if storyManager.storyState == .idle,
               let saved = StoryModeManager.savedProgress(for: script.id),
               saved + 1 < script.cues.count {
                secondaryActionButton("이어서 하기", systemImage: "arrow.uturn.forward") {
                    storyManager.startStory(script, resumeFrom: saved)
                }
            }

            secondaryActionButton("리허설", systemImage: "hand.tap") {
                storyManager.startRehearsal(script)
            }

            secondaryActionButton("사운드 체크", systemImage: "speaker.wave.2") {
                soundCheck()
            }
        }
    }

    private func secondaryActionButton(_ title: String, systemImage: String,
                                       action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    /// 공연장 스피커·볼륨 확인 — 짧은 효과음 뒤에 음악을 이어 재생
    private func soundCheck() {
        if let chime = SoundLibrary.shared.soundsByID["magic_chime"] {
            audioManager.play(chime)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let music = SoundLibrary.shared.soundsByID["once_upon_time"] {
                audioManager.play(music)
            }
        }
    }

    // MARK: Font Size Buttons (가로 프롬프터 전용)

    private var fontSizeButtons: some View {
        HStack(spacing: 6) {
            Button {
                prompterFontSize = max(18, prompterFontSize - 2)
            } label: {
                Image(systemName: "textformat.size.smaller")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 36, height: 30)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .disabled(prompterFontSize <= 18)

            Button {
                prompterFontSize = min(34, prompterFontSize + 2)
            } label: {
                Image(systemName: "textformat.size.larger")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 36, height: 30)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .disabled(prompterFontSize >= 34)
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
                VStack(spacing: 8) {
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

                    Text("마이크가 목소리를 들으며 파란 굵은 단어가 나오는 순간 효과음을 틀어 줘요")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    secondaryActions
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
                ListeningStatusView(
                    storyManager: storyManager,
                    onKeywordTap: { pendingScrollTarget = storyManager.awaitingCueIndex },
                    onKeywordLongPress: {
                        if let i = storyManager.awaitingCueIndex { storyManager.manualPlay(at: i) }
                    }
                )

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

    // MARK: Cue List

    /// 지금 읽어야 하는 문단 구간 — 마지막 발동 큐 다음 문단부터
    /// 다음 효과음 큐 문단까지. 소리가 날 때마다 다음 구간으로 넘어간다.
    private var readingRange: ClosedRange<Int>? {
        guard storyManager.isListening, !storyManager.cues.isEmpty else { return nil }
        let start = (storyManager.lastCompletedCueIndex ?? -1) + 1
        guard start < storyManager.cues.count else { return nil }
        var end = start
        while end < storyManager.cues.count && !storyManager.cues[end].hasCue {
            end += 1
        }
        end = min(end, storyManager.cues.count - 1)
        return start...end
    }

    private var cueList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(storyManager.cues.enumerated()), id: \.element.id) { index, cue in
                        CueRowView(
                            cue: cue,
                            index: index,
                            isCurrent: index == storyManager.awaitingCueIndex,
                            isListening: storyManager.isListening,
                            effectiveSoundID: storyManager.effectiveSoundID(for: cue),
                            effectiveDelay: storyManager.effectiveDelay(for: cue),
                            isCustomized: cue.hasCue && StoryCustomizationStore.shared.isCustomized(cueID: cue.id, story: script.id),
                            bodyFontSize: isPrompter ? CGFloat(prompterFontSize) : 15,
                            isReading: readingRange?.contains(index) ?? false,
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
                // 프롬프터 모드: 좌우 여백을 넓혀 긴 줄의 가독성 확보, 상단 바 아래에서 시작
                .padding(.horizontal, isPrompter ? 44 : 16)
                // 듣는 중엔 상단 바가 2줄(컨트롤+키워드)이라 목록 시작을 더 내림
                .padding(.top, isPrompter ? (storyManager.isListening ? 92 : 58) : 12)
                .padding(.bottom, (!isPrompter && storyManager.isListening) ? 100 : 24)
                // 아이패드처럼 넓은 화면에서는 본문 폭을 제한해 시선 이동을 줄임 (가운데 정렬)
                .frame(maxWidth: isPrompter ? 900 : 760)
                .frame(maxWidth: .infinity)
            }
            // 소리 큐가 실제로 발동했을 때만 스크롤 — 다음에 읽을 문단을 가운데로.
            // currentCueIndex 기준으로 스크롤하면 시작하자마자 낭독 문단을 건너뛰고
            // 다음 효과음 큐 문단으로 화면이 튀는 문제가 있었음
            .onChange(of: storyManager.lastCompletedCueIndex) { _, completed in
                guard let completed, !storyManager.cues.isEmpty else { return }
                let next = min(completed + 1, storyManager.cues.count - 1)
                withAnimation(.easeInOut(duration: 0.4)) {
                    proxy.scrollTo(next, anchor: .center)
                }
            }
            // 이야기 (재)시작 시 맨 위 문단부터
            .onChange(of: storyManager.storyState) { _, state in
                if state == .listening && storyManager.lastCompletedCueIndex == nil {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(0, anchor: .top)
                    }
                }
            }
            // "다음 큐" 칩 탭 → 해당 문단으로 스크롤
            .onChange(of: pendingScrollTarget) { _, target in
                guard let target else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(target, anchor: .center)
                }
                pendingScrollTarget = nil
            }
        }
    }

    // MARK: Stop Button

    private func stopButton(bottomPadding: CGFloat) -> some View {
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
        .padding(.bottom, bottomPadding)
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { if case .error = storyManager.storyState { return true }; return false },
            set: { _ in }
        )
    }
}

// MARK: - Prompter Listening Info
// recognizedText는 초당 수 회 갱신되므로 분리된 뷰에서만 읽어
// StoryDetailView 전체(큐 목록 포함)가 매번 리렌더링되지 않게 함

private struct PrompterListeningInfo: View {
    let storyManager: StoryModeManager
    var onKeywordTap: () -> Void = {}
    var onKeywordLongPress: () -> Void = {}

    var body: some View {
        if storyManager.isListening {
            HStack(spacing: 12) {
                // 대기 중인 큐 키워드 — 탭: 해당 문단으로 스크롤, 길게: 즉시 재생
                if let keyword = storyManager.awaitingKeyword {
                    HStack(spacing: 5) {
                        Image(systemName: "ear.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.blue)
                        Text("다음 큐")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        Text("\u{201C}\(keyword)\u{201D}")
                            .font(.system(size: 15, weight: .heavy, design: .rounded))
                            .foregroundStyle(.blue)
                        Text(storyManager.isRehearsal
                             ? "· ▶︎ 버튼이나 길게 눌러 발동해 보세요"
                             : "· 안 나면 외치거나, 길게 눌러 재생")
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onKeywordTap)
                    .onLongPressGesture(perform: onKeywordLongPress)
                }

                Spacer()

                // 지금 듣고 식별한 말 (최근 부분)
                if !storyManager.recognizedText.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "waveform")
                            .font(.system(size: 10))
                            .foregroundStyle(.green)
                        Text(storyManager.recognizedText)
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.head)
                    }
                    .frame(maxWidth: 380, alignment: .trailing)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Listening Status
// recognizedText는 말하는 동안 초당 수 회 갱신되므로,
// 이 뷰로 분리해 StoryDetailView 전체(큐 목록 포함)가 매번 리렌더링되지 않게 함

private struct ListeningStatusView: View {
    let storyManager: StoryModeManager
    var onKeywordTap: () -> Void = {}
    var onKeywordLongPress: () -> Void = {}

    private var accent: Color { storyManager.isRehearsal ? .orange : .green }

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                // 애니메이션 점
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(accent)
                            .frame(width: 7, height: 7)
                            .opacity(0.4 + 0.6 * (storyManager.isListening ? 1 : 0))
                    }
                }
                Text(storyManager.isRehearsal ? "리허설 중 — ▶︎ 버튼으로 진행" : "듣는 중...")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(accent)

                Spacer()

                Text("\(storyManager.currentCueIndex)/\(storyManager.cues.count) 완료")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            // 대기 중인 큐 키워드 — 탭: 해당 문단으로 스크롤, 길게: 즉시 재생
            if let keyword = storyManager.awaitingKeyword {
                HStack(spacing: 5) {
                    Image(systemName: "ear.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.blue)
                    Text("다음 큐")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Text("\u{201C}\(keyword)\u{201D}")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundStyle(.blue)
                    Text(storyManager.isRehearsal
                         ? "· ▶︎ 버튼이나 길게 눌러 발동해 보세요"
                         : "· 안 나면 외치거나, 길게 눌러 재생")
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: onKeywordTap)
                .onLongPressGesture(perform: onKeywordLongPress)
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
        .background(accent.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }
}

// MARK: - Cue Row

private struct CueRowView: View {
    let cue: StoryCue
    let index: Int
    let isCurrent: Bool          // 현재 음성 인식 대기 중인 효과음 큐
    let isListening: Bool
    let effectiveSoundID: String?   // nil이면 순수 낭독 문단
    let effectiveDelay: TimeInterval // 커스터마이징 반영된 재생 지연
    let isCustomized: Bool
    let bodyFontSize: CGFloat    // 세로 15, 가로(프롬프터)는 사용자 조절 값
    let isReading: Bool          // 지금 읽어야 하는 문단 — 굵고 크게 강조
    let onManualPlay: () -> Void
    let onEdit: () -> Void

    /// 프롬프터(가로) 모드 여부 — 버튼·줄간격도 함께 키움
    private var isPrompter: Bool { bodyFontSize > 15 }

    /// 읽는 중 문단은 15% 크게
    private var effectiveFontSize: CGFloat { isReading ? bodyFontSize * 1.15 : bodyFontSize }
    private var bodyWeight: Font.Weight { isReading ? .semibold : .regular }

    private var effectiveSound: SoundEffect? {
        guard let id = effectiveSoundID else { return nil }
        return SoundLibrary.shared.soundsByID[id]
    }

    /// 본문을 키워드 기준으로 분리해 SwiftUI Text로 강조 합성
    private func makeBodyText() -> Text {
        guard let keyword = cue.keyword else {
            // 낭독 문단: 키워드 없음
            return Text(cue.text)
                .font(.system(size: effectiveFontSize, weight: bodyWeight))
                .foregroundColor(Color.primary)
        }
        // 완료된 큐도 본문·키워드 색을 유지 — 낭독은 계속되므로 흐려지면 안 됨.
        // 키워드는 "지금 무장된 큐"만 파란색+밑줄로 활성 표시 —
        // 아직 순서가 오지 않은 큐는 굵은 검정으로만 보여 혼동을 막는다
        let parts = cue.text.components(separatedBy: keyword)
        var result = Text("")
        for (i, part) in parts.enumerated() {
            result = result + Text(part)
                .font(.system(size: effectiveFontSize, weight: bodyWeight))
                .foregroundColor(Color.primary)
            if i < parts.count - 1 {
                var kw = Text(keyword)
                    .font(.system(size: effectiveFontSize, weight: isCurrent ? .heavy : .bold))
                    .foregroundColor(isCurrent ? Color.blue : Color.primary)
                if isCurrent {
                    kw = kw.underline(true, color: .blue)
                }
                result = result + kw
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
                            .font(.system(size: isPrompter ? 13 : 10, weight: .bold))
                            .foregroundStyle(Color.green)
                    } else {
                        Image(systemName: "music.note")
                            .font(.system(size: isPrompter ? 13 : 10, weight: .semibold))
                            .foregroundStyle(badgeColor)
                    }
                } else {
                    // 낭독 문단 번호
                    Text("\(index + 1)")
                        .font(.system(size: isPrompter ? 13 : 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.secondary)
                }
            }
            .frame(width: isPrompter ? 32 : 26, height: isPrompter ? 32 : 26)
            .padding(.top, 2)

            VStack(alignment: .leading, spacing: 8) {

                // 낭독 본문 (효과음 큐면 키워드 강조)
                HStack(alignment: .top, spacing: 6) {
                    makeBodyText()
                        .fixedSize(horizontal: false, vertical: true)
                        // 프롬프터 모드는 글자에 비례해 줄간격도 넓힘
                        .lineSpacing(isPrompter ? bodyFontSize * 0.4 : 4)
                    if isCurrent {
                        Image(systemName: "ear.fill")
                            .font(.system(size: isPrompter ? 17 : 13))
                            .foregroundStyle(Color.blue)
                            .symbolEffect(.pulse)
                            .padding(.top, 2)
                    }
                }

                // 효과음 태그 (효과음 큐 문단만 표시)
                if let sound = effectiveSound {
                    HStack(spacing: 4) {
                        Text(sound.emoji).font(.system(size: isPrompter ? 14 : 11))
                        Text(sound.nameKo)
                            .font(.system(size: isPrompter ? 14 : 11, weight: isCustomized ? .semibold : .regular))
                            .foregroundStyle(isCustomized ? Color.orange : Color.secondary)
                        if effectiveDelay > 0 {
                            // 키워드 인식 후 이만큼 기다렸다가 재생
                            Text(String(format: "⏱%.1f초", effectiveDelay))
                                .font(.system(size: isPrompter ? 13 : 10, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.blue)
                        }
                        if isCustomized {
                            Image(systemName: "pencil")
                                .font(.system(size: isPrompter ? 12 : 9))
                                .foregroundStyle(Color.orange)
                        }
                    }
                    .padding(.horizontal, isPrompter ? 10 : 8)
                    .padding(.vertical, isPrompter ? 5 : 3)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                }
            }

            Spacer(minLength: 4)

            // 편집·재생 버튼 — 효과음 큐 문단에만 표시
            // 프롬프터 모드는 공연 중 오조작 방지·시인성을 위해 버튼을 키움
            if cue.hasCue {
                VStack(spacing: isPrompter ? 12 : 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: isPrompter ? 28 : 22))
                            .foregroundStyle(isCustomized ? Color.orange : Color.secondary.opacity(0.6))
                    }
                    .buttonStyle(.plain)

                    Button(action: onManualPlay) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: isPrompter ? 38 : 28))
                            .foregroundStyle(Color.blue)
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
        // 완료된 큐 문단도 흐려지지 않음 — 완료 표시는 초록 체크 배지로만
        .animation(.easeInOut(duration: 0.3), value: isCurrent)
        .animation(.easeInOut(duration: 0.3), value: cue.isCompleted)
        .animation(.easeInOut(duration: 0.3), value: isReading)
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
    @State private var selectedDelay: Double

    init(cue: StoryCue, storyID: String, currentSoundID: String, currentDelay: Double) {
        self.cue = cue
        self.storyID = storyID
        self.currentSoundID = currentSoundID
        _selectedID = State(initialValue: currentSoundID)
        _selectedDelay = State(initialValue: currentDelay)
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

                // 재생 지연 조절 — 리허설하며 타이밍을 그 자리에서 튜닝
                HStack(spacing: 10) {
                    Text("재생 지연")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Slider(value: $selectedDelay, in: 0...3, step: 0.1)
                        .tint(.blue)

                    Text(String(format: "%.1f초", selectedDelay))
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(.blue)
                        .frame(width: 44, alignment: .trailing)

                    if abs(selectedDelay - cue.delay) > 0.001 {
                        Button("기본") {
                            selectedDelay = cue.delay
                        }
                        .font(.system(size: 12))
                        .foregroundStyle(.orange)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

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
                        if abs(selectedDelay - cue.delay) < 0.001 {
                            StoryCustomizationStore.shared.resetDelay(cueID: cue.id, story: storyID)
                        } else {
                            StoryCustomizationStore.shared.set(delay: selectedDelay,
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
                        // 정지 시에는 단발 애니메이션 — repeatForever가 정지 후에도 남는 버그 방지
                        .animation(
                            audioManager.isPlaying
                                ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true)
                                : .easeInOut(duration: 0.2),
                            value: audioManager.isPlaying
                        )

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
                            .font(.system(size: 38))
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

#Preview("Story Detail — 가로(공연)", traits: .landscapeLeft) {
    NavigationStack {
        StoryDetailView(script: StoryScript.hanselAndGretel, audioManager: AudioManager())
    }
}
