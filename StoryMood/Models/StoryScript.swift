import Foundation

// MARK: - StoryCue

struct StoryCue: Identifiable {
    let id: String
    let text: String         // 낭독할 본문 문단
    let keyword: String?     // 이 단어를 말하면 소리 재생. nil이면 순수 낭독 문단
    let soundID: String?     // keyword 없으면 nil

    var isCompleted = false
    var hasCue: Bool { keyword != nil && soundID != nil }

    /// 순수 낭독 문단
    init(id: String, text: String) {
        self.id = id; self.text = text; self.keyword = nil; self.soundID = nil
    }

    /// 효과음 큐 문단
    init(id: String, text: String, keyword: String, soundID: String) {
        self.id = id; self.text = text; self.keyword = keyword; self.soundID = soundID
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

    static let allScripts: [StoryScript] = [hanselAndGretel, littleRedRidingHood, cinderella]

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
                id: "hg_01",
                text: "옛날 옛날, 커다란 숲 가장자리에 가난한 나무꾼이 살았어요. 그에게는 헨젤과 그레텔이라는 남매가 있었지요. 두 아이는 언제나 사이가 좋았고 서로를 아껴 주었어요."
            ),
            StoryCue(
                id: "hg_02",
                text: "그런데 나무꾼의 두 번째 아내, 즉 아이들의 계모는 아이들을 조금도 아끼지 않았어요. 계모는 날마다 아이들에게 일만 시켰고, 밥도 조금밖에 주지 않았답니다."
            ),
            StoryCue(
                id: "hg_03",
                text: "어느 해 겨울, 온 나라에 심한 흉년이 들었어요. 차가운 바람이 숲 사이를 파고들었고 밥상에 올릴 음식이 하나도 남지 않았답니다.",
                keyword: "바람이",
                soundID: "wind_blow"
            ),
            StoryCue(
                id: "hg_04",
                text: "그날 밤, 계모가 남편에게 낮은 목소리로 속삭였어요. '이제 우리가 먹을 것도 없어요. 내일 아이들을 숲 깊은 곳에 두고 와요. 그래야 우리라도 살 수 있어요.' 나무꾼은 가슴이 아팠지만 결국 고개를 끄덕이고 말았지요.",
                keyword: "속삭였어요",
                soundID: "whisper"
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
                keyword: "숲속으로",
                soundID: "forest_ambience"
            ),
            StoryCue(
                id: "hg_07",
                text: "헨젤은 걸으면서 주머니 속 조약돌을 하나씩 길바닥에 살짝 떨어뜨렸어요. 뒤돌아보지 않아도 흰 조약돌이 길을 표시해 주고 있다는 걸 헨젤은 알고 있었지요."
            ),
            StoryCue(
                id: "hg_08",
                text: "계모는 한참을 걷다가 모닥불을 피워 두었어요. '여기서 기다려라, 곧 돌아올게.' 계모는 그렇게 말하고 홀연히 사라졌어요. 머리 위 나뭇가지에서 새들이 맑고 고운 소리로 노래했어요. 아이들은 불가에 앉아 밤이 오기를 기다렸어요.",
                keyword: "새들이",
                soundID: "bird_singing"
            ),
            StoryCue(
                id: "hg_09",
                text: "밤이 되자 둥근 달이 떠올랐어요. 달빛을 받아 조약돌들이 반짝반짝 빛났어요. 남매는 그 빛을 따라 걷고 또 걸어, 새벽녘이 되어서야 집으로 돌아왔답니다. 아버지는 두 아이를 꼭 안아 주었어요.",
                keyword: "반짝반짝",
                soundID: "magic_sparkle"
            ),
            StoryCue(
                id: "hg_10",
                text: "하지만 계모는 포기하지 않았어요. 며칠 뒤 계모는 다시 아이들을 숲에 버리려 했어요. 이번에는 문을 단단히 잠가 두었기에 헨젤이 조약돌을 가져올 수 없었어요. 헨젤은 대신 밥 한 조각을 주머니에 숨겼어요."
            ),
            StoryCue(
                id: "hg_11",
                text: "헨젤은 숲길을 걸으면서 빵 부스러기를 하나씩 떨어뜨렸지요. 하지만 숲속에 사는 배고픈 새들이 어느새 빵 부스러기를 깨끗이 먹어 버렸어요."
            ),
            StoryCue(
                id: "hg_12",
                text: "길을 잃은 남매는 사흘 밤낮을 숲속에서 헤맸어요. 배는 너무 고프고 다리는 아파서 쓰러질 것만 같았어요. 차가운 밤바람이 불어와 두 아이는 서로를 꼭 안았어요.",
                keyword: "길을 잃은",
                soundID: "wind_blow"
            ),
            StoryCue(
                id: "hg_13",
                text: "그때 하얀 비둘기 한 마리가 나타나 두 아이 앞에서 살살 날아갔어요. 헨젤과 그레텔은 비둘기를 따라 걸었어요. 그러자 달콤하고 향기로운 냄새가 솔솔 풍겨 왔어요."
            ),
            StoryCue(
                id: "hg_14",
                text: "나무 사이로 놀라운 것이 보였어요. 지붕은 케이크, 벽은 생강 과자, 창문은 투명한 설탕으로 만든 집이었어요. 과자로 만든 집이 나타났어요! 두 아이는 반쯤 정신을 잃은 채 허겁지겁 과자 집을 뜯어 먹기 시작했어요.",
                keyword: "과자로",
                soundID: "eating_crunching"
            ),
            StoryCue(
                id: "hg_15",
                text: "그때 집 안에서 가느다란 목소리가 들렸어요. '똑똑, 누가 내 집을 먹고 있니?' 문이 삐걱 열리더니 허리가 굽은 할머니가 얼굴을 내밀었어요.",
                keyword: "똑똑",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "hg_16",
                text: "'이리 오렴, 어서. 맛있는 것을 실컷 먹여 줄게.' 할머니는 따뜻하게 웃으며 아이들을 집 안으로 안내했어요. 사실 그 할머니는 아이들을 잡아먹는 끔찍한 마녀였답니다.",
                keyword: "집 안으로",
                soundID: "door_slam"
            ),
            StoryCue(
                id: "hg_17a",
                text: "다음 날 아침, 마녀는 헨젤을 붙잡아 철창 안에 가두었어요. 자물쇠가 철컥 잠겼어요. 헨젤은 철창 사이로 그레텔을 바라보며 '괜찮아'라고 속삭였지요.",
                keyword: "철창 안에",
                soundID: "lock_unlock"
            ),
            StoryCue(
                id: "hg_17",
                text: "마녀는 그레텔에게 날마다 헨젤을 살찌울 음식을 만들게 했지요. 마녀가 깔깔깔 웃었어요. '살이 올라야 맛있단 말이지!'",
                keyword: "마녀가",
                soundID: "witch_cackle"
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
                text: "마녀는 그레텔을 오븐 쪽으로 밀었어요. '어서 안을 들여다봐. 온도가 맞는지 확인해.' 그레텔은 무서웠지만 침착하게 꾀를 냈어요. '할머니, 어떻게 들여다봐야 해요? 한번 보여 주세요.'"
            ),
            StoryCue(
                id: "hg_21",
                text: "마녀가 몸을 굽혀 오븐 안을 들여다보는 순간, 그레텔은 온 힘을 다해 마녀를 오븐 속으로 밀어 넣고 문을 쾅 닫았어요! 그레텔은 헨젤의 철창 문을 열어 주었고, 두 아이는 마녀의 보물 상자를 챙겨 뛰쳐나왔어요. 두 아이는 빠르게 도망쳤어요.",
                keyword: "도망쳤어요",
                soundID: "footstep_run"
            ),
            StoryCue(
                id: "hg_22",
                text: "숲을 빠져나오자 커다란 강이 앞을 막았어요. 다리가 없어서 어떻게 건널까 망설이고 있을 때, 하얀 오리 한 마리가 꽤꽤 울며 헤엄쳐 왔어요. 오리는 두 아이를 등에 태워 강 건너편까지 데려다 주었답니다.",
                keyword: "오리 한 마리",
                soundID: "duck_quack"
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
                id: "lrrh_01",
                text: "옛날 옛날, 작은 마을 어귀에 누구에게나 사랑받는 귀여운 소녀가 살았어요. 소녀의 할머니는 손수 만들어 준 빨간 망토와 모자를 선물로 주었는데, 소녀는 어디를 가든 항상 그것을 쓰고 다녔어요."
            ),
            StoryCue(
                id: "lrrh_02",
                text: "그 때문에 마을 사람들은 모두 소녀를 '빨간 모자'라고 불렀답니다. 빨간 모자는 밝고 씩씩하고 마음씨도 고와서 마을에서 모르는 사람이 없었어요.",
                keyword: "빨간 모자",
                soundID: "magic_chime"
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
                text: "숲속은 참 아름다웠어요. 키 큰 나무들 사이로 햇살이 내리쬐고, 새들이 맑은 소리로 노래했어요. 길가에는 형형색색의 꽃들이 활짝 피어 있었답니다.",
                keyword: "새들이",
                soundID: "bird_singing"
            ),
            StoryCue(
                id: "lrrh_06",
                text: "빨간 모자는 꽃을 꺾어 할머니께 드리고 싶었어요. '이 예쁜 꽃다발을 드리면 할머니가 기뻐하실 거야.' 빨간 모자는 길에서 살짝 벗어나 예쁜 꽃들을 하나씩 꺾기 시작했어요.",
                keyword: "꺾기 시작했어요",
                soundID: "leaves_rustle"
            ),
            StoryCue(
                id: "lrrh_07",
                text: "그때 수풀이 바스락거리더니 차가운 바람이 불어왔어요. 나뭇잎이 흔들리며 커다란 회색 늑대 한 마리가 모습을 드러냈어요.",
                keyword: "바람이",
                soundID: "wind_blow"
            ),
            StoryCue(
                id: "lrrh_08",
                text: "'안녕, 꼬마야. 어디 가는 거니?' 늑대가 달콤한 목소리로 물었어요. 빨간 모자는 늑대가 얼마나 무서운 동물인지 몰랐어요. '숲 건너편 할머니 댁에 가요. 할머니가 편찮으셔서요.'"
            ),
            StoryCue(
                id: "lrrh_09",
                text: "'할머니 댁이 어디에 있니?' 늑대가 물었어요. 빨간 모자는 순진하게 길을 알려 주었어요. 늑대는 속으로 못된 생각을 품으며 낮게 으르렁거렸어요. '그렇구나, 먼저 가렴. 나도 곧 갈게.'",
                keyword: "으르렁",
                soundID: "wolf_growl"
            ),
            StoryCue(
                id: "lrrh_10",
                text: "늑대는 지름길로 달려가 할머니 댁에 먼저 도착했어요. 늑대가 문을 두드리자 할머니가 '누구냐?' 하고 물었어요. '저예요, 빨간 모자요.' 늑대가 목소리를 꾸며 대답했어요.",
                keyword: "문을 두드리자",
                soundID: "door_knock"
            ),
            StoryCue(
                id: "lrrh_11",
                text: "할머니가 문을 열자 늑대는 단숨에 달려들어 할머니를 꿀꺽 삼켜 버렸어요. 그리고 할머니의 나이트가운을 입고 머리 수건을 쓴 뒤 침대에 누워 이불을 뒤집어썼어요.",
                keyword: "꿀꺽",
                soundID: "evil_laugh"
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
                text: "'할머니, 입이 왜 그렇게 커요?' '너를 잡아먹기 위해서야!' 늑대가 이불을 걷어 내며 벌떡 일어나 크게 울부짖었어요. 빨간 모자는 비명을 지르며 뒤로 물러섰어요.",
                keyword: "울부짖었어요",
                soundID: "wolf_howl"
            ),
            StoryCue(
                id: "lrrh_16",
                text: "마침 근처 숲에서 사냥을 나온 사냥꾼이 그 비명 소리를 들었어요. '저 집에서 이상한 소리가 나는군!' 사냥꾼이 총을 들고 달려왔어요.",
                keyword: "사냥꾼이",
                soundID: "footstep_walk"
            ),
            StoryCue(
                id: "lrrh_17",
                text: "사냥꾼이 문을 박차고 들어왔어요. 사냥꾼은 늑대의 배를 가르자 할머니가 무사히 나왔어요. 배를 가른 자리에 돌을 넣고 꿰매자 늑대는 달아나다 그 무게에 쓰러지고 말았어요."
            ),
            StoryCue(
                id: "lrrh_18",
                text: "할머니는 빨간 모자가 가져온 케이크와 포도주를 드시고 금세 기운을 차리셨어요. 사냥꾼은 늑대 가죽을 챙겨 돌아갔어요. 빨간 모자는 할머니 품에 꼭 안겨 한참을 울었어요."
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
                id: "cin_01",
                text: "옛날 옛날, 부유한 상인에게 마음씨 고운 딸이 하나 있었어요. 소녀의 어머니는 소녀가 어릴 때 세상을 떠났어요. 아버지는 딸이 외로울까 봐 다시 결혼했지만, 새엄마는 소녀를 전혀 아끼지 않았답니다."
            ),
            StoryCue(
                id: "cin_02",
                text: "새엄마에게는 딸이 둘 있었어요. 두 언니는 새엄마를 닮아 심술궂었어요. 그들은 소녀에게 온갖 집안일을 시키며 구박했어요. 소녀는 부뚜막 가에서 일하다 재투성이가 되기 일쑤였어요. 그래서 사람들은 소녀를 신데렐라라고 불렀어요.",
                keyword: "신데렐라",
                soundID: "wind_blow"
            ),
            StoryCue(
                id: "cin_03",
                text: "신데렐라는 힘든 하루하루도 불평 없이 보냈어요. 마당의 비둘기들과 이야기를 나누며 마음을 달랬고, 돌아가신 어머니를 생각하며 힘을 냈어요."
            ),
            StoryCue(
                id: "cin_04",
                text: "그러던 어느 날, 왕궁으로부터 화려한 무도회 초대장이 날아왔어요. 나라 안의 모든 아가씨를 초대하여 왕자님이 직접 만나고 싶다는 내용이었지요.",
                keyword: "초대장이",
                soundID: "trumpet_fanfare"
            ),
            StoryCue(
                id: "cin_05",
                text: "새엄마와 두 언니는 신이 났어요. 며칠 동안 예쁜 드레스와 보석을 고르느라 정신이 없었어요. 신데렐라도 함께 가고 싶다고 했지만 새엄마는 콧방귀를 뀌었어요. '너 같은 재투성이가 무도회에? 어림도 없지!'"
            ),
            StoryCue(
                id: "cin_06",
                text: "무도회 날이 되었어요. 언니들은 화사하게 치장하고 마차에 올라탔어요. 신데렐라는 현관 앞에서 마차가 멀어지는 것을 물끄러미 바라보다가 부엌으로 돌아와 엉엉 울었어요.",
                keyword: "울었어요",
                soundID: "crying"
            ),
            StoryCue(
                id: "cin_07",
                text: "그때 부엌이 갑자기 환하게 빛나더니 작고 반짝이는 빛이 나타났어요. 빛이 점점 커지면서 은빛 머리카락을 가진 요정이 나타났어요. '울지 마렴, 신데렐라. 내가 도와줄게.'",
                keyword: "요정이",
                soundID: "magic_sparkle"
            ),
            StoryCue(
                id: "cin_08",
                text: "요정 할머니는 지팡이를 꺼내 들었어요. '먼저 텃밭에서 가장 큰 호박을 가져오렴.' 신데렐라가 호박을 가져오자 요정 할머니가 지팡이를 휘두르며 마법을 부렸어요.",
                keyword: "마법을",
                soundID: "magic_wand"
            ),
            StoryCue(
                id: "cin_09",
                text: "펑! 커다란 호박이 눈부신 빛을 내더니 황금빛 마차로 변했어요! 신데렐라의 낡은 치마는 은빛 드레스가 되었고, 발에는 유리로 만든 아름다운 구두가 신겨졌어요.",
                keyword: "호박이",
                soundID: "magic_transform"
            ),
            StoryCue(
                id: "cin_10",
                text: "'하지만 자정, 열두 시가 되면 모든 마법이 풀린다는 걸 잊지 마렴.' 요정 할머니가 당부했어요. 여섯 마리의 하얀 말이 콧김을 내뿜으며 힘차게 달리기 시작했어요. 마차는 왕궁을 향해 달렸어요.",
                keyword: "말이",
                soundID: "horse_gallop"
            ),
            StoryCue(
                id: "cin_11",
                text: "왕궁에 도착하자 눈부신 빛과 화려한 장식이 신데렐라를 맞이했어요. 무도회에서 아름다운 음악이 흘렀어요. 수백 개의 촛불이 홀을 환하게 밝히고 있었어요.",
                keyword: "무도회에서",
                soundID: "harp_strum"
            ),
            StoryCue(
                id: "cin_12",
                text: "신데렐라가 계단을 내려서자 홀 안이 조용해졌어요. 모든 사람들이 숨을 죽이고 바라보았어요. 두 언니도 신데렐라인 줄 전혀 알아보지 못했지요.",
                keyword: "숨을 죽이고",
                soundID: "gasp_surprise"
            ),
            StoryCue(
                id: "cin_13",
                text: "왕자님이 신데렐라를 보고 황홀한 표정으로 다가왔어요. '이렇게 아름다운 분은 처음 뵙습니다. 저와 함께 춤을 추어 주시겠어요?' 왕자님이 손을 내밀었어요.",
                keyword: "왕자님이",
                soundID: "royal_fanfare"
            ),
            StoryCue(
                id: "cin_14",
                text: "두 사람은 하룻밤 내내 함께 춤을 추었어요. 왕자님은 신데렐라에게서 눈을 뗄 수가 없었어요. 신데렐라도 꿈속에 있는 것처럼 행복했지요. 시간이 얼마나 흘렀는지 깨닫지 못했어요.",
                keyword: "춤을 추었어요",
                soundID: "ballroom_music"
            ),
            StoryCue(
                id: "cin_15",
                text: "그때 멀리서 시계 소리가 울려 퍼지기 시작했어요. 하나, 둘, 셋... 궁전 시계탑의 종이 쉬지 않고 울렸어요. 열두 시가 되었어요!",
                keyword: "열두 시",
                soundID: "clock_chime_12"
            ),
            StoryCue(
                id: "cin_16",
                text: "신데렐라는 '안 돼!'를 외치며 왕자님의 손을 뿌리치고 계단을 뛰어 내려갔어요. 마지막 계단에서 그만 유리 구두 한 짝이 벗겨지고 말았지만, 돌아볼 여유가 없었어요."
            ),
            StoryCue(
                id: "cin_17",
                text: "왕궁 밖으로 나서는 순간 마법이 풀려 마차는 다시 호박이 되었고, 드레스는 낡은 옷으로 돌아왔어요. 신데렐라는 헐레벌떡 집으로 달려가 부엌 아궁이 옆에 앉았어요.",
                keyword: "마법이 풀려",
                soundID: "magic_poof"
            ),
            StoryCue(
                id: "cin_18",
                text: "왕자님은 계단에 떨어진 유리 구두를 소중히 들고 선포했어요. '이 구두의 주인을 찾겠노라. 그 분이 나의 신부가 될 것이다.' 신하들은 유리 구두를 들고 온 나라를 돌아다니며 아가씨들에게 신겨 보았어요.",
                keyword: "유리 구두",
                soundID: "glass_slipper"
            ),
            StoryCue(
                id: "cin_19",
                text: "드디어 신데렐라의 집에도 왕자님 일행이 찾아왔어요. 두 언니는 앞다투어 구두를 신어 보았지만 발이 너무 커서 전혀 들어가지 않았어요. '혹시 다른 아가씨는 없나요?'"
            ),
            StoryCue(
                id: "cin_20",
                text: "신데렐라가 조심스럽게 나와 구두를 발에 대어 보았어요. 딱 맞았어요! 그 순간 요정 할머니의 마법이 다시 펼쳐지며 신데렐라는 다시 아름다운 드레스를 입었어요.",
                keyword: "딱 맞았어요",
                soundID: "magic_chime"
            ),
            StoryCue(
                id: "cin_21",
                text: "왕자님과 신데렐라는 성대한 결혼식을 올렸어요. 신데렐라는 넓은 마음으로 두 언니와 새엄마까지 용서했어요. 모두가 함께 행복하게 살았답니다.",
                keyword: "행복하게",
                soundID: "happy_ending"
            ),
        ]
    )
}
