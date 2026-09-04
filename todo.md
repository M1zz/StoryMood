# StoryMood Todo

## ✅ 완료된 작업

- [x] Xcode 프로젝트에 Sounds 폴더 리소스로 추가 (project.pbxproj)
- [x] Xcode 프로젝트에 SoundImages 폴더 리소스로 추가
- [x] SoundMood.swift 모델 생성 (6개 무드, soundMoodMapping)
- [x] `download_sounds.py` 작성 및 실행 — 138개 MP3 다운로드 완료 (Freesound.org)
- [x] `download_images.py` 작성 및 실행 — 138개 JPEG 다운로드 완료 (Pixabay)
- [x] SoundEffect.swift — moodIDs, primaryMoodColor 계산 프로퍼티 추가
- [x] SoundEffect.checkAudioExists() — subdirectory: "Sounds" 지원
- [x] AudioManager.swift — 무드 기반 필터링, 토글 재생, BGM 재생/정지, bgmVolume
- [x] CategoryTabView → MoodTabView 리팩터링 (BGM 재생 중 music.note 펄스 표시)
- [x] SoundButtonView — Pixabay 이미지 배경 + 텍스트 분리 레이아웃 (겹침 해결)
- [x] ContentView — BGM 볼륨 슬라이더 스크롤과 무관하게 하단 고정 (ZStack overlay)

## ✅ 이야기 모드 구현 완료
- [x] StoryScript.swift — 헨젤과 그레텔, 빨간 모자, 신데렐라 큐 데이터
- [x] StoryModeManager.swift — SFSpeechRecognizer 한국어 실시간 음성 인식 + 큐 매칭
- [x] StoryModeView.swift — 이야기 선택 → 큐시트 → 플로팅 종료 버튼
- [x] ContentView.swift — TabView (소리 모음 / 이야기 모드)
- [x] project.pbxproj — 신규 파일 등록 + 마이크/음성인식 권한

## ✅ 공연 전 성능 개선 완료 (2026-07-13)

### 🔴 버벅임 직접 원인 (전부 수정 완료)
- [x] SoundButtonView 이미지 캐싱 — `SoundImageCache`로 1회만 로드 (렌더링마다 디스크 I/O 제거)
- [x] 재생 지연 제거 — `SoundEffect.audioURLByFileName`으로 URL 1회 스캔 + 효과음/BGM 플레이어 캐시 재사용
- [x] repeatForever 애니메이션 좀비 버그 — 정지 시 단발 애니메이션으로 조건 분기 (SoundButtonView, NowPlayingView, PlaybackControlBar 3곳)
- [x] SoundLibrary 초기화 번들 조회 1,380회 → 확장자별 10회 스캔으로 축소
- [x] 이야기 모드 리렌더링 격리 — `ListeningStatusView` 분리, 큐 리스트 LazyVStack, `soundsByID` 딕셔너리 조회

### 🟡 공연 안정성 (전부 반영 완료)
- [x] `isIdleTimerDisabled = true` — 공연 중 화면 자동 잠금 방지 (ContentView.onAppear)
- [x] AVAudioSession 인터럽션(전화/알람) 처리 — 중단 시 UI 동기화, 종료 시 자동 재개
- [x] 효과음/BGM 정지 시 페이드아웃 (효과음 0.15초, BGM 0.4초) — 뚝 끊김 제거
- [x] playbackTimer `.common` 런루프 모드 — 스크롤 중에도 진행 바 갱신

### 🎬 신규: 큐 조기 인식 + 지연 재생
- [x] `StoryCue.delay` 필드 추가 — 키워드 인식 후 지정 시간 뒤 소리 재생 (예: "사냥꾼이" 인식 → 1초 후 효과음)
- [x] 큐 목록에 ⏱ 지연 표시, 수동 재생은 즉시 재생 유지
- [x] 대본 8개 큐에 지연값 적용 (빨간모자 사냥꾼 1.0초 등) — 나머지 큐는 리허설하며 튜닝 필요
- [ ] 리허설하며 큐별 delay 값 실측 튜닝 (음성 인식 자체 지연 ~0.5초 감안)

## ✅ 매끄러운 사용 흐름 6종 (2026-07-14)
- [x] 인식 공백 제거 — 큐 발동 후 재시작 대기 delay+1.5초 → 0.3초 (소리 재생과 무관하게 즉시 재개, 연속 큐 놓침 해결)
- [x] 권한 선요청 — 상세 화면 진입 시 `preflightPermissions()` (공연 시작 순간 팝업 방지)
- [x] 큐별 delay 인앱 튜닝 — 편집 시트에 0~3초 슬라이더, StoryCustomizationStore.delayMap 저장, 큐 태그·재생에 반영
- [x] "다음 큐" 칩 탭 → 해당 문단 스크롤, 길게 누르면 즉시 재생 (프롬프터 + 세로)
- [x] 사운드 체크 버튼 — 효과음(마법 종) + 오프닝 음악 순차 재생
- [x] 리허설 모드 — 마이크 없이 ▶︎로 진행 (주황 "리허설 중" 표시), 마지막 큐 발동 시 자동 종료
- [x] 이어서 하기 — 발동 시마다 진행 저장(UserDefaults), 완주 시 삭제, idle 화면에 "이어서 하기" 버튼

## ✅ 발음 기반 키워드 매칭 (2026-07-13)
- [x] STT 표기 차이로 큐가 안 터지던 문제 수정 — "새들이"가 "세들이"로 인식되면 매칭 실패
- [x] `normalizedForMatching`: 매칭 전 공백·문장부호 제거 + 동일 발음 모음 통일 (ㅐ=ㅔ, ㅒ=ㅖ, ㅙ=ㅚ=ㅞ) — 키워드 표시는 원문 유지

## ✅ 대기 큐 가시화 + 인식 텍스트 표시 + BGM 제한 (2026-07-13)
- [x] 무드 BGM도 10초 제한 (8초에 2초 페이드 시작, stopBGM에 fadeDuration 파라미터)
- [x] `awaitingCueIndex`/`awaitingKeyword` — 무장된(다음 발동 대상) 큐 하나만 활성 표시: 키워드 파란색+밑줄+heavy, 순서 안 온 키워드는 검정 굵은 글씨 (매칭 자체가 순차라 아래쪽 큐 조기 발동은 원래 불가)
- [x] "다음 큐: '키워드' · 소리가 안 나면 외쳐 보세요" 표시 — 프롬프터 상단 2번째 줄 + 세로 듣는중 패널
- [x] 실시간 인식 텍스트를 프롬프터에도 표시 (PrompterListeningInfo 분리로 리렌더링 격리)

## ✅ 프롬프터 조작성 + 음악 재생 규칙 (2026-07-13)
- [x] 프롬프터 시작 버튼을 화면 한가운데 크게 (26pt 캡슐 + 안내 문구, regularMaterial 카드)
- [x] 소리 재생 중 오른쪽 아래 92pt 원형 "소리 멈춤" 버튼 (프롬프터), 세로 재생 바 정지 버튼 28→38pt
- [x] 음악(노래)도 10초 제한 — 8초에 페이드 시작해 10초 안에 종료 (효과음은 4.6초+0.4 페이드)
- [x] 모든 정지가 페이드아웃 — stop() 기본값이 음악이면 1.2초, 효과음이면 0.15초. 다음 효과음이 음악을 교체할 때도 1.2초 크로스페이드

## ✅ UX 전면 개편: "읽어 주면 효과음이 나오는 도구" (2026-07-13)
- [x] 탭 순서 교체 — 이야기가 첫 탭, 효과음 보드는 보조 탭
- [x] 홈: 정체성 헤더("소리 내어 읽어 주기만 하면...") + 3단계 사용법 카드(닫기 가능, @AppStorage) + 카드에 "약 n분 낭독·효과음 m개" 표시
- [x] 낭독 시작 전 마이크 동작 안내 문구
- [x] 오프닝 음악: 전 이야기 첫 문단 "자, 이제 「제목」 이야기를 시작할게요" — "시작" 말하면 once_upon_time(128초) 재생, 첫 효과음에서 자연 교체. 엔딩은 기존 happy_ending(82초) 유지
- [x] 완료된 큐 문단 비활성화(흐림·회색) 제거 — 완료 표시는 초록 체크 배지만
- [x] 노래 제외 모든 효과음 5초 제한 — AudioManager.scheduleEffectLimit, 0.4초 페이드아웃. 음악 예외: once_upon_time, happy_ending, ballroom_music, music_box, lullaby, flute_play, singing_voice, harp_strum, creepy_music

## ✅ 읽는 중 문단 강조 (2026-07-13)
- [x] `readingRange` 계산 — 마지막 발동 큐 다음 문단 ~ 다음 효과음 큐 문단
- [x] 읽는 중 구간은 본문 15% 확대 + semibold, 키워드는 heavy — 소리가 날 때마다 강조 블록이 다음 구간으로 이동 (0.3초 애니메이션)
- [x] 속삭임(whisper.mp3) 교체 — 기존 35.6초 → Mixkit "Male conspiracy voices whispers" 7.8초

## ✅ 버그 수정: 시작하자마자 첫 효과음 큐로 스크롤 튐 (2026-07-13)
- [x] 원인: 자동 스크롤이 currentCueIndex(낭독 문단을 건너뛰고 다음 효과음 큐로 미리 전진하는 매칭용 인덱스)에 걸려 있어, 첫 마디만 해도 화면이 첫 효과음 큐 문단("어느 해 겨울" 등)으로 이동
- [x] 수정: `lastCompletedCueIndex`(실제 발동된 큐) 추가 — 소리가 난 직후에만 다음 문단을 가운데로 스크롤, 시작/재시작 시엔 맨 위 문단 유지 (StoryModeManager + StoryModeView)

## ✅ 아이패드 우선 대응 (2026-07-13)
- [x] 프롬프터 모드 판정을 size class → 실제 창 비율(가로>세로, GeometryReader)로 변경 — 아이패드는 가로 회전해도 verticalSizeClass가 .regular라 기존 판정이 동작하지 않던 문제 수정. Split View에서도 창 모양 기준으로 동작
- [x] 프롬프터 모드에서 탭 바도 숨김 (아이패드는 탭 바가 상단에 있어 대본 공간 침범)
- [x] 넓은 화면 가독성: 큐시트 본문 폭 제한 (프롬프터 900pt / 세로 760pt, 가운데 정렬), 이야기 카드 목록 700pt 제한
- [x] 확인: TARGETED_DEVICE_FAMILY "1,2", 아이패드 4방향 회전 허용, 사운드 그리드 adaptive — 기존 설정 문제없음
- [ ] 실제 아이패드(또는 시뮬레이터)에서 가로 프롬프터·Split View 동작 확인

## ✅ 가로모드 = 전체 화면 프롬프터 (2026-07-13)
- [x] 가로모드에서 화면 전체가 큐시트 — 2단 분할 패널 제거, 내비게이션 바 숨김 (세로로 돌리면 복귀)
- [x] 상단 얇은 반투명 바 하나로 컨트롤 최소화: 시작/종료, 듣는 중+진행(n/m), 재생 중 효과음 칩(정지 포함), 글자 크기 A−/A+
- [x] 본문 글자 기본 22pt (18~34pt 조절, @AppStorage 저장) + 비례 줄간격, 좌우 여백 44pt
- [x] 수동 재생(38pt)·편집 버튼, 번호 배지, 효과음 태그 함께 확대 — 공연 중 오조작 방지
- [ ] 실기기 보면대 거리에서 가독성 확인 후 기본 크기 조정

## ✅ 버그 수정: 큐 연쇄 발동(휙휙 넘어감) (2026-07-13)
- [x] 원인: 큐 발동 시 인식 태스크를 취소해도 이미 전송 중이던 이전 세션 콜백이 뒤늦게 도착 → 이전 누적 인식 텍스트가 복원되며 다음 큐 키워드에 즉시 매칭 → 연쇄 발동
- [x] 수정: `recognitionGeneration` 세대 토큰 도입 — 세션마다 번호를 부여하고 현재 세대가 아닌 콜백(텍스트 갱신·재시작 요청)은 전부 무시 (StoryModeManager.swift)
- [x] 부가 수정: 50초 자동 재시작과 큐 발동 후 재시작이 겹쳐 인식 세션 2개가 동시에 돌던 문제 (`recognitionTask == nil` 가드), 마이크 탭이 다른 세션 request로 새는 문제 (세션 로컬 request 캡처)
- [ ] 실기기에서 낭독 리허설로 재발 여부 확인

## ✅ 이야기 10편으로 확장 (2026-07-13)
- [x] 신규 대본 7편 추가 (StoryScript.swift) — 아기 돼지 삼형제 🐷, 토끼와 거북이 🐢, 백설공주 🍎, 잭과 콩나무 🌱, 브레멘 음악대 🎺, 늑대와 일곱 마리 아기 염소 🐐, 미운 아기 오리 🦢 (총 10편, 모두 저작권 소멸 원작)
- [x] 신규 효과음 3개 다운로드 (Mixkit, 상업적 사용 가능·저작자표시 불필요) — goat_bleat(매애 아기 염소), hen_cluck(꼬꼬댁 암탉), axe_chop(쿵 도끼질)
- [x] SoundLibrary/SoundMood 등록 + download_sounds.py·download_images.py 목록 반영 (총 141개 음원)
- [x] 큐 키워드 조기 발동 검증 (직전 큐 이후 구간 내 키워드 유일성) + 빌드 검증 완료
- [ ] 신규 3개 음원의 버튼 배경 이미지 다운로드 (PIXABAY_API_KEY 필요 — 없어도 무드 색상으로 폴백됨)
- [ ] 신규 7편 리허설하며 delay 값 튜닝

## ✅ 공연 사용 스토리 + 가로모드 (2026-07-13)
- [x] `docs/performance-user-story.md` — 실제 공연 사용 시나리오 4개 (리허설/세팅/본편/돌발 상황) + 요구사항 체크리스트
- [x] StoryDetailView 가로모드 공연 레이아웃 — 왼쪽 컨트롤 패널(340pt: 시작/듣는중/재생 바/종료) + 오른쪽 큐 목록 2단 구성 (verticalSizeClass 분기)
- [x] 가로모드에서 큐 목록 하단 여백 축소 (플로팅 바가 목록을 가리지 않음)
- [x] 가로(공연) 프리뷰 추가, 시뮬레이터 빌드 검증 완료

## ✅ 앱 이름 변경 + 효과음 커스터마이징 + 재생 길이 규칙 (2026-09-04)

- [x] 앱 이름 "이야기 무드" → **옛날옛날에** (CFBundleDisplayName Debug/Release, HeaderView 타이틀·부제)
- [x] `SoundCustomizationStore` 추가 (StoryCustomizationStore.swift) — 효과음 버튼별 "다른 소리로 갈아끼우기"를 UserDefaults에 전역 저장
- [x] 효과음 보드 버튼 길게 누르기 → "효과음 바꾸기" 시트 (검색 + 미리 듣기 + 되돌리기), 교체된 버튼엔 배지 표시
- [x] 재생 길이 규칙 통일 — 효과음은 3초: 짧으면 3초까지 반복, 길면 3초에서 페이드아웃으로 끊음
- [x] 배경음악은 60초까지 반복 후 페이드아웃, 무드 BGM은 끌 때까지 계속 (기존 10초 제한 제거)
- [x] `BackgroundMusicSet` — 🎼 배경음악 카테고리 신설 (음악 9 + 앰비언스 21), 무드 칩 옆에 별도 칩으로 분리
- [x] 진행 바를 실제 흐른 시간 기준으로 계산 (루프 재생 중 되감김 표시 버그 방지), 시뮬레이터 빌드·실행 검증

## ⏳ 남은 작업 (선택사항)

- [ ] 라이선스 크레딧 페이지 추가 (CC-BY 음원 사용 시)
- [ ] 음원 품질 검수 및 볼륨 정규화
- [ ] MP3 → CAF 변환 (iOS 최적화)
  ```bash
  for f in StoryMood/Sounds/*.mp3; do
    afconvert "$f" "${f%.mp3}.caf" -d aac -f caff
  done
  ```
