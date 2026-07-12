import Foundation

/// Reference list of 100 fairy tales researched for sound effects
struct FairyTaleReference: Identifiable {
    let id: String
    let nameKo: String
    let nameEn: String
    let origin: String
    let soundKeywords: [String]  // Key sounds needed for this tale
    
    static let allTales: [FairyTaleReference] = [
        // ━━━ 그림형제 (Brothers Grimm) ━━━
        FairyTaleReference(id: "t01", nameKo: "빨간모자", nameEn: "Little Red Riding Hood", origin: "그림형제", soundKeywords: ["숲", "늑대", "문 두드리기", "발자국"]),
        FairyTaleReference(id: "t02", nameKo: "헨젤과 그레텔", nameEn: "Hansel and Gretel", origin: "그림형제", soundKeywords: ["숲", "새", "오븐", "마녀", "과자집"]),
        FairyTaleReference(id: "t03", nameKo: "백설공주", nameEn: "Snow White", origin: "그림형제", soundKeywords: ["거울", "사과 먹기", "새", "광산", "관 열기"]),
        FairyTaleReference(id: "t04", nameKo: "잠자는 숲속의 미녀", nameEn: "Sleeping Beauty", origin: "그림형제/페로", soundKeywords: ["물레", "코골이", "키스", "팡파레", "성문"]),
        FairyTaleReference(id: "t05", nameKo: "개구리 왕자", nameEn: "The Frog Prince", origin: "그림형제", soundKeywords: ["개구리", "물 튀김", "변신", "공 튕기기"]),
        FairyTaleReference(id: "t06", nameKo: "브레멘 음악대", nameEn: "Town Musicians of Bremen", origin: "그림형제", soundKeywords: ["당나귀", "개", "고양이", "수탉", "창문"]),
        FairyTaleReference(id: "t07", nameKo: "라푼젤", nameEn: "Rapunzel", origin: "그림형제", soundKeywords: ["탑 바람", "머리카락", "오르기", "노래"]),
        FairyTaleReference(id: "t08", nameKo: "룸펠슈틸츠킨", nameEn: "Rumpelstiltskin", origin: "그림형제", soundKeywords: ["물레", "금", "발 구르기"]),
        FairyTaleReference(id: "t09", nameKo: "늑대와 일곱 마리 아기 염소", nameEn: "Wolf and Seven Kids", origin: "그림형제", soundKeywords: ["늑대", "문 두드리기", "시계", "가위"]),
        FairyTaleReference(id: "t10", nameKo: "골디락스와 곰 세 마리", nameEn: "Goldilocks", origin: "그림형제", soundKeywords: ["문 열기", "의자 부러짐", "코골이", "달리기"]),
        FairyTaleReference(id: "t11", nameKo: "푸른 수염", nameEn: "Bluebeard", origin: "그림형제/페로", soundKeywords: ["자물쇠", "열쇠", "문 열기", "으스스한"]),
        FairyTaleReference(id: "t12", nameKo: "백설장미와 빨간장미", nameEn: "Snow-White and Rose-Red", origin: "그림형제", soundKeywords: ["곰", "숲", "보석"]),
        FairyTaleReference(id: "t13", nameKo: "엄지공주", nameEn: "Thumbelina", origin: "안데르센", soundKeywords: ["꽃 피기", "개구리", "새", "물", "날개"]),
        
        // ━━━ 안데르센 (Hans Christian Andersen) ━━━
        FairyTaleReference(id: "t14", nameKo: "인어공주", nameEn: "The Little Mermaid", origin: "안데르센", soundKeywords: ["파도", "갈매기", "수중", "폭풍", "노래"]),
        FairyTaleReference(id: "t15", nameKo: "미운 오리 새끼", nameEn: "The Ugly Duckling", origin: "안데르센", soundKeywords: ["오리", "물 튀김", "새", "바람"]),
        FairyTaleReference(id: "t16", nameKo: "성냥팔이 소녀", nameEn: "The Little Match Girl", origin: "안데르센", soundKeywords: ["성냥", "불", "바람", "눈"]),
        FairyTaleReference(id: "t17", nameKo: "눈의 여왕", nameEn: "The Snow Queen", origin: "안데르센", soundKeywords: ["바람", "눈", "얼음", "썰매", "거울"]),
        FairyTaleReference(id: "t18", nameKo: "벌거벗은 임금님", nameEn: "Emperor's New Clothes", origin: "안데르센", soundKeywords: ["팡파레", "군중", "웃음", "행진"]),
        FairyTaleReference(id: "t19", nameKo: "나이팅게일", nameEn: "The Nightingale", origin: "안데르센", soundKeywords: ["새 노래", "오르골", "궁전"]),
        FairyTaleReference(id: "t20", nameKo: "완두콩 위의 공주", nameEn: "Princess and the Pea", origin: "안데르센", soundKeywords: ["비", "천둥", "문 두드리기"]),
        FairyTaleReference(id: "t21", nameKo: "양치기 소녀와 굴뚝 청소부", nameEn: "Shepherdess & Chimney Sweep", origin: "안데르센", soundKeywords: ["굴뚝", "바람", "도자기"]),
        
        // ━━━ 샤를 페로 (Charles Perrault) ━━━
        FairyTaleReference(id: "t22", nameKo: "신데렐라", nameEn: "Cinderella", origin: "페로", soundKeywords: ["시계 12시", "마법", "마차", "유리구두", "무도회"]),
        FairyTaleReference(id: "t23", nameKo: "장화신은 고양이", nameEn: "Puss in Boots", origin: "페로", soundKeywords: ["고양이", "마차", "성문", "사자"]),
        FairyTaleReference(id: "t24", nameKo: "아기돼지 삼형제", nameEn: "Three Little Pigs", origin: "영국 전래", soundKeywords: ["바람", "집 무너짐", "문 닫기", "늑대", "돼지"]),
        
        // ━━━ 아라비안나이트 (Arabian Nights) ━━━
        FairyTaleReference(id: "t25", nameKo: "알라딘", nameEn: "Aladdin", origin: "천일야화", soundKeywords: ["마법", "지니", "양탄자", "사막", "동굴", "시장"]),
        FairyTaleReference(id: "t26", nameKo: "알리바바와 40인의 도적", nameEn: "Ali Baba and the Forty Thieves", origin: "천일야화", soundKeywords: ["동굴", "보물", "말", "사막"]),
        FairyTaleReference(id: "t27", nameKo: "신밧드의 모험", nameEn: "Sinbad the Sailor", origin: "천일야화", soundKeywords: ["배", "파도", "폭풍", "새", "섬"]),
        
        // ━━━ 영국/아일랜드 전래 ━━━
        FairyTaleReference(id: "t28", nameKo: "잭과 콩나무", nameEn: "Jack and the Beanstalk", origin: "영국", soundKeywords: ["거인", "하프", "오르기", "천둥", "도끼"]),
        FairyTaleReference(id: "t29", nameKo: "로빈 후드", nameEn: "Robin Hood", origin: "영국", soundKeywords: ["화살", "칼", "숲", "말"]),
        FairyTaleReference(id: "t30", nameKo: "아서왕", nameEn: "King Arthur", origin: "영국", soundKeywords: ["칼", "성문", "갑옷", "말", "팡파레"]),
        FairyTaleReference(id: "t31", nameKo: "보물섬", nameEn: "Treasure Island", origin: "스티븐슨", soundKeywords: ["배", "파도", "갈매기", "보물상자", "지도"]),
        
        // ━━━ 클래식 동화 ━━━
        FairyTaleReference(id: "t32", nameKo: "피터팬", nameEn: "Peter Pan", origin: "J.M. 배리", soundKeywords: ["비행", "시계", "칼", "바다", "해적선", "요정"]),
        FairyTaleReference(id: "t33", nameKo: "이상한 나라의 앨리스", nameEn: "Alice in Wonderland", origin: "루이스 캐럴", soundKeywords: ["떨어지기", "시계", "티파티", "크기 변환"]),
        FairyTaleReference(id: "t34", nameKo: "피노키오", nameEn: "Pinocchio", origin: "콜로디", soundKeywords: ["나무 깎기", "귀뚜라미", "고래", "물"]),
        FairyTaleReference(id: "t35", nameKo: "오즈의 마법사", nameEn: "Wizard of Oz", origin: "바움", soundKeywords: ["회오리", "천둥", "사자", "양철", "폭발"]),
        FairyTaleReference(id: "t36", nameKo: "정글북", nameEn: "The Jungle Book", origin: "키플링", soundKeywords: ["정글", "늑대", "곰", "뱀", "폭포", "새"]),
        FairyTaleReference(id: "t37", nameKo: "미녀와 야수", nameEn: "Beauty and the Beast", origin: "프랑스", soundKeywords: ["성문", "장미", "변신", "무도회", "놀람"]),
        FairyTaleReference(id: "t38", nameKo: "호두까기 인형", nameEn: "The Nutcracker", origin: "호프만", soundKeywords: ["오르골", "시계", "북", "쥐", "눈"]),
        FairyTaleReference(id: "t39", nameKo: "비밀의 정원", nameEn: "The Secret Garden", origin: "버넷", soundKeywords: ["정원", "새", "열쇠", "문", "바람"]),
        
        // ━━━ 이솝 우화 (Aesop's Fables) ━━━
        FairyTaleReference(id: "t40", nameKo: "개미와 배짱이", nameEn: "Ant and the Grasshopper", origin: "이솝", soundKeywords: ["귀뚜라미", "바람", "눈"]),
        FairyTaleReference(id: "t41", nameKo: "토끼와 거북이", nameEn: "Tortoise and the Hare", origin: "이솝", soundKeywords: ["달리기", "환호", "코골이"]),
        FairyTaleReference(id: "t42", nameKo: "사자와 쥐", nameEn: "Lion and the Mouse", origin: "이솝", soundKeywords: ["사자", "쥐", "그물"]),
        FairyTaleReference(id: "t43", nameKo: "양치기 소년", nameEn: "Boy Who Cried Wolf", origin: "이솝", soundKeywords: ["늑대", "양", "외침", "마을"]),
        FairyTaleReference(id: "t44", nameKo: "여우와 포도", nameEn: "Fox and the Grapes", origin: "이솝", soundKeywords: ["여우", "점프"]),
        FairyTaleReference(id: "t45", nameKo: "바람과 태양", nameEn: "North Wind and the Sun", origin: "이솝", soundKeywords: ["바람", "햇살"]),
        FairyTaleReference(id: "t46", nameKo: "시골쥐와 도시쥐", nameEn: "Country Mouse and City Mouse", origin: "이솝", soundKeywords: ["쥐", "마차", "고양이"]),
        
        // ━━━ 한국 전래 동화 ━━━
        FairyTaleReference(id: "t47", nameKo: "해님 달님", nameEn: "Sun and Moon", origin: "한국", soundKeywords: ["호랑이", "문 두드리기", "밧줄", "수탉"]),
        FairyTaleReference(id: "t48", nameKo: "콩쥐 팥쥐", nameEn: "Kongjwi Patjwi", origin: "한국", soundKeywords: ["새", "소", "두꺼비", "잔치"]),
        FairyTaleReference(id: "t49", nameKo: "흥부와 놀부", nameEn: "Heungbu and Nolbu", origin: "한국", soundKeywords: ["제비", "박 깨기", "보물", "도깨비"]),
        FairyTaleReference(id: "t50", nameKo: "금도끼 은도끼", nameEn: "Gold Axe Silver Axe", origin: "한국", soundKeywords: ["도끼", "물 튀김", "산신령"]),
        FairyTaleReference(id: "t51", nameKo: "선녀와 나무꾼", nameEn: "The Woodcutter and the Fairy", origin: "한국", soundKeywords: ["사슴", "폭포", "날개", "바람"]),
        FairyTaleReference(id: "t52", nameKo: "호랑이와 곶감", nameEn: "Tiger and Dried Persimmon", origin: "한국", soundKeywords: ["호랑이", "울음", "밤 배경"]),
        FairyTaleReference(id: "t53", nameKo: "별주부전", nameEn: "Tale of Byeoljubu", origin: "한국", soundKeywords: ["거북이", "바다", "토끼"]),
        FairyTaleReference(id: "t54", nameKo: "심청전", nameEn: "Simcheong", origin: "한국", soundKeywords: ["바다", "물 튀김", "연꽃", "울음", "팡파레"]),
        FairyTaleReference(id: "t55", nameKo: "견우와 직녀", nameEn: "The Cowherd and the Weaver Girl", origin: "한국/동아시아", soundKeywords: ["까치", "강", "바람", "울음"]),
        FairyTaleReference(id: "t56", nameKo: "도깨비방망이", nameEn: "Goblin's Club", origin: "한국", soundKeywords: ["도깨비", "방망이", "보물", "밤"]),
        FairyTaleReference(id: "t57", nameKo: "장화홍련", nameEn: "Janghwa Hongryeon", origin: "한국", soundKeywords: ["유령", "연못", "밤", "바람"]),
        
        // ━━━ 일본 전래 ━━━
        FairyTaleReference(id: "t58", nameKo: "모모타로", nameEn: "Momotaro", origin: "일본", soundKeywords: ["강", "개", "원숭이", "꿩", "배"]),
        FairyTaleReference(id: "t59", nameKo: "우라시마 타로", nameEn: "Urashima Taro", origin: "일본", soundKeywords: ["바다", "거북이", "상자 열기", "바람"]),
        FairyTaleReference(id: "t60", nameKo: "카구야 히메", nameEn: "Tale of the Bamboo Cutter", origin: "일본", soundKeywords: ["대나무", "달빛", "바람", "울음"]),
        
        // ━━━ 중국 전래 ━━━
        FairyTaleReference(id: "t61", nameKo: "무란", nameEn: "Mulan", origin: "중국", soundKeywords: ["말", "칼", "갑옷", "북", "바람"]),
        FairyTaleReference(id: "t62", nameKo: "여우의 구슬", nameEn: "Fox's Marble", origin: "중국/한국", soundKeywords: ["여우", "밤", "달빛", "구슬"]),
        
        // ━━━ 러시아/동유럽 ━━━
        FairyTaleReference(id: "t63", nameKo: "바바야가", nameEn: "Baba Yaga", origin: "러시아", soundKeywords: ["숲", "닭 발 집", "바람", "마녀"]),
        FairyTaleReference(id: "t64", nameKo: "불새", nameEn: "The Firebird", origin: "러시아", soundKeywords: ["날개", "불", "마법", "말"]),
        FairyTaleReference(id: "t65", nameKo: "눈소녀", nameEn: "The Snow Maiden", origin: "러시아", soundKeywords: ["눈", "바람", "불", "녹는 소리"]),
        
        // ━━━ 아프리카 ━━━
        FairyTaleReference(id: "t66", nameKo: "아난시", nameEn: "Anansi the Spider", origin: "서아프리카", soundKeywords: ["거미줄", "숲", "동물들"]),
        
        // ━━━ 인도 ━━━
        FairyTaleReference(id: "t67", nameKo: "판차탄트라", nameEn: "Panchatantra", origin: "인도", soundKeywords: ["정글", "원숭이", "악어", "새"]),
        
        // ━━━ 근현대 동화 ━━━
        FairyTaleReference(id: "t68", nameKo: "나니아 연대기", nameEn: "Chronicles of Narnia", origin: "루이스", soundKeywords: ["옷장", "눈", "사자", "칼", "숲"]),
        FairyTaleReference(id: "t69", nameKo: "해리 포터", nameEn: "Harry Potter", origin: "롤링", soundKeywords: ["마법", "빗자루", "올빼미", "폭발", "주문"]),
        FairyTaleReference(id: "t70", nameKo: "곰돌이 푸", nameEn: "Winnie the Pooh", origin: "밀른", soundKeywords: ["벌", "새", "부엉이", "비", "숲"]),
        FairyTaleReference(id: "t71", nameKo: "걸리버 여행기", nameEn: "Gulliver's Travels", origin: "스위프트", soundKeywords: ["배", "거인", "파도"]),
        FairyTaleReference(id: "t72", nameKo: "피터와 늑대", nameEn: "Peter and the Wolf", origin: "프로코피예프", soundKeywords: ["피리", "늑대", "새", "오리"]),
        FairyTaleReference(id: "t73", nameKo: "타잔", nameEn: "Tarzan", origin: "버로스", soundKeywords: ["정글", "로프", "원숭이", "폭포"]),
        FairyTaleReference(id: "t74", nameKo: "노트르담의 꼽추", nameEn: "Hunchback of Notre Dame", origin: "위고", soundKeywords: ["종", "성당", "불", "군중"]),
        FairyTaleReference(id: "t75", nameKo: "크리스마스 캐럴", nameEn: "A Christmas Carol", origin: "디킨스", soundKeywords: ["쇠사슬", "유령", "종", "촛불", "시계"]),
        
        // ━━━ 현대 인기 그림책 ━━━
        FairyTaleReference(id: "t76", nameKo: "아주 배고픈 애벌레", nameEn: "Very Hungry Caterpillar", origin: "에릭 칼", soundKeywords: ["먹기", "바스락", "나비 날개"]),
        FairyTaleReference(id: "t77", nameKo: "괴물들이 사는 나라", nameEn: "Where the Wild Things Are", origin: "센닥", soundKeywords: ["괴물", "배", "파도", "으르렁"]),
        FairyTaleReference(id: "t78", nameKo: "구름빵", nameEn: "Cloud Bread", origin: "백희나", soundKeywords: ["오븐", "바람", "비행", "구름"]),
        FairyTaleReference(id: "t79", nameKo: "무지개 물고기", nameEn: "Rainbow Fish", origin: "피스터", soundKeywords: ["수중", "물방울", "반짝임"]),
        FairyTaleReference(id: "t80", nameKo: "달 샤베트", nameEn: "Moon Sherbet", origin: "백희나", soundKeywords: ["달빛", "얼음", "물방울"]),
        FairyTaleReference(id: "t81", nameKo: "이상한 화요일", nameEn: "Tuesday", origin: "비즈너", soundKeywords: ["개구리", "날개", "밤"]),
        FairyTaleReference(id: "t82", nameKo: "수박 수영장", nameEn: "Watermelon Pool", origin: "안녕달", soundKeywords: ["물 튀김", "먹기", "여름"]),
        FairyTaleReference(id: "t83", nameKo: "팥빙수의 전설", nameEn: "Legend of Red Bean Shaved Ice", origin: "이지은", soundKeywords: ["얼음 깎기", "숟가락", "먹기"]),
        FairyTaleReference(id: "t84", nameKo: "장갑", nameEn: "The Mitten", origin: "브렛", soundKeywords: ["눈", "동물들", "찢어지기"]),
        FairyTaleReference(id: "t85", nameKo: "100층짜리 집", nameEn: "House of 100 Stories", origin: "이와이 토시오", soundKeywords: ["오르기", "동물들", "문 열기"]),
        
        // ━━━ 전래/민화 추가 ━━━
        FairyTaleReference(id: "t86", nameKo: "피리 부는 사나이", nameEn: "Pied Piper of Hamelin", origin: "독일", soundKeywords: ["피리", "쥐", "마을", "강"]),
        FairyTaleReference(id: "t87", nameKo: "백조의 호수", nameEn: "Swan Lake", origin: "차이코프스키", soundKeywords: ["백조", "물", "마법", "음악"]),
        FairyTaleReference(id: "t88", nameKo: "왕자와 거지", nameEn: "The Prince and the Pauper", origin: "마크 트웨인", soundKeywords: ["팡파레", "시장", "궁전"]),
        FairyTaleReference(id: "t89", nameKo: "하이디", nameEn: "Heidi", origin: "슈피리", soundKeywords: ["산 바람", "종", "염소", "새"]),
        FairyTaleReference(id: "t90", nameKo: "빨간 신발", nameEn: "The Red Shoes", origin: "안데르센", soundKeywords: ["춤", "음악", "종"]),
        FairyTaleReference(id: "t91", nameKo: "드라큘라", nameEn: "Dracula", origin: "스토커", soundKeywords: ["박쥐", "문", "밤", "늑대"]),
        FairyTaleReference(id: "t92", nameKo: "슈렉", nameEn: "Shrek", origin: "스타이그", soundKeywords: ["늪", "당나귀", "용", "성"]),
        FairyTaleReference(id: "t93", nameKo: "요술 냄비", nameEn: "The Magic Pot", origin: "그림형제", soundKeywords: ["냄비 끓기", "넘치기"]),
        FairyTaleReference(id: "t94", nameKo: "산타클로스", nameEn: "Twas the Night Before Christmas", origin: "무어", soundKeywords: ["썰매", "종", "굴뚝", "눈"]),
        FairyTaleReference(id: "t95", nameKo: "메리다", nameEn: "Brave (Merida)", origin: "현대", soundKeywords: ["화살", "말", "숲", "곰"]),
        FairyTaleReference(id: "t96", nameKo: "발레리나", nameEn: "Ballerina", origin: "현대", soundKeywords: ["오르골", "춤", "음악"]),
        FairyTaleReference(id: "t97", nameKo: "프랑켄슈타인", nameEn: "Frankenstein", origin: "메리 셸리", soundKeywords: ["천둥", "번개", "쇠사슬"]),
        FairyTaleReference(id: "t98", nameKo: "모비딕", nameEn: "Moby Dick", origin: "멜빌", soundKeywords: ["고래", "배", "파도", "폭풍"]),
        FairyTaleReference(id: "t99", nameKo: "엘프", nameEn: "The Elves and the Shoemaker", origin: "그림형제", soundKeywords: ["망치", "밤", "마법"]),
        FairyTaleReference(id: "t100", nameKo: "니모를 찾아서", nameEn: "Finding Nemo", origin: "현대", soundKeywords: ["수중", "물방울", "물고기", "고래"]),
    ]
}
