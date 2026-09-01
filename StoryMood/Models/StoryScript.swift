import Foundation

// MARK: - StoryCue
//
// ⚠️ 대본 작성 규칙 — 효과음 큐 문단은 **키워드가 들어 있는 문장에서 끝나야 한다.**
//    키워드 뒤에 다른 문장이 남아 있으면, 소리가 나는 순간 화면이 다음 문단으로
//    넘어가면서 남은 문장을 읽지 못하고 건너뛰게 된다.
//    남는 문장은 반드시 뒤이은 낭독 문단(keyword 없는 StoryCue)으로 떼어 낼 것.

struct StoryCue: Identifiable {
    let id: String
    let text: String         // 낭독할 본문 문단
    let keyword: String?     // 이 단어를 말하면 소리 재생. nil이면 순수 낭독 문단
    let soundID: String?     // keyword 없으면 nil
    let delay: TimeInterval  // 키워드 인식 후 소리 재생까지 대기 시간(초)
                             // 예: "사냥꾼이 총을 탕 하고 쐈어요" → keyword "사냥꾼이", delay 1.0
                             //     → "사냥꾼이"를 인식하고 1초 뒤 총소리가 "탕" 타이밍에 맞음

    var isCompleted = false
    var hasCue: Bool { keyword != nil && soundID != nil }

    /// 순수 낭독 문단
    init(id: String, text: String) {
        self.id = id; self.text = text; self.keyword = nil; self.soundID = nil; self.delay = 0
    }

    /// 효과음 큐 문단
    init(id: String, text: String, keyword: String, soundID: String, delay: TimeInterval = 0) {
        self.id = id; self.text = text; self.keyword = keyword; self.soundID = soundID; self.delay = delay
    }
}

// MARK: - StoryScript

struct StoryScript: Identifiable {
    let id: String
    let titleKo: String
    let titleEn: String
    let emoji: String
    let synopsis: String
    let cues: [StoryCue]
}

// MARK: - Scripts

extension StoryScript {

    static let allScripts: [StoryScript] = [
        hanselAndGretel, littleRedRidingHood, cinderella,
        threeLittlePigs, tortoiseAndHare, snowWhite, jackAndBeanstalk,
        bremenMusicians, wolfAndSevenGoats, uglyDuckling,
    ]

    // =========================================================
    // MARK: 헨젤과 그레텔 — 그림 형제 (저작권 소멸)
    // =========================================================

    static let hanselAndGretel = StoryScript(
        id: "hansel_gretel",
        titleKo: "헨젤과 그레텔",
        titleEn: "Hansel and Gretel",
        emoji: "🍬",
        synopsis: "계모의 계략으로 숲에 버려진 남매가 과자 집 마녀를 물리치고 집으로 돌아오는 이야기",
        cues: [
            StoryCue(
                id: "hg_00",
                text: "자, 이제 「헨젤과 그레텔」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "hg_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "hg_01",
                text: "옛날 옛날, 커다란 숲 가장자리에 가난한 나무꾼이 살았어요.",
                keyword: "나무꾼이",
                soundID: "axe_chop",
                delay: 0.3
            ),
            StoryCue(
                id: "hg_01b",
                text: "그에게는 헨젤과 그레텔이라는 남매가 있었지요. 두 아이는 언제나 사이가 좋았고 서로를 아껴 주었어요."
            ),
            StoryCue(
                id: "hg_02",
                text: "그런데 나무꾼의 두 번째 아내, 즉 아이들의 계모는 아이들을 조금도 아끼지 않았어요. 계모는 날마다 아이들에게 일만 시켰고, 밥도 조금밖에 주지 않았답니다."
            ),
            StoryCue(
                id: "hg_03",
                text: "어느 해 겨울, 온 나라에 심한 흉년이 들었어요. 차가운 바람이 숲 사이를 파고들었고 밥상에 올릴 음식이 하나도 남지 않았답니다.",
                keyword: "바람이",
                soundID: "wind_blow",
                delay: 0.5
            ),
            StoryCue(
                id: "hg_04",
                text: "그날 밤, 계모가 남편에게 낮은 목소리로 속삭였어요.",
                keyword: "속삭였어요",
                soundID: "whisper"
            ),
            StoryCue(
                id: "hg_04b",
                text: "'이제 우리가 먹을 것도 없어요. 내일 아이들을 숲 깊은 곳에 두고 와요. 그래야 우리라도 살 수 있어요.' 나무꾼은 가슴이 아팠지만 결국 고개를 끄덕이고 말았지요."
            ),
            StoryCue(
                id: "hg_05",
                text: "그날 밤 잠을 이루지 못한 헨젤은 계모의 말을 모두 엿들었어요. '그레텔, 걱정 마. 내게 생각이 있어.' 헨젤은 달빛이 비치는 뒷마당으로 살금살금 나가 반짝이는 조약돌을 주머니 가득 주워 담았어요.",
                keyword: "조약돌",
                soundID: "leaves_rustle"
            ),
            StoryCue(
                id: "hg_06",
                text: "다음 날 아침 일찍, 계모는 두 아이에게 빵 한 조각씩 쥐여 주고 손을 잡아 끌었어요. 한참을 걸어 들어가자 나무들이 점점 빽빽해지더니 하늘조차 보이지 않을 만큼 어두워졌어요.",
                keyword: "나무들이",
                soundID: "forest_ambience",
                delay: 0.5
            ),
            StoryCue(
                id: "hg_07",
                text: "헨젤은 걸으면서 주머니 속 조약돌을 하나씩 길바닥에 살짝 떨어뜨렸어요. 뒤돌아보지 않아도 흰 조약돌이 길을 표시해 주고 있다는 걸 헨젤은 알고 있었지요."
            ),
            StoryCue(
                id: "hg_08",
                text: "계모는 한참을 걷다가 모닥불을 피워 두었어요. '여기서 기다려라, 곧 돌아올게.' 계모는 그렇게 말하고 홀연히 사라졌어요. 머리 위 나뭇가지에서 새들이 맑고 고운 소리로 노래했어요.",
                keyword: "새들이",
                soundID: "bird_singing",
                delay: 0.5
            ),
            StoryCue(
                id: "hg_08b",
                text: "아이들은 불가에 앉아 밤이 오기를 기다렸어요."
            ),
            StoryCue(
                id: "hg_09",
                text: "밤이 되자 둥근 달이 떠올랐어요. 달빛을 받아 조약돌들이 반짝반짝 빛났어요.",
                keyword: "반짝반짝",
                soundID: "magic_sparkle"
            ),
            StoryCue(
                id: "hg_09b",
                text: "남매는 그 빛을 따라 걷고 또 걸어, 새벽녘이 되어서야 집으로 돌아왔답니다. 아버지는 두 아이를 꼭 안아 주었어요."
            ),
            StoryCue(
                id: "hg_10",
                text: "하지만 계모는 포기하지 않았어요. 며칠 뒤 계모는 다시 아이들을 숲에 버리려 했어요. 이번에는 문을 단단히 잠가 두었기에 헨젤이 조약돌을 가져올 수 없었어요.",
                keyword: "단단히 잠가",
                soundID: "lock_unlock"
            ),
            StoryCue(
                id: "hg_10b",
                text: "헨젤은 대신 밥 한 조각을 주머니에 숨겼어요."
            ),
            StoryCue(
                id: "hg_11",
                text: "헨젤은 숲길을 걸으면서 빵 부스러기를 하나씩 떨어뜨렸지요. 하지만 숲속에 사는 배고픈 새들이 어느새 빵 부스러기를 깨끗이 먹어 버렸어요.",
                keyword: "배고픈 새들이",
                soundID: "bird_singing",
                delay: 0.3
            ),
            StoryCue(
                id: "hg_12",
                text: "길을 잃은 남매는 사흘 밤낮을 숲속에서 헤맸어요.",
                keyword: "길을 잃은",
                soundID: "wind_blow"
            ),
            StoryCue(
                id: "hg_12b",
                text: "배는 너무 고프고 다리는 아파서 쓰러질 것만 같았어요. 차가운 밤바람이 불어와 두 아이는 서로를 꼭 안았어요."
            ),
            StoryCue(
                id: "hg_13",
                text: "그때 하얀 비둘기 한 마리가 나타나 두 아이 앞에서 살살 날아갔어요.",
                keyword: "비둘기 한 마리",
                soundID: "fairy_wings",
                delay: 0.3
            ),
            StoryCue(
                id: "hg_13b",
                text: "헨젤과 그레텔은 비둘기를 따라 걸었어요. 그러자 달콤하고 향기로운 냄새가 솔솔 풍겨 왔어요."
            ),
            StoryCue(
                id: "hg_14",
                text: "나무 사이로 놀라운 것이 보였어요. 지붕은 케이크, 벽은 생강 과자, 창문은 투명한 설탕으로 만든 집이었어요. 과자로 만든 집이 나타났어요!",
                keyword: "과자로",
                soundID: "eating_crunching"
            ),
            StoryCue(
                id: "hg_14b",
                text: "두 아이는 반쯤 정신을 잃은 채 허겁지겁 과자 집을 뜯어 먹기 시작했어요."
            ),
            StoryCue(
                id: "hg_15",
                text: "그때 집 안에서 가느다란 목소리가 들렸어요. '똑똑, 누가 내 집을 먹고 있니?'",
                keyword: "똑똑",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "hg_15b",
                text: "문이 삐걱 열리더니 허리가 굽은 할머니가 얼굴을 내밀었어요.",
                keyword: "삐걱",
                soundID: "door_creak"
            ),
            StoryCue(
                id: "hg_16",
                text: "'이리 오렴, 어서. 맛있는 것을 실컷 먹여 줄게.' 할머니는 따뜻하게 웃으며 아이들을 집 안으로 안내했어요.",
                keyword: "집 안으로",
                soundID: "door_slam"
            ),
            StoryCue(
                id: "hg_16b",
                text: "사실 그 할머니는 아이들을 잡아먹는 끔찍한 마녀였답니다."
            ),
            StoryCue(
                id: "hg_17a",
                text: "다음 날 아침, 마녀는 헨젤을 붙잡아 철창 안에 가두었어요.",
                keyword: "철창 안에",
                soundID: "lock_unlock"
            ),
            StoryCue(
                id: "hg_17ab",
                text: "자물쇠가 철컥 잠겼어요. 헨젤은 철창 사이로 그레텔을 바라보며 '괜찮아'라고 속삭였지요."
            ),
            StoryCue(
                id: "hg_17",
                text: "마녀는 그레텔에게 날마다 헨젤을 살찌울 음식을 만들게 했지요. 마녀가 깔깔깔 웃었어요.",
                keyword: "마녀가",
                soundID: "witch_cackle",
                delay: 0.8
            ),
            StoryCue(
                id: "hg_17b",
                text: "'살이 올라야 맛있단 말이지!'"
            ),
            StoryCue(
                id: "hg_18",
                text: "영리한 헨젤은 마녀에게 손가락 대신 뼈다귀를 내밀었어요. 눈이 나쁜 마녀는 그걸 만지작거리며 고개를 갸우뚱했어요. '이상하다, 왜 이렇게 안 찌지?' 이렇게 몇 주가 흘렀어요."
            ),
            StoryCue(
                id: "hg_19",
                text: "마침내 마녀는 화가 났어요. '이제 그만! 오늘 잡아먹을 거야!' 마녀는 커다란 오븐에 불을 지폈어요. 오븐 안에서 불이 활활 타올랐어요.",
                keyword: "활활",
                soundID: "fire_crackle"
            ),
            StoryCue(
                id: "hg_20",
                text: "마녀는 그레텔을 오븐 쪽으로 밀었어요.",
                keyword: "오븐 쪽으로",
                soundID: "oven_door"
            ),
            StoryCue(
                id: "hg_20b",
                text: "'어서 안을 들여다봐. 온도가 맞는지 확인해.' 그레텔은 무서웠지만 침착하게 꾀를 냈어요. '할머니, 어떻게 들여다봐야 해요? 한번 보여 주세요.'"
            ),
            StoryCue(
                id: "hg_21",
                text: "마녀가 몸을 굽혀 오븐 안을 들여다보는 순간, 그레텔은 온 힘을 다해 마녀를 오븐 속으로 밀어 넣고 문을 쾅 닫았어요! 그레텔은 헨젤의 철창 문을 열어 주었고, 두 아이는 마녀의 보물 상자를 챙겨 뛰쳐나왔어요. 두 아이는 빠르게 도망쳤어요.",
                keyword: "도망쳤어요",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "hg_22",
                text: "숲을 빠져나오자 커다란 강이 앞을 막았어요. 다리가 없어서 어떻게 건널까 망설이고 있을 때, 하얀 오리 한 마리가 꽤꽤 울며 헤엄쳐 왔어요.",
                keyword: "오리 한 마리",
                soundID: "duck_quack"
            ),
            StoryCue(
                id: "hg_22b",
                text: "오리는 두 아이를 등에 태워 강 건너편까지 데려다 주었답니다.",
                keyword: "등에 태워",
                soundID: "water_splash",
                delay: 0.3
            ),
            StoryCue(
                id: "hg_23",
                text: "강을 건너자 눈에 익은 숲길이 나타났어요. 점점 나무가 드문드문해지더니 낯익은 집 굴뚝이 보였어요. 아버지가 문 앞에 서서 기다리고 있었어요."
            ),
            StoryCue(
                id: "hg_24",
                text: "아버지는 두 아이를 꼭 끌어안고 눈물을 흘렸어요. 계모는 이미 세상을 떠나고 없었어요. 마녀의 보물 덕분에 세 사람은 더 이상 굶지 않았고, 오래오래 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 빨간 모자 — 그림 형제 (저작권 소멸)
    // =========================================================

    static let littleRedRidingHood = StoryScript(
        id: "little_red_riding_hood",
        titleKo: "빨간 모자",
        titleEn: "Little Red Riding Hood",
        emoji: "🐺",
        synopsis: "할머니 댁에 심부름 가던 빨간 모자 소녀가 늑대를 만나는 이야기",
        cues: [
            StoryCue(
                id: "lrrh_00",
                text: "자, 이제 「빨간 모자」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "lrrh_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "lrrh_01",
                text: "옛날 옛날, 작은 마을 어귀에 누구에게나 사랑받는 귀여운 소녀가 살았어요. 소녀의 할머니는 손수 만들어 준 빨간 망토와 모자를 선물로 주었는데, 소녀는 어디를 가든 항상 그것을 쓰고 다녔어요."
            ),
            StoryCue(
                id: "lrrh_02",
                text: "그 때문에 마을 사람들은 모두 소녀를 '빨간 모자'라고 불렀답니다.",
                keyword: "마을 사람들은",
                soundID: "magic_chime"
            ),
            StoryCue(
                id: "lrrh_02b",
                text: "빨간 모자는 밝고 씩씩하고 마음씨도 고와서 마을에서 모르는 사람이 없었어요."
            ),
            StoryCue(
                id: "lrrh_03",
                text: "어느 날 엄마가 빨간 모자를 불렀어요. '할머니가 많이 편찮으시단다. 이 케이크와 포도주를 바구니에 담아 가져다 드리렴. 그리고 길에서 벗어나거나 낯선 사람과 이야기하면 안 된다, 알겠니?'"
            ),
            StoryCue(
                id: "lrrh_04",
                text: "빨간 모자는 바구니를 팔에 걸고 씩씩하게 길을 나섰어요. 할머니 댁은 숲을 가로질러야 닿을 수 있었어요. 빨간 모자는 콧노래를 흥얼거리며 숲속으로 들어갔어요.",
                keyword: "숲속으로",
                soundID: "forest_ambience"
            ),
            StoryCue(
                id: "lrrh_05",
                text: "숲속은 참 아름다웠어요. 키 큰 나무들 사이로 햇살이 내리쬐고, 새들이 맑은 소리로 노래했어요.",
                keyword: "새들이",
                soundID: "bird_singing",
                delay: 0.5
            ),
            StoryCue(
                id: "lrrh_05b",
                text: "길가에는 형형색색의 꽃들이 활짝 피어 있었답니다.",
                keyword: "형형색색의 꽃들이",
                soundID: "garden_peaceful",
                delay: 0.3
            ),
            StoryCue(
                id: "lrrh_06",
                text: "빨간 모자는 꽃을 꺾어 할머니께 드리고 싶었어요. '이 예쁜 꽃다발을 드리면 할머니가 기뻐하실 거야.' 빨간 모자는 길에서 살짝 벗어나 예쁜 꽃들을 하나씩 꺾기 시작했어요.",
                keyword: "꺾기 시작했어요",
                soundID: "leaves_rustle"
            ),
            StoryCue(
                id: "lrrh_07",
                text: "그때 수풀이 바스락거리더니 차가운 바람이 불어왔어요.",
                keyword: "바람이",
                soundID: "wind_blow",
                delay: 0.5
            ),
            StoryCue(
                id: "lrrh_07b",
                text: "나뭇잎이 흔들리며 커다란 회색 늑대 한 마리가 모습을 드러냈어요."
            ),
            StoryCue(
                id: "lrrh_08",
                text: "'안녕, 꼬마야. 어디 가는 거니?' 늑대가 달콤한 목소리로 물었어요. 빨간 모자는 늑대가 얼마나 무서운 동물인지 몰랐어요. '숲 건너편 할머니 댁에 가요. 할머니가 편찮으셔서요.'"
            ),
            StoryCue(
                id: "lrrh_09",
                text: "'할머니 댁이 어디에 있니?' 늑대가 물었어요. 빨간 모자는 순진하게 길을 알려 주었어요. 늑대는 속으로 못된 생각을 품으며 낮게 으르렁거렸어요.",
                keyword: "으르렁",
                soundID: "wolf_growl"
            ),
            StoryCue(
                id: "lrrh_09b",
                text: "'그렇구나, 먼저 가렴. 나도 곧 갈게.'"
            ),
            StoryCue(
                id: "lrrh_10",
                text: "늑대는 지름길로 달려가 할머니 댁에 먼저 도착했어요. 늑대가 문을 두드리자 할머니가 '누구냐?' 하고 물었어요.",
                keyword: "문을 두드리자",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "lrrh_10b",
                text: "'저예요, 빨간 모자요.' 늑대가 목소리를 꾸며 대답했어요."
            ),
            StoryCue(
                id: "lrrh_11",
                text: "할머니가 문을 열자 늑대는 단숨에 달려들어 할머니를 꿀꺽 삼켜 버렸어요.",
                keyword: "꿀꺽",
                soundID: "evil_laugh"
            ),
            StoryCue(
                id: "lrrh_11b",
                text: "그리고 할머니의 나이트가운을 입고 머리 수건을 쓴 뒤 침대에 누워 이불을 뒤집어썼어요."
            ),
            StoryCue(
                id: "lrrh_12",
                text: "빨간 모자가 꽃다발을 들고 할머니 댁에 도착했어요. '할머니, 저 왔어요!' 빨간 모자는 똑똑, 문을 두드렸어요.",
                keyword: "똑똑",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "lrrh_13",
                text: "'들어오너라.' 이상하게도 할머니 목소리가 쉬어 있었어요. 빨간 모자가 문을 밀었어요. 삐걱, 문이 열리면서 침침한 방 안이 모습을 드러냈어요.",
                keyword: "삐걱",
                soundID: "door_creak"
            ),
            StoryCue(
                id: "lrrh_14",
                text: "빨간 모자는 침대로 다가갔어요. 이상한 점이 한두 가지가 아니었어요. '할머니, 귀가 왜 그렇게 커요?' '너를 잘 듣기 위해서란다.' '할머니, 눈이 왜 그렇게 커요?' '너를 잘 보기 위해서지.' '할머니, 코가 왜 그렇게 커요?' '너의 냄새를 잘 맡기 위해서야.'"
            ),
            StoryCue(
                id: "lrrh_15",
                text: "'할머니, 입이 왜 그렇게 커요?' '너를 잡아먹기 위해서야!' 늑대가 이불을 걷어 내며 벌떡 일어나 크게 울부짖었어요.",
                keyword: "울부짖었어요",
                soundID: "wolf_howl"
            ),
            StoryCue(
                id: "lrrh_15b",
                text: "빨간 모자는 비명을 지르며 뒤로 물러섰어요.",
                keyword: "비명을",
                soundID: "scream"
            ),
            StoryCue(
                id: "lrrh_16",
                text: "마침 근처 숲에서 사냥을 나온 사냥꾼이 그 비명 소리를 들었어요.",
                keyword: "사냥꾼이",
                soundID: "footstep_run",
                delay: 1.0
            ),
            StoryCue(
                id: "lrrh_16b",
                text: "'저 집에서 이상한 소리가 나는군!' 사냥꾼이 총을 들고 달려왔어요."
            ),
            StoryCue(
                id: "lrrh_17",
                text: "사냥꾼이 문을 박차고 들어왔어요.",
                keyword: "문을 박차고",
                soundID: "door_slam"
            ),
            StoryCue(
                id: "lrrh_17b",
                text: "사냥꾼은 늑대의 배를 가르자 할머니가 무사히 나왔어요.",
                keyword: "배를 가르자",
                soundID: "scissors_cut",
                delay: 0.3
            ),
            StoryCue(
                id: "lrrh_17bb",
                text: "배를 가른 자리에 돌을 넣고 꿰매자 늑대는 달아나다 그 무게에 쓰러지고 말았어요."
            ),
            StoryCue(
                id: "lrrh_18",
                text: "할머니는 빨간 모자가 가져온 케이크와 포도주를 드시고 금세 기운을 차리셨어요. 사냥꾼은 늑대 가죽을 챙겨 돌아갔어요. 빨간 모자는 할머니 품에 꼭 안겨 한참을 울었어요.",
                keyword: "한참을 울었어요",
                soundID: "crying"
            ),
            StoryCue(
                id: "lrrh_19",
                text: "그날 이후로 빨간 모자는 낯선 이와 함부로 이야기하지 않기로 다짐했어요. 엄마의 당부를 늘 가슴속에 새겼지요. 빨간 모자와 할머니는 오래도록 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 신데렐라 — 샤를 페로 (저작권 소멸)
    // =========================================================

    static let cinderella = StoryScript(
        id: "cinderella",
        titleKo: "신데렐라",
        titleEn: "Cinderella",
        emoji: "👠",
        synopsis: "요정 할머니의 마법으로 무도회에 간 신데렐라가 왕자와 만나 행복해지는 이야기",
        cues: [
            StoryCue(
                id: "cin_00",
                text: "자, 이제 「신데렐라」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "cin_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "cin_01",
                text: "옛날 옛날, 부유한 상인에게 마음씨 고운 딸이 하나 있었어요. 소녀의 어머니는 소녀가 어릴 때 세상을 떠났어요. 아버지는 딸이 외로울까 봐 다시 결혼했지만, 새엄마는 소녀를 전혀 아끼지 않았답니다."
            ),
            StoryCue(
                id: "cin_02p",
                text: "새엄마에게는 딸이 둘 있었어요. 두 언니는 새엄마를 닮아 심술궂었어요. 그들은 소녀에게 온갖 집안일을 시키며 구박했어요. 소녀는 부뚜막 가에서 일하다 재투성이가 되기 일쑤였어요.",
                keyword: "부뚜막 가에서",
                soundID: "broom_sweep",
                delay: 0.3
            ),
            StoryCue(
                id: "cin_02",
                text: "그래서 사람들은 소녀를 신데렐라라고 불렀어요.",
                keyword: "그래서 사람들은",
                soundID: "wind_blow"
            ),
            StoryCue(
                id: "cin_03",
                text: "신데렐라는 힘든 하루하루도 불평 없이 보냈어요. 마당의 비둘기들과 이야기를 나누며 마음을 달랬고, 돌아가신 어머니를 생각하며 힘을 냈어요.",
                keyword: "비둘기들과",
                soundID: "bird_singing",
                delay: 0.3
            ),
            StoryCue(
                id: "cin_04",
                text: "그러던 어느 날, 왕궁으로부터 화려한 무도회 초대장이 날아왔어요.",
                keyword: "초대장이",
                soundID: "trumpet_fanfare"
            ),
            StoryCue(
                id: "cin_04b",
                text: "나라 안의 모든 아가씨를 초대하여 왕자님이 직접 만나고 싶다는 내용이었지요."
            ),
            StoryCue(
                id: "cin_05",
                text: "새엄마와 두 언니는 신이 났어요. 며칠 동안 예쁜 드레스와 보석을 고르느라 정신이 없었어요. 신데렐라도 함께 가고 싶다고 했지만 새엄마는 콧방귀를 뀌었어요. '너 같은 재투성이가 무도회에? 어림도 없지!'",
                keyword: "어림도 없지",
                soundID: "evil_laugh"
            ),
            StoryCue(
                id: "cin_06",
                text: "무도회 날이 되었어요. 언니들은 화사하게 치장하고 마차에 올라탔어요. 신데렐라는 현관 앞에서 마차가 멀어지는 것을 물끄러미 바라보다가 부엌으로 돌아와 엉엉 울었어요.",
                keyword: "울었어요",
                soundID: "crying"
            ),
            StoryCue(
                id: "cin_07",
                text: "그때 부엌이 갑자기 환하게 빛나더니 작고 반짝이는 빛이 나타났어요. 빛이 점점 커지면서 은빛 머리카락을 가진 요정이 나타났어요.",
                keyword: "요정이",
                soundID: "magic_sparkle"
            ),
            StoryCue(
                id: "cin_07b",
                text: "'울지 마렴, 신데렐라. 내가 도와줄게.'"
            ),
            StoryCue(
                id: "cin_08",
                text: "요정 할머니는 지팡이를 꺼내 들었어요. '먼저 텃밭에서 가장 큰 호박을 가져오렴.' 신데렐라가 호박을 가져오자 요정 할머니가 지팡이를 휘두르며 마법을 부렸어요.",
                keyword: "마법을",
                soundID: "magic_wand"
            ),
            StoryCue(
                id: "cin_09",
                text: "펑! 커다란 호박이 눈부신 빛을 내더니 황금빛 마차로 변했어요!",
                keyword: "호박이",
                soundID: "magic_transform"
            ),
            StoryCue(
                id: "cin_09b",
                text: "신데렐라의 낡은 치마는 은빛 드레스가 되었고, 발에는 유리로 만든 아름다운 구두가 신겨졌어요.",
                keyword: "유리로 만든",
                soundID: "glass_slipper",
                delay: 0.5
            ),
            StoryCue(
                id: "cin_10",
                text: "'하지만 자정, 열두 시가 되면 모든 마법이 풀린다는 걸 잊지 마렴.' 요정 할머니가 당부했어요. 여섯 마리의 하얀 말이 콧김을 내뿜으며 힘차게 달리기 시작했어요.",
                keyword: "말이",
                soundID: "horse_gallop",
                delay: 0.8
            ),
            StoryCue(
                id: "cin_10b",
                text: "마차는 왕궁을 향해 달렸어요.",
                keyword: "마차는 왕궁을",
                soundID: "carriage_ride",
                delay: 0.3
            ),
            StoryCue(
                id: "cin_11",
                text: "왕궁에 도착하자 눈부신 빛과 화려한 장식이 신데렐라를 맞이했어요. 무도회에서 아름다운 음악이 흘렀어요.",
                keyword: "무도회에서",
                soundID: "harp_strum"
            ),
            StoryCue(
                id: "cin_11b",
                text: "수백 개의 촛불이 홀을 환하게 밝히고 있었어요."
            ),
            StoryCue(
                id: "cin_12",
                text: "신데렐라가 계단을 내려서자 홀 안이 조용해졌어요. 모든 사람들이 숨을 죽이고 바라보았어요.",
                keyword: "숨을 죽이고",
                soundID: "gasp_surprise"
            ),
            StoryCue(
                id: "cin_12b",
                text: "두 언니도 신데렐라인 줄 전혀 알아보지 못했지요."
            ),
            StoryCue(
                id: "cin_13",
                text: "왕자님이 신데렐라를 보고 황홀한 표정으로 다가왔어요.",
                keyword: "왕자님이",
                soundID: "royal_fanfare",
                delay: 0.8
            ),
            StoryCue(
                id: "cin_13b",
                text: "'이렇게 아름다운 분은 처음 뵙습니다. 저와 함께 춤을 추어 주시겠어요?' 왕자님이 손을 내밀었어요."
            ),
            StoryCue(
                id: "cin_14",
                text: "두 사람은 하룻밤 내내 함께 춤을 추었어요.",
                keyword: "춤을 추었어요",
                soundID: "ballroom_music"
            ),
            StoryCue(
                id: "cin_14b",
                text: "왕자님은 신데렐라에게서 눈을 뗄 수가 없었어요. 신데렐라도 꿈속에 있는 것처럼 행복했지요. 시간이 얼마나 흘렀는지 깨닫지 못했어요."
            ),
            StoryCue(
                id: "cin_15",
                text: "그때 멀리서 시계 소리가 울려 퍼지기 시작했어요. 하나, 둘, 셋... 궁전 시계탑의 종이 쉬지 않고 울렸어요. 열두 시가 되었어요!",
                keyword: "열두 시",
                soundID: "clock_chime_12"
            ),
            StoryCue(
                id: "cin_16",
                text: "신데렐라는 '안 돼!'를 외치며 왕자님의 손을 뿌리치고 계단을 뛰어 내려갔어요.",
                keyword: "뛰어 내려갔어요",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "cin_16b",
                text: "마지막 계단에서 그만 유리 구두 한 짝이 벗겨지고 말았지만, 돌아볼 여유가 없었어요."
            ),
            StoryCue(
                id: "cin_17",
                text: "왕궁 밖으로 나서는 순간 마법이 풀려 마차는 다시 호박이 되었고, 드레스는 낡은 옷으로 돌아왔어요.",
                keyword: "마법이 풀려",
                soundID: "magic_poof"
            ),
            StoryCue(
                id: "cin_17b",
                text: "신데렐라는 헐레벌떡 집으로 달려가 부엌 아궁이 옆에 앉았어요."
            ),
            StoryCue(
                id: "cin_18",
                text: "왕자님은 계단에 떨어진 유리 구두를 소중히 들고 선포했어요.",
                keyword: "소중히 들고",
                soundID: "glass_slipper"
            ),
            StoryCue(
                id: "cin_18b",
                text: "'이 구두의 주인을 찾겠노라. 그 분이 나의 신부가 될 것이다.' 신하들은 유리 구두를 들고 온 나라를 돌아다니며 아가씨들에게 신겨 보았어요."
            ),
            StoryCue(
                id: "cin_19",
                text: "드디어 신데렐라의 집에도 왕자님 일행이 찾아왔어요. 두 언니는 앞다투어 구두를 신어 보았지만 발이 너무 커서 전혀 들어가지 않았어요. '혹시 다른 아가씨는 없나요?'"
            ),
            StoryCue(
                id: "cin_20",
                text: "신데렐라가 조심스럽게 나와 구두를 발에 대어 보았어요. 딱 맞았어요!",
                keyword: "딱 맞았어요",
                soundID: "magic_chime"
            ),
            StoryCue(
                id: "cin_20b",
                text: "그 순간 요정 할머니의 마법이 다시 펼쳐지며 신데렐라는 다시 아름다운 드레스를 입었어요.",
                keyword: "마법이 다시",
                soundID: "magic_transform",
                delay: 0.3
            ),
            StoryCue(
                id: "cin_21p",
                text: "왕자님과 신데렐라는 성대한 결혼식을 올렸어요.",
                keyword: "결혼식을",
                soundID: "bell_ring"
            ),
            StoryCue(
                id: "cin_21",
                text: "신데렐라는 넓은 마음으로 두 언니와 새엄마까지 용서했어요. 모두가 함께 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 아기 돼지 삼형제 — 영국 전래동화 (저작권 소멸)
    // =========================================================

    static let threeLittlePigs = StoryScript(
        id: "three_little_pigs",
        titleKo: "아기 돼지 삼형제",
        titleEn: "The Three Little Pigs",
        emoji: "🐷",
        synopsis: "각자 집을 지은 아기 돼지 삼형제가 배고픈 늑대를 지혜롭게 물리치는 이야기",
        cues: [
            StoryCue(
                id: "tlp_00",
                text: "자, 이제 「아기 돼지 삼형제」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "tlp_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "tlp_01",
                text: "옛날 옛날, 엄마 돼지와 아기 돼지 삼형제가 살았어요. 아기 돼지들이 무럭무럭 자라자 엄마 돼지가 말했어요. '이제 너희도 다 컸으니 각자 집을 짓고 살아 보렴.' 삼형제는 씩씩하게 길을 나섰답니다.",
                keyword: "길을 나섰답니다",
                soundID: "footstep_walk"
            ),
            StoryCue(
                id: "tlp_02",
                text: "게으른 첫째 돼지는 들판에서 지푸라기를 발견했어요.",
                keyword: "지푸라기를",
                soundID: "leaves_rustle"
            ),
            StoryCue(
                id: "tlp_02b",
                text: "'이걸로 집을 지으면 금방 끝나겠는걸?' 첫째는 지푸라기를 대충 쌓아 반나절 만에 집을 완성하고 낮잠을 자러 갔어요.",
                keyword: "낮잠을 자러",
                soundID: "snoring",
                delay: 0.3
            ),
            StoryCue(
                id: "tlp_03",
                text: "둘째 돼지는 숲에서 나뭇가지를 주워 왔어요. 뚝딱뚝딱, 나무를 얼기설기 엮어 집을 지었지요.",
                keyword: "뚝딱뚝딱",
                soundID: "axe_chop"
            ),
            StoryCue(
                id: "tlp_03b",
                text: "'이 정도면 튼튼하지!' 둘째도 하루 만에 집을 다 짓고 놀러 나갔어요."
            ),
            StoryCue(
                id: "tlp_04",
                text: "부지런한 셋째 돼지는 벽돌을 한 장 한 장 정성껏 쌓았어요.",
                keyword: "벽돌을 한 장",
                soundID: "hammer_wood",
                delay: 0.3
            ),
            StoryCue(
                id: "tlp_04b",
                text: "형들이 '뭘 그렇게 힘들게 지어?' 하고 놀렸지만, 셋째는 몇 날 며칠 땀을 흘리며 튼튼한 벽돌집을 완성했답니다."
            ),
            StoryCue(
                id: "tlp_05",
                text: "그러던 어느 날, 산 너머에서 배고픈 늑대가 어슬렁어슬렁 내려왔어요.",
                keyword: "늑대가",
                soundID: "wolf_growl",
                delay: 0.5
            ),
            StoryCue(
                id: "tlp_05b",
                text: "늑대는 아기 돼지 냄새를 맡고 침을 꿀꺽 삼키며 낮게 으르렁거렸지요."
            ),
            StoryCue(
                id: "tlp_06",
                text: "늑대는 먼저 첫째 돼지의 지푸라기 집으로 가서 쿵쿵 문을 두드렸어요.",
                keyword: "문을 두드렸어요",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "tlp_06b",
                text: "'아기 돼지야, 문 열어라!' '싫어요, 절대 안 열어 줄 거예요!'"
            ),
            StoryCue(
                id: "tlp_07",
                text: "'그렇다면 이 집을 날려 버리겠다!' 늑대는 숨을 크게 들이마시고 후우 하고 입김을 불었어요.",
                keyword: "입김을",
                soundID: "wind_blow",
                delay: 0.5
            ),
            StoryCue(
                id: "tlp_08",
                text: "그러자 지푸라기 집이 힘없이 무너져 버렸어요!",
                keyword: "무너져",
                soundID: "house_collapse"
            ),
            StoryCue(
                id: "tlp_08b",
                text: "첫째 돼지는 깜짝 놀라 꿀꿀 소리를 지르며 뛰쳐나왔어요.",
                keyword: "꿀꿀 소리를",
                soundID: "pig_oink"
            ),
            StoryCue(
                id: "tlp_09",
                text: "첫째 돼지는 걸음아 나 살려라 하고 둘째 형의 나무 집으로 달려갔어요.",
                keyword: "달려갔어요",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "tlp_09b",
                text: "늑대도 혀를 날름거리며 그 뒤를 쫓아왔지요."
            ),
            StoryCue(
                id: "tlp_10",
                text: "늑대는 나무 집 앞에서 다시 숨을 크게 들이마셨어요. 그리고 아까보다 훨씬 더 세게 불었어요!",
                keyword: "더 세게",
                soundID: "wind_howl",
                delay: 0.3
            ),
            StoryCue(
                id: "tlp_11",
                text: "나무 집이 와르르 무너지고 말았어요!",
                keyword: "와르르",
                soundID: "house_collapse"
            ),
            StoryCue(
                id: "tlp_11b",
                text: "첫째와 둘째 돼지는 서로 부둥켜안고 벌벌 떨다가 막내의 벽돌집으로 죽을힘을 다해 도망쳤답니다."
            ),
            StoryCue(
                id: "tlp_12",
                text: "늑대는 벽돌집 앞에서도 있는 힘껏 입김을 불었어요. 하지만 벽돌집은 꿈쩍도 하지 않았어요. 몇 번을 불어도 벽돌 하나 흔들리지 않았지요. 늑대는 약이 바짝 올랐어요.",
                keyword: "약이 바짝",
                soundID: "wolf_growl",
                delay: 0.3
            ),
            StoryCue(
                id: "tlp_13",
                text: "'좋아, 그럼 굴뚝으로 들어가 주지!'",
                keyword: "굴뚝으로",
                soundID: "climbing",
                delay: 0.5
            ),
            StoryCue(
                id: "tlp_13b",
                text: "늑대는 지붕 위로 영차영차 기어올라 굴뚝을 타고 내려가기 시작했어요."
            ),
            StoryCue(
                id: "tlp_14",
                text: "하지만 영리한 셋째 돼지는 이미 알고 있었어요. 굴뚝 아래 커다란 솥에는 물이 펄펄 끓고 있었답니다.",
                keyword: "펄펄",
                soundID: "pot_boiling"
            ),
            StoryCue(
                id: "tlp_15",
                text: "굴뚝을 타고 내려온 늑대는 그대로 끓는 솥에 풍덩 빠지고 말았어요!",
                keyword: "풍덩",
                soundID: "water_splash"
            ),
            StoryCue(
                id: "tlp_15b",
                text: "'으악, 뜨거워!'",
                keyword: "으악",
                soundID: "scream"
            ),
            StoryCue(
                id: "tlp_16",
                text: "늑대는 꽁지가 빠지게 산 너머로 도망쳤고, 다시는 돌아오지 않았어요.",
                keyword: "도망쳤고",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "tlp_17",
                text: "첫째와 둘째 돼지도 막내처럼 튼튼한 벽돌집을 지었어요. 삼형제는 서로 도우며 오래오래 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 토끼와 거북이 — 이솝 우화 (저작권 소멸)
    // =========================================================

    static let tortoiseAndHare = StoryScript(
        id: "tortoise_and_hare",
        titleKo: "토끼와 거북이",
        titleEn: "The Tortoise and the Hare",
        emoji: "🐢",
        synopsis: "빠른 토끼와 느린 거북이의 달리기 경주 — 꾸준함이 이기는 이야기",
        cues: [
            StoryCue(
                id: "th_00",
                text: "자, 이제 「토끼와 거북이」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "th_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "th_01",
                text: "옛날 어느 숲속 마을에 발 빠른 토끼가 살았어요. 토끼는 자기가 숲에서 가장 빠르다며 언제나 잘난 척을 했지요."
            ),
            StoryCue(
                id: "th_02",
                text: "'나를 봐! 폴짝폴짝 한 번 뛰면 벌써 저 언덕이라고!'",
                keyword: "폴짝폴짝",
                soundID: "jumping"
            ),
            StoryCue(
                id: "th_02b",
                text: "토끼는 느릿느릿 걸어가는 거북이를 보고 킥킥 웃으며 놀렸어요. '거북아, 너는 세상에서 제일 느림보야!'"
            ),
            StoryCue(
                id: "th_03",
                text: "거북이는 화를 내는 대신 조용히 말했어요. '토끼야, 그럼 나와 달리기 경주를 해 볼래? 저 산꼭대기 큰 나무까지 말이야.' 토끼는 배꼽을 잡고 웃었어요.",
                keyword: "배꼽을 잡고",
                soundID: "laughing",
                delay: 0.3
            ),
            StoryCue(
                id: "th_03b",
                text: "'좋아! 내가 이기는 건 뻔하지만!'"
            ),
            StoryCue(
                id: "th_04p",
                text: "경주 날이 되자 숲속 동물들이 모두 모였어요.",
                keyword: "모두 모였어요",
                soundID: "village_ambience"
            ),
            StoryCue(
                id: "th_04",
                text: "부엉이 심판이 높이 나팔을 불어 경주의 시작을 알렸어요!",
                keyword: "나팔을",
                soundID: "trumpet_fanfare",
                delay: 0.5
            ),
            StoryCue(
                id: "th_05",
                text: "토끼는 쌩하고 바람처럼 달려 나갔어요.",
                keyword: "쌩하고",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "th_05b",
                text: "눈 깜짝할 사이에 거북이는 까마득히 뒤처지고 말았지요."
            ),
            StoryCue(
                id: "th_06",
                text: "한참을 달리던 토끼는 뒤를 돌아보았어요. 거북이는 보이지도 않았어요. 마침 길가 나무 위에서 새들이 즐겁게 지저귀고 있었지요.",
                keyword: "새들이",
                soundID: "bird_singing",
                delay: 0.5
            ),
            StoryCue(
                id: "th_07",
                text: "'거북이가 여기까지 오려면 한참 멀었네. 시원한 그늘에서 낮잠이나 자 볼까?'",
                keyword: "낮잠이나",
                soundID: "snoring",
                delay: 1.0
            ),
            StoryCue(
                id: "th_07b",
                text: "토끼는 나무 그늘에 벌러덩 누워 쿨쿨 잠이 들었어요."
            ),
            StoryCue(
                id: "th_08",
                text: "그동안 거북이는 쉬지 않고 뚜벅뚜벅 걸었어요.",
                keyword: "뚜벅뚜벅",
                soundID: "footstep_walk"
            ),
            StoryCue(
                id: "th_08b",
                text: "힘들어도 멈추지 않았고, 땀이 흘러도 포기하지 않았어요."
            ),
            StoryCue(
                id: "th_09",
                text: "거북이는 잠든 토끼 옆을 조용히 지나갔어요.",
                keyword: "조용히 지나갔어요",
                soundID: "footstep_tiptoe"
            ),
            StoryCue(
                id: "th_09b",
                text: "그리고 한 걸음 한 걸음, 산꼭대기를 향해 계속 올라갔답니다."
            ),
            StoryCue(
                id: "th_10",
                text: "얼마나 지났을까, 토끼가 눈을 번쩍 떴어요.",
                keyword: "번쩍",
                soundID: "gasp_surprise"
            ),
            StoryCue(
                id: "th_10b",
                text: "'아차, 내가 너무 오래 잤나?' 저 멀리 산꼭대기를 올려다본 토끼는 소스라치게 놀랐어요. 거북이가 결승선 바로 앞에 있는 게 아니겠어요!"
            ),
            StoryCue(
                id: "th_11",
                text: "토끼는 온 힘을 다해 달리고 또 달렸어요.",
                keyword: "온 힘을",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "th_11b",
                text: "하지만 이미 늦고 말았지요."
            ),
            StoryCue(
                id: "th_12",
                text: "거북이가 먼저 결승선을 통과했어요!",
                keyword: "결승선을",
                soundID: "cheer_crowd",
                delay: 0.3
            ),
            StoryCue(
                id: "th_12b",
                text: "숲속 동물들이 모두 뛰어나와 환호하며 박수를 쳤답니다.",
                keyword: "박수를 쳤답니다",
                soundID: "applause"
            ),
            StoryCue(
                id: "th_12bb",
                text: "'거북이 만세! 거북이가 이겼다!'"
            ),
            StoryCue(
                id: "th_13",
                text: "토끼는 얼굴이 빨개져서 거북이에게 사과했어요. '내가 잘난 척해서 미안해. 넌 정말 대단해!' 그날부터 토끼와 거북이는 둘도 없는 친구가 되어 행복하게 지냈답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 백설공주 — 그림 형제 (저작권 소멸)
    // =========================================================

    static let snowWhite = StoryScript(
        id: "snow_white",
        titleKo: "백설공주",
        titleEn: "Snow White",
        emoji: "🍎",
        synopsis: "마법 거울과 독사과, 일곱 난쟁이와 함께하는 백설공주 이야기",
        cues: [
            StoryCue(
                id: "sw_00",
                text: "자, 이제 「백설공주」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "sw_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "sw_01",
                text: "옛날 어느 왕국에 눈처럼 하얀 피부와 흑단처럼 까만 머리카락을 가진 공주가 태어났어요.",
                keyword: "공주가 태어났어요",
                soundID: "baby_giggle"
            ),
            StoryCue(
                id: "sw_01b",
                text: "사람들은 공주를 백설공주라고 불렀지요. 하지만 왕비가 세상을 떠나고, 왕은 새 왕비를 맞이했답니다."
            ),
            StoryCue(
                id: "sw_02",
                text: "새 왕비에게는 신기한 마법 거울이 있었어요. 왕비는 날마다 물었지요. '거울아, 거울아, 이 세상에서 누가 제일 아름답니?'",
                keyword: "거울아",
                soundID: "mirror_magic"
            ),
            StoryCue(
                id: "sw_02b",
                text: "그러면 거울은 언제나 '왕비님이 제일 아름답습니다'라고 대답했어요."
            ),
            StoryCue(
                id: "sw_03",
                text: "그런데 어느 날, 거울이 다른 대답을 했어요. '이제는 백설공주님이 제일 아름답습니다.' 왕비는 질투로 얼굴이 새파랗게 변했어요. 그리고 사냥꾼을 불러 무서운 명령을 내렸지요.",
                keyword: "무서운 명령을",
                soundID: "creepy_music"
            ),
            StoryCue(
                id: "sw_04",
                text: "사냥꾼은 백설공주를 데리고 깊은 숲속으로 들어갔어요.",
                keyword: "숲속으로",
                soundID: "forest_ambience"
            ),
            StoryCue(
                id: "sw_04b",
                text: "하지만 착한 사냥꾼은 차마 공주를 해칠 수 없었어요. '공주님, 어서 멀리 도망가세요. 그리고 절대 성으로 돌아오시면 안 됩니다.'"
            ),
            StoryCue(
                id: "sw_05",
                text: "백설공주는 가시덤불을 헤치며 숲속 깊은 곳으로 정신없이 달아났어요.",
                keyword: "달아났어요",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "sw_05b",
                text: "해가 질 무렵, 공주는 작고 아담한 오두막 한 채를 발견했답니다."
            ),
            StoryCue(
                id: "sw_06",
                text: "공주가 문을 살며시 열자 삐걱 소리와 함께 아기자기한 방이 나타났어요.",
                keyword: "살며시",
                soundID: "door_creak"
            ),
            StoryCue(
                id: "sw_06b",
                text: "작은 식탁에는 접시 일곱 개, 벽 쪽에는 작은 침대가 일곱 개 놓여 있었지요. 지친 공주는 침대에 누워 곤히 잠들었어요.",
                keyword: "곤히 잠들었어요",
                soundID: "lullaby"
            ),
            StoryCue(
                id: "sw_07",
                text: "밤이 되자 오두막의 주인인 일곱 난쟁이들이 즐겁게 노래를 부르며 돌아왔어요.",
                keyword: "노래를",
                soundID: "singing_voice",
                delay: 0.3
            ),
            StoryCue(
                id: "sw_07b",
                text: "광산에서 보석을 캐고 오는 길이었지요."
            ),
            StoryCue(
                id: "sw_08",
                text: "난쟁이들은 잠든 공주를 발견하고 깜짝 놀랐어요. 공주의 사연을 들은 난쟁이들은 입을 모아 말했어요. '우리와 함께 살아요. 우리가 지켜 줄게요!' 백설공주는 난쟁이들과 행복한 나날을 보냈답니다.",
                keyword: "행복한 나날을",
                soundID: "music_box"
            ),
            StoryCue(
                id: "sw_09",
                text: "한편 성에서 왕비가 다시 거울에게 물었어요. '거울아, 거울아, 이 세상에서 누가 제일 아름답니?'",
                keyword: "거울아",
                soundID: "mirror_magic"
            ),
            StoryCue(
                id: "sw_09b",
                text: "'일곱 난쟁이와 사는 백설공주님이 제일 아름답습니다.' 왕비는 공주가 살아 있다는 것을 알고 부들부들 떨었어요."
            ),
            StoryCue(
                id: "sw_10",
                text: "왕비는 독을 바른 새빨간 사과를 만들었어요. 그리고 마법을 부려 꼬부랑 할멈으로 변신했지요.",
                keyword: "할멈으로",
                soundID: "witch_cackle",
                delay: 0.5
            ),
            StoryCue(
                id: "sw_10b",
                text: "왕비는 소름 끼치는 웃음을 흘리며 숲으로 향했어요."
            ),
            StoryCue(
                id: "sw_11",
                text: "'새콤달콤한 사과 사려! 예쁜 아가씨, 이 사과 하나 맛보구려.' 백설공주는 잠시 망설였지만, 사과가 어찌나 먹음직스러운지 그만 손을 내밀고 말았어요."
            ),
            StoryCue(
                id: "sw_12",
                text: "백설공주가 사과를 한 입 베어 문 순간이었어요!",
                keyword: "한 입",
                soundID: "eating_crunching"
            ),
            StoryCue(
                id: "sw_13",
                text: "공주는 그 자리에 힘없이 쓰러지고 말았어요.",
                keyword: "쓰러지고",
                soundID: "falling"
            ),
            StoryCue(
                id: "sw_13b",
                text: "할멈은 낄낄 웃으며 사라졌지요.",
                keyword: "낄낄 웃으며",
                soundID: "evil_laugh"
            ),
            StoryCue(
                id: "sw_14",
                text: "돌아온 난쟁이들은 쓰러진 공주를 보고 슬피 울었어요.",
                keyword: "슬피",
                soundID: "crying"
            ),
            StoryCue(
                id: "sw_14b",
                text: "난쟁이들은 공주를 유리관에 눕히고 밤낮으로 곁을 지켰답니다."
            ),
            StoryCue(
                id: "sw_15",
                text: "그러던 어느 날, 이웃 나라 왕자님이 하얀 말을 타고 숲을 지나가다 유리관 속 공주를 보았어요.",
                keyword: "말을 타고",
                soundID: "horse_gallop",
                delay: 0.5
            ),
            StoryCue(
                id: "sw_15b",
                text: "왕자는 공주의 아름다움에 마음을 빼앗기고 말았지요."
            ),
            StoryCue(
                id: "sw_16p",
                text: "왕자가 공주에게 다가가 입을 맞추자, 목에 걸려 있던 독사과 조각이 툭 빠져나왔어요.",
                keyword: "입을 맞추자",
                soundID: "kiss",
                delay: 0.3
            ),
            StoryCue(
                id: "sw_16",
                text: "그 순간 백설공주가 천천히 눈을 떴어요!",
                keyword: "눈을 떴어요",
                soundID: "magic_chime"
            ),
            StoryCue(
                id: "sw_17p",
                text: "백설공주와 왕자님은 성대한 결혼식을 올렸어요.",
                keyword: "결혼식을",
                soundID: "bell_ring"
            ),
            StoryCue(
                id: "sw_17",
                text: "나쁜 왕비는 벌을 받아 멀리 쫓겨났고, 공주는 일곱 난쟁이를 자주 초대하며 오래오래 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 잭과 콩나무 — 영국 전래동화 (저작권 소멸)
    // =========================================================

    static let jackAndBeanstalk = StoryScript(
        id: "jack_and_beanstalk",
        titleKo: "잭과 콩나무",
        titleEn: "Jack and the Beanstalk",
        emoji: "🌱",
        synopsis: "마법 콩나무를 타고 구름 위 거인의 성에 오른 잭의 모험 이야기",
        cues: [
            StoryCue(
                id: "jb_00",
                text: "자, 이제 「잭과 콩나무」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "jb_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "jb_01",
                text: "옛날 옛날, 잭이라는 소년이 홀어머니와 함께 살았어요. 집은 몹시 가난해서 남은 것이라곤 늙은 젖소 한 마리뿐이었지요.",
                keyword: "늙은 젖소",
                soundID: "cow_moo",
                delay: 0.3
            ),
            StoryCue(
                id: "jb_01b",
                text: "어머니가 말했어요. '잭, 시장에 가서 소를 팔아 오렴.'"
            ),
            StoryCue(
                id: "jb_02",
                text: "시장 가는 길에 한 할아버지가 잭을 불렀어요. '그 소를 나에게 주면 이 신비한 마법 콩을 주마. 하룻밤이면 하늘까지 자라는 콩이란다!'",
                keyword: "마법 콩",
                soundID: "magic_sparkle"
            ),
            StoryCue(
                id: "jb_02b",
                text: "콩이 반짝반짝 빛나자 잭은 홀린 듯 소와 바꾸고 말았어요."
            ),
            StoryCue(
                id: "jb_03",
                text: "집에 돌아온 잭을 보고 어머니는 기가 막혔어요. '소를 겨우 콩 몇 알과 바꿔 왔다고?' 어머니는 화가 나서 콩을 창밖으로 휙 던져 버렸고, 그날 밤 두 사람은 저녁도 굶고 잠자리에 들었지요.",
                keyword: "창밖으로 휙",
                soundID: "window_open"
            ),
            StoryCue(
                id: "jb_04",
                text: "다음 날 아침, 잭은 창밖을 보고 입이 떡 벌어졌어요. 밤사이 콩나무가 쑥쑥 자라나 구름을 뚫고 하늘 끝까지 뻗어 있는 게 아니겠어요!",
                keyword: "쑥쑥",
                soundID: "magic_whoosh",
                delay: 0.3
            ),
            StoryCue(
                id: "jb_05",
                text: "'저 위엔 뭐가 있을까?' 호기심 많은 잭은 콩나무 줄기를 붙잡고 영차영차 오르기 시작했어요.",
                keyword: "오르기",
                soundID: "climbing"
            ),
            StoryCue(
                id: "jb_05b",
                text: "오르고 또 올라 마침내 구름 위에 도착했지요.",
                keyword: "구름 위에 도착했지요",
                soundID: "mountain_wind"
            ),
            StoryCue(
                id: "jb_06",
                text: "구름 위에는 어마어마하게 큰 성이 있었어요. 잭이 다가가자 육중한 성문이 끼이이익 소리를 내며 열렸어요.",
                keyword: "성문이",
                soundID: "castle_gate"
            ),
            StoryCue(
                id: "jb_06b",
                text: "잭은 살그머니 안으로 들어갔답니다.",
                keyword: "살그머니",
                soundID: "footstep_tiptoe",
                delay: 0.3
            ),
            StoryCue(
                id: "jb_07",
                text: "그때 저 멀리서 무시무시한 발소리가 들려왔어요.",
                keyword: "발소리가",
                soundID: "giant_footstep",
                delay: 0.8
            ),
            StoryCue(
                id: "jb_07b",
                text: "쿵! 쿵! 쿵! 성이 흔들릴 만큼 커다란 거인이 나타났어요!"
            ),
            StoryCue(
                id: "jb_08",
                text: "'킁킁, 어디서 사람 냄새가 나는군!' 잭은 재빨리 커다란 솥 뒤에 숨어 숨을 죽였어요. 거인은 두리번거리다가 식탁에 앉았지요.",
                keyword: "식탁에 앉았지요",
                soundID: "throne_sit"
            ),
            StoryCue(
                id: "jb_09",
                text: "거인이 외쳤어요. '암탉아, 황금알을 낳아라!' 그러자 암탉이 꼬꼬댁 울더니 반짝이는 황금알을 툭 낳았어요.",
                keyword: "암탉이",
                soundID: "hen_cluck",
                delay: 0.3
            ),
            StoryCue(
                id: "jb_09b",
                text: "잭은 눈이 휘둥그레졌답니다.",
                keyword: "눈이 휘둥그레졌답니다",
                soundID: "gasp_surprise"
            ),
            StoryCue(
                id: "jb_10",
                text: "거인은 이번엔 황금 하프에게 명령했어요. '하프야, 연주해라!' 하프가 스스로 줄을 튕기며 아름다운 자장가를 연주하자, 거인은 스르르 잠이 들었어요.",
                keyword: "하프가",
                soundID: "harp_strum",
                delay: 0.3
            ),
            StoryCue(
                id: "jb_11",
                text: "잭은 살금살금 기어 나와 황금알 암탉과 하프를 안아 들었어요. 그런데 그 순간 하프가 소리쳤어요. '주인님, 주인님! 도둑이에요!' 거인이 벌떡 일어났어요!",
                keyword: "벌떡 일어났어요",
                soundID: "giant_footstep"
            ),
            StoryCue(
                id: "jb_12",
                text: "잭은 있는 힘껏 도망쳤어요!",
                keyword: "도망쳤어요",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "jb_12b",
                text: "거인이 성큼성큼 뒤쫓아 왔지만, 몸이 작고 날쌘 잭이 먼저 콩나무에 매달려 미끄러지듯 내려갔지요."
            ),
            StoryCue(
                id: "jb_13",
                text: "땅에 내려온 잭은 재빨리 도끼를 가져와 콩나무 밑동을 힘껏 찍기 시작했어요!",
                keyword: "도끼를",
                soundID: "axe_chop",
                delay: 0.8
            ),
            StoryCue(
                id: "jb_14",
                text: "우지끈! 콩나무가 기울더니 거인과 함께 우르르 쓰러졌어요.",
                keyword: "우르르",
                soundID: "earthquake_rumble"
            ),
            StoryCue(
                id: "jb_14b",
                text: "거인은 땅이 울리도록 쿵 떨어져서는 걸음아 나 살려라 하고 하늘나라로 도망가 버렸답니다."
            ),
            StoryCue(
                id: "jb_15p",
                text: "황금알을 낳는 암탉 덕분에 잭과 어머니는 더 이상 가난하지 않았어요.",
                keyword: "가난하지 않았어요",
                soundID: "coins_jingle"
            ),
            StoryCue(
                id: "jb_15",
                text: "하프의 아름다운 연주를 들으며 두 사람은 오래오래 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 브레멘 음악대 — 그림 형제 (저작권 소멸)
    // =========================================================

    static let bremenMusicians = StoryScript(
        id: "bremen_musicians",
        titleKo: "브레멘 음악대",
        titleEn: "The Bremen Town Musicians",
        emoji: "🎺",
        synopsis: "쫓겨난 네 마리 동물 친구들이 힘을 합쳐 도둑을 물리치는 이야기",
        cues: [
            StoryCue(
                id: "bm_00",
                text: "자, 이제 「브레멘 음악대」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "bm_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "bm_01",
                text: "옛날 어느 마을에 늙은 당나귀가 살았어요.",
                keyword: "당나귀가",
                soundID: "donkey_bray",
                delay: 0.5
            ),
            StoryCue(
                id: "bm_01b",
                text: "주인은 힘이 빠진 당나귀를 내쫓으려 했지요. 당나귀는 슬프게 울고는 결심했어요. '그래, 브레멘에 가서 음악대가 되는 거야!'"
            ),
            StoryCue(
                id: "bm_02",
                text: "길을 가던 당나귀는 풀숲에 축 늘어져 있는 늙은 사냥개 한 마리를 만났어요.",
                keyword: "사냥개",
                soundID: "dog_bark",
                delay: 0.5
            ),
            StoryCue(
                id: "bm_02b",
                text: "'나는 이제 사냥을 못 해서 쫓겨났어, 멍멍.' '그럼 나랑 브레멘에 가서 음악대를 하자!'"
            ),
            StoryCue(
                id: "bm_03",
                text: "조금 더 가자 지붕 위에 시무룩하게 앉아 있는 늙은 고양이가 보였어요.",
                keyword: "고양이가",
                soundID: "cat_meow",
                delay: 0.5
            ),
            StoryCue(
                id: "bm_03b",
                text: "'나는 쥐를 못 잡는다고 쫓겨났어, 야옹.' '우리랑 같이 가자! 넌 세레나데를 부르면 되겠다!'"
            ),
            StoryCue(
                id: "bm_04",
                text: "마을 어귀에서는 수탉이 울타리 위에서 목청껏 울고 있었어요.",
                keyword: "수탉이",
                soundID: "rooster_crow",
                delay: 0.5
            ),
            StoryCue(
                id: "bm_04b",
                text: "'내일 손님상에 오를 처지라네!' '그럼 우리랑 브레멘으로 가자! 네 목소리는 최고의 트럼펫이야!'"
            ),
            StoryCue(
                id: "bm_05",
                text: "이렇게 당나귀, 사냥개, 고양이, 수탉 네 친구는 브레멘을 향해 길을 떠났어요.",
                keyword: "길을 떠났어요",
                soundID: "footstep_walk"
            ),
            StoryCue(
                id: "bm_05b",
                text: "하지만 브레멘은 멀고도 멀어서 하루 만에 도착할 수 없었지요."
            ),
            StoryCue(
                id: "bm_06",
                text: "밤이 되자 네 친구는 어두운 숲에서 하룻밤을 지내기로 했어요.",
                keyword: "밤이 되자",
                soundID: "night_ambience"
            ),
            StoryCue(
                id: "bm_06b",
                text: "사방이 깜깜하고 풀벌레 소리만 가득했지요."
            ),
            StoryCue(
                id: "bm_07",
                text: "그때 수탉이 높은 나무 위에서 외쳤어요. '저기 불빛이 보여!' 네 친구는 불빛을 따라 걸었고, 곧 숲속 외딴집에 다다랐어요."
            ),
            StoryCue(
                id: "bm_08",
                text: "당나귀가 창문 안을 들여다보니, 도둑들이 훔친 금화와 맛있는 음식을 잔뜩 늘어놓고 속닥속닥 이야기를 나누고 있었어요.",
                keyword: "도둑들이",
                soundID: "whisper",
                delay: 0.5
            ),
            StoryCue(
                id: "bm_09",
                text: "네 친구는 꾀를 냈어요. 당나귀 등에 사냥개가 올라가고, 그 위에 고양이, 맨 꼭대기에 수탉이 올라섰지요. '하나, 둘, 셋 하면 다 같이 노래하는 거야!'"
            ),
            StoryCue(
                id: "bm_10",
                text: "'하나, 둘, 셋!' 네 친구는 목청껏 소리 높여 노래했어요!",
                keyword: "목청껏",
                soundID: "donkey_bray",
                delay: 0.3
            ),
            StoryCue(
                id: "bm_10b",
                text: "히힝!",
                keyword: "히힝",
                soundID: "horse_neigh"
            ),
            StoryCue(
                id: "bm_10bb",
                text: "멍멍! 야옹!",
                keyword: "야옹",
                soundID: "cat_meow"
            ),
            StoryCue(
                id: "bm_10bbb",
                text: "꼬끼오! 세상에서 가장 요란한 합창이 울려 퍼졌지요."
            ),
            StoryCue(
                id: "bm_11",
                text: "도둑들은 유령이 나타난 줄 알고 혼비백산했어요. '괴물이다! 도망쳐!' 도둑들은 비명을 지르며 걸음아 나 살려라 숲속으로 달아났답니다.",
                keyword: "비명을",
                soundID: "scream"
            ),
            StoryCue(
                id: "bm_12",
                text: "네 친구는 집으로 들어가 남겨진 음식을 배불리 맛있게 먹었어요.",
                keyword: "맛있게",
                soundID: "eating_crunching"
            ),
            StoryCue(
                id: "bm_12b",
                text: "그리고 각자 편한 자리를 찾아 곤히 잠들었지요.",
                keyword: "곤히 잠들었지요",
                soundID: "snoring"
            ),
            StoryCue(
                id: "bm_13",
                text: "한밤중, 도둑 한 명이 상황을 살피러 살금살금 집으로 돌아왔어요.",
                keyword: "살금살금",
                soundID: "footstep_tiptoe"
            ),
            StoryCue(
                id: "bm_13b",
                text: "집 안은 조용하고 깜깜했지요."
            ),
            StoryCue(
                id: "bm_14",
                text: "그 순간! 고양이가 얼굴을 할퀴고, 사냥개가 다리를 물고, 당나귀가 뒷발로 뻥 걷어찼어요. 수탉은 지붕 위에서 우렁차게 꼬끼오 하고 외쳤답니다!",
                keyword: "꼬끼오",
                soundID: "rooster_crow"
            ),
            StoryCue(
                id: "bm_15",
                text: "도둑은 걸음아 나 살려라 하고 줄행랑을 쳤어요.",
                keyword: "줄행랑",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "bm_15b",
                text: "'그 집엔 무시무시한 괴물들이 살고 있어!' 도둑들은 다시는 그 집 근처에 얼씬도 하지 않았지요."
            ),
            StoryCue(
                id: "bm_16",
                text: "네 친구는 그 아늑한 집이 무척 마음에 들었어요. 브레멘 대신 그곳에서 날마다 즐겁게 노래하며 오래오래 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 늑대와 일곱 마리 아기 염소 — 그림 형제 (저작권 소멸)
    // =========================================================

    static let wolfAndSevenGoats = StoryScript(
        id: "wolf_and_seven_goats",
        titleKo: "늑대와 일곱 마리 아기 염소",
        titleEn: "The Wolf and the Seven Young Goats",
        emoji: "🐐",
        synopsis: "엄마 몰래 찾아온 늑대에게서 살아남은 일곱 아기 염소 이야기",
        cues: [
            StoryCue(
                id: "sg_00",
                text: "자, 이제 「늑대와 일곱 마리 아기 염소」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "sg_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "sg_01",
                text: "옛날 옛날, 엄마 염소와 귀여운 일곱 마리 아기 염소가 살았어요.",
                keyword: "귀여운 일곱 마리",
                soundID: "goat_bleat",
                delay: 0.3
            ),
            StoryCue(
                id: "sg_01b",
                text: "아기 염소들은 매애매애 울며 엄마 곁을 졸졸 따라다녔지요."
            ),
            StoryCue(
                id: "sg_02",
                text: "어느 날 엄마 염소가 먹이를 구하러 나가며 당부했어요. '얘들아, 늑대를 조심하렴. 늑대는 목소리가 거칠고 발이 새까맣단다. 엄마가 올 때까지 절대 문을 열어 주면 안 돼!'"
            ),
            StoryCue(
                id: "sg_03",
                text: "엄마가 나가고 얼마 지나지 않아, 누군가 쿵쿵 문을 두드렸어요.",
                keyword: "문을 두드렸어요",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "sg_04",
                text: "'얘들아, 엄마다. 문 열어 주렴.' 하지만 그 목소리는 몹시 거칠고 낮았어요.",
                keyword: "몹시 거칠고",
                soundID: "wolf_growl",
                delay: 0.3
            ),
            StoryCue(
                id: "sg_04b",
                text: "아기 염소들이 외쳤어요. '거짓말! 우리 엄마 목소리는 곱단 말이야. 너는 늑대지!'"
            ),
            StoryCue(
                id: "sg_05",
                text: "늑대는 가게로 달려가 분필을 꿀꺽 삼켰어요. 그러자 목소리가 고와졌지요.",
                keyword: "목소리가 고와졌지요",
                soundID: "magic_chime"
            ),
            StoryCue(
                id: "sg_05b",
                text: "늑대는 다시 염소네 집으로 갔어요."
            ),
            StoryCue(
                id: "sg_06",
                text: "늑대가 다시 문을 두드리며 고운 목소리로 말했어요.",
                keyword: "다시 문을",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "sg_06b",
                text: "'얘들아, 엄마 왔다.' 그런데 창틀에 올려놓은 발이 새까맸어요! '우리 엄마 발은 하얗단 말이야. 너는 늑대지!'"
            ),
            StoryCue(
                id: "sg_07",
                text: "약이 오른 늑대는 방앗간으로 달려가 발에 하얀 밀가루 반죽을 잔뜩 발랐어요.",
                keyword: "방앗간으로 달려가",
                soundID: "footstep_run",
                delay: 0.3
            ),
            StoryCue(
                id: "sg_07b",
                text: "그리고 세 번째로 염소네 집을 찾아갔지요."
            ),
            StoryCue(
                id: "sg_08",
                text: "고운 목소리에 하얀 발까지 본 아기 염소들은 그만 문을 열어 주었어요.",
                keyword: "열어 주었어요",
                soundID: "door_creak"
            ),
            StoryCue(
                id: "sg_08b",
                text: "문이 스르륵 열리자, 그곳엔 커다란 늑대가 서 있었답니다!"
            ),
            StoryCue(
                id: "sg_09",
                text: "'늑대다!' 아기 염소들은 비명을 지르며 사방으로 숨었어요.",
                keyword: "비명을",
                soundID: "scream"
            ),
            StoryCue(
                id: "sg_09b",
                text: "식탁 밑으로, 이불 속으로, 아궁이 속으로, 저마다 꼭꼭 숨었지요.",
                keyword: "꼭꼭 숨었지요",
                soundID: "footstep_tiptoe"
            ),
            StoryCue(
                id: "sg_10",
                text: "하지만 늑대는 아기 염소들을 한 마리씩 찾아내 꿀꺽꿀꺽 삼켜 버렸어요. 딱 한 마리, 막내 염소만은 째깍째깍 소리가 나는 커다란 괘종시계 속에 숨어 무사했답니다.",
                keyword: "괘종시계",
                soundID: "clock_tick"
            ),
            StoryCue(
                id: "sg_11",
                text: "배가 잔뜩 부른 늑대는 풀밭 나무 아래에 벌러덩 누워 드르렁드르렁 낮잠을 자기 시작했어요.",
                keyword: "낮잠을",
                soundID: "snoring",
                delay: 0.5
            ),
            StoryCue(
                id: "sg_12",
                text: "집에 돌아온 엄마 염소는 엉망이 된 집안을 보고 울음을 터뜨렸어요.",
                keyword: "터뜨렸어요",
                soundID: "crying"
            ),
            StoryCue(
                id: "sg_12b",
                text: "'아가들아, 내 아가들아, 어디 있니!'"
            ),
            StoryCue(
                id: "sg_13",
                text: "그때 괘종시계 문이 빼꼼 열리더니 막내가 기어 나왔어요.",
                keyword: "막내가",
                soundID: "goat_bleat",
                delay: 0.3
            ),
            StoryCue(
                id: "sg_13b",
                text: "'엄마, 늑대가 언니 오빠들을 모두 삼켜 버렸어요!' 막내는 매애매애 울며 엄마 품에 안겼지요."
            ),
            StoryCue(
                id: "sg_14",
                text: "엄마 염소는 막내와 함께 풀밭으로 달려갔어요. 잠든 늑대의 배가 꿈틀꿈틀 움직이고 있는 게 아니겠어요! 엄마는 가위로 늑대의 배를 살짝 가르고 여섯 아기를 모두 꺼냈어요.",
                keyword: "여섯 아기를 모두",
                soundID: "goat_bleat",
                delay: 0.5
            ),
            StoryCue(
                id: "sg_14b",
                text: "그리고 그 자리에 무거운 돌멩이를 가득 채워 꿰맸답니다."
            ),
            StoryCue(
                id: "sg_15",
                text: "잠에서 깬 늑대는 목이 몹시 말랐어요. 우물로 어기적어기적 걸어가 물을 마시려는 순간, 배 속의 돌이 기우뚱! 늑대는 그대로 우물에 풍덩 빠지고 말았어요.",
                keyword: "풍덩",
                soundID: "water_splash"
            ),
            StoryCue(
                id: "sg_16p",
                text: "'늑대가 빠졌다! 늑대가 빠졌다!'",
                keyword: "늑대가 빠졌다",
                soundID: "cheer_crowd"
            ),
            StoryCue(
                id: "sg_16",
                text: "일곱 아기 염소는 엄마와 함께 우물 주위를 빙글빙글 돌며 덩실덩실 춤을 추었어요. 그리고 모두 오래오래 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )

    // =========================================================
    // MARK: 미운 아기 오리 — 안데르센 (저작권 소멸)
    // =========================================================

    static let uglyDuckling = StoryScript(
        id: "ugly_duckling",
        titleKo: "미운 아기 오리",
        titleEn: "The Ugly Duckling",
        emoji: "🦢",
        synopsis: "못생겼다고 놀림받던 아기 오리가 아름다운 백조로 자라나는 이야기",
        cues: [
            StoryCue(
                id: "ud_00",
                text: "자, 이제 「미운 아기 오리」 이야기를 시작할게요.",
                keyword: "시작",
                soundID: "once_upon_time"
            ),
            StoryCue(
                id: "ud_00b",
                text: "모두 귀를 쫑긋 세워 볼까요?"
            ),
            StoryCue(
                id: "ud_01",
                text: "어느 화창한 여름날, 농장 연못가 수풀에서 엄마 오리가 알을 품고 있었어요.",
                keyword: "엄마 오리",
                soundID: "duck_quack",
                delay: 0.5
            ),
            StoryCue(
                id: "ud_01b",
                text: "엄마 오리는 꽥꽥 울며 알들이 깨어나기만을 기다렸지요."
            ),
            StoryCue(
                id: "ud_02",
                text: "드디어 알들이 톡톡 갈라지며 노랗고 보송보송한 아기 오리들이 태어났어요!",
                keyword: "톡톡",
                soundID: "tree_branch_snap"
            ),
            StoryCue(
                id: "ud_02b",
                text: "'삐약삐약, 세상이 참 넓어요, 엄마!'",
                keyword: "삐약삐약",
                soundID: "baby_giggle"
            ),
            StoryCue(
                id: "ud_03",
                text: "그런데 가장 큰 알 하나가 아직 남아 있었어요. 한참 뒤에야 깨어난 마지막 아기는 다른 형제들과 달리 몸집이 크고 잿빛이었어요. 엄마 오리는 고개를 갸웃했지요."
            ),
            StoryCue(
                id: "ud_04",
                text: "농장 동물들은 잿빛 아기 오리를 보고 수군거렸어요. '어쩜 저렇게 못생겼담!' 형제들마저 '미운 오리! 저리 가!' 하고 쪼아 대며 놀렸답니다.",
                keyword: "쪼아 대며",
                soundID: "laughing",
                delay: 0.3
            ),
            StoryCue(
                id: "ud_05",
                text: "아기 오리는 너무 슬퍼서 훌쩍훌쩍 울었어요.",
                keyword: "훌쩍훌쩍",
                soundID: "crying"
            ),
            StoryCue(
                id: "ud_05b",
                text: "'아무도 나를 좋아하지 않아. 차라리 멀리 떠나 버릴 거야.' 아기 오리는 어느 날 밤 몰래 농장을 떠났어요."
            ),
            StoryCue(
                id: "ud_06",
                text: "아기 오리는 넓은 늪가에 도착해 첨벙 물속으로 뛰어들었어요.",
                keyword: "첨벙",
                soundID: "water_splash"
            ),
            StoryCue(
                id: "ud_06b",
                text: "혼자서 헤엄치고 혼자서 잠들었지요. 들새들도 잿빛 아기 오리와는 놀아 주지 않았어요."
            ),
            StoryCue(
                id: "ud_07",
                text: "가을이 가고 겨울이 왔어요. 살을 에는 겨울바람이 늪 위로 매섭게 몰아쳤지요.",
                keyword: "겨울바람이",
                soundID: "wind_howl",
                delay: 0.3
            ),
            StoryCue(
                id: "ud_07b",
                text: "아기 오리는 깃털을 잔뜩 부풀리고 추위를 견뎠어요."
            ),
            StoryCue(
                id: "ud_08",
                text: "먹이를 찾아 꽁꽁 언 눈밭을 헤매기도 했어요.",
                keyword: "눈밭을",
                soundID: "snow_crunch",
                delay: 0.3
            ),
            StoryCue(
                id: "ud_08b",
                text: "발이 시리고 배가 고팠지만, 아기 오리는 꿋꿋하게 긴 겨울을 버텨 냈답니다."
            ),
            StoryCue(
                id: "ud_09",
                text: "마침내 따뜻한 봄이 왔어요!",
                keyword: "봄이",
                soundID: "sunrise_birds",
                delay: 0.5
            ),
            StoryCue(
                id: "ud_09b",
                text: "얼음이 녹고 새싹이 돋아나고, 아침마다 맑은 새소리가 울려 퍼졌지요. 아기 오리는 기지개를 켜고 날개를 활짝 펴 보았어요.",
                keyword: "날개를 활짝",
                soundID: "fairy_wings",
                delay: 0.3
            ),
            StoryCue(
                id: "ud_09bb",
                text: "날개가 몰라보게 크고 힘차졌어요."
            ),
            StoryCue(
                id: "ud_10",
                text: "호수 위에 눈부시게 새하얀 새들이 우아하게 떠 있었어요.",
                keyword: "새하얀",
                soundID: "gasp_surprise",
                delay: 0.3
            ),
            StoryCue(
                id: "ud_10b",
                text: "아기 오리는 숨을 헉 들이켰지요. '세상에, 저렇게 아름다운 새들이 있다니!'"
            ),
            StoryCue(
                id: "ud_11",
                text: "용기를 내어 다가가던 아기 오리는 물에 비친 자기 모습을 보고 깜짝 놀랐어요. 물속에 비친 것은 미운 잿빛 오리가 아니라, 기품 있고 새하얀 백조였어요!",
                keyword: "백조였어요",
                soundID: "magic_chime"
            ),
            StoryCue(
                id: "ud_12",
                text: "백조들이 다가와 반갑게 맞아 주었어요. '우리와 함께 지내자!' 어린 백조는 백조 무리와 함께 물살을 가르며 우아하게 헤엄쳤답니다.",
                keyword: "물살을",
                soundID: "water_splash"
            ),
            StoryCue(
                id: "ud_13",
                text: "호숫가에 놀러 온 아이들이 소리쳤어요. '저기 새로 온 백조 좀 봐! 제일 어리고 제일 아름다워!' 사람들도 모두 감탄했어요.",
                keyword: "감탄했어요",
                soundID: "cheer_crowd",
                delay: 0.3
            ),
            StoryCue(
                id: "ud_14",
                text: "어린 백조는 가슴이 벅차올랐어요. 미운 아기 오리라고 놀림받던 날들은 이제 안녕. 어린 백조는 넓고 푸른 호수에서 오래오래 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )
}
