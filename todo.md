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

## ⏳ 남은 작업 (선택사항)

- [ ] 라이선스 크레딧 페이지 추가 (CC-BY 음원 사용 시)
- [ ] 음원 품질 검수 및 볼륨 정규화
- [ ] MP3 → CAF 변환 (iOS 최적화)
  ```bash
  for f in StoryMood/Sounds/*.mp3; do
    afconvert "$f" "${f%.mp3}.caf" -d aac -f caff
  done
  ```
