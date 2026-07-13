import Foundation

// MARK: - Sound Library
// Sounds researched from 100+ classic fairy tales and children's stories
// Each sound is tagged with the fairy tales where it would be used

struct SoundLibrary {
    
    static let shared = SoundLibrary()

    let allSounds: [SoundEffect]
    let soundsByID: [String: SoundEffect]
    
    init() {
        var sounds: [SoundEffect] = []
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🚪 문과 집 (Doors & House)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "door_knock", nameKo: "똑똑똑 (문 두드리기)", nameEn: "Door Knock", emoji: "🚪", fileName: "door_knock", categoryID: "door_house",
                relatedTales: ["빨간모자", "아기돼지 삼형제", "헨젤과 그레텔", "금도끼 은도끼"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "door_knock")),
            
            SoundEffect(id: "door_creak", nameKo: "끼이익 (문 열림)", nameEn: "Door Creak Open", emoji: "🚪", fileName: "door_creak", categoryID: "door_house",
                relatedTales: ["파랑새", "푸른 수염", "비밀의 정원", "이상한 나라의 앨리스"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "door_creak")),
            
            SoundEffect(id: "door_slam", nameKo: "쾅! (문 닫힘)", nameEn: "Door Slam", emoji: "🚪", fileName: "door_slam", categoryID: "door_house",
                relatedTales: ["아기돼지 삼형제", "파랑새", "늑대와 일곱 마리 아기 염소"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "door_slam")),
            
            SoundEffect(id: "lock_unlock", nameKo: "찰칵 (자물쇠)", nameEn: "Lock/Unlock", emoji: "🔐", fileName: "lock_unlock", categoryID: "door_house",
                relatedTales: ["푸른 수염", "라푼젤", "비밀의 정원"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "lock_unlock")),
            
            SoundEffect(id: "key_jingle", nameKo: "딸랑 (열쇠)", nameEn: "Key Jingle", emoji: "🗝️", fileName: "key_jingle", categoryID: "door_house",
                relatedTales: ["푸른 수염", "비밀의 정원", "피노키오"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "key_jingle")),
            
            SoundEffect(id: "window_open", nameKo: "창문 열기", nameEn: "Window Open", emoji: "🪟", fileName: "window_open", categoryID: "door_house",
                relatedTales: ["라푼젤", "피터팬", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "window_open")),
            
            SoundEffect(id: "floor_creak", nameKo: "삐걱 (바닥)", nameEn: "Floor Creak", emoji: "🏠", fileName: "floor_creak", categoryID: "door_house",
                relatedTales: ["골디락스와 곰 세 마리", "헨젤과 그레텔", "늑대와 일곱 마리 아기 염소"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "floor_creak")),
            
            SoundEffect(id: "chimney_sweep", nameKo: "굴뚝 소리", nameEn: "Chimney Sound", emoji: "🏠", fileName: "chimney_sweep", categoryID: "door_house",
                relatedTales: ["아기돼지 삼형제", "산타클로스", "신데렐라"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "chimney_sweep")),
            
            SoundEffect(id: "house_collapse", nameKo: "우당탕 (집 무너짐)", nameEn: "House Collapse", emoji: "💨", fileName: "house_collapse", categoryID: "door_house",
                relatedTales: ["아기돼지 삼형제"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "house_collapse")),
            
            SoundEffect(id: "curtain_swoosh", nameKo: "스윽 (커튼)", nameEn: "Curtain Swoosh", emoji: "🪟", fileName: "curtain_swoosh", categoryID: "door_house",
                relatedTales: ["잠자는 숲속의 미녀", "오즈의 마법사"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "curtain_swoosh")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🌿 자연과 날씨 (Nature & Weather)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "wind_blow", nameKo: "휘이잉 (바람)", nameEn: "Wind Blowing", emoji: "💨", fileName: "wind_blow", categoryID: "nature_weather",
                relatedTales: ["아기돼지 삼형제", "오즈의 마법사", "눈의 여왕", "바람과 태양"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "wind_blow")),
            
            SoundEffect(id: "wind_howl", nameKo: "우우웅 (강풍)", nameEn: "Wind Howling", emoji: "🌪️", fileName: "wind_howl", categoryID: "nature_weather",
                relatedTales: ["아기돼지 삼형제", "눈의 여왕", "오즈의 마법사"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "wind_howl")),
            
            SoundEffect(id: "rain_light", nameKo: "소슬소슬 (이슬비)", nameEn: "Light Rain", emoji: "🌧️", fileName: "rain_light", categoryID: "nature_weather",
                relatedTales: ["개구리 왕자", "비 오는 날의 공주", "노아의 방주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "rain_light")),
            
            SoundEffect(id: "rain_heavy", nameKo: "콸콸 (폭우)", nameEn: "Heavy Rain", emoji: "⛈️", fileName: "rain_heavy", categoryID: "nature_weather",
                relatedTales: ["노아의 방주", "비 오는 날의 공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "rain_heavy")),
            
            SoundEffect(id: "thunder", nameKo: "쿠르르 쾅! (천둥)", nameEn: "Thunder", emoji: "⚡", fileName: "thunder", categoryID: "nature_weather",
                relatedTales: ["잭과 콩나무", "오즈의 마법사", "프랑켄슈타인"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "thunder")),
            
            SoundEffect(id: "leaves_rustle", nameKo: "사각사각 (나뭇잎)", nameEn: "Leaves Rustling", emoji: "🍃", fileName: "leaves_rustle", categoryID: "nature_weather",
                relatedTales: ["빨간모자", "헨젤과 그레텔", "잠자는 숲속의 미녀", "정글북"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "leaves_rustle")),
            
            SoundEffect(id: "tree_branch_snap", nameKo: "뚝 (나뭇가지)", nameEn: "Branch Snap", emoji: "🌳", fileName: "tree_branch_snap", categoryID: "nature_weather",
                relatedTales: ["빨간모자", "헨젤과 그레텔", "로빈 후드"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "tree_branch_snap")),
            
            SoundEffect(id: "snow_crunch", nameKo: "뽀드득 (눈 밟기)", nameEn: "Snow Crunch", emoji: "❄️", fileName: "snow_crunch", categoryID: "nature_weather",
                relatedTales: ["눈의 여왕", "성냥팔이 소녀", "나니아 연대기"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "snow_crunch")),
            
            SoundEffect(id: "forest_ambience", nameKo: "숲 속 배경음", nameEn: "Forest Ambience", emoji: "🌲", fileName: "forest_ambience", categoryID: "nature_weather",
                relatedTales: ["빨간모자", "헨젤과 그레텔", "백설공주", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "forest_ambience")),
            
            SoundEffect(id: "earthquake_rumble", nameKo: "우르르 (지진)", nameEn: "Earthquake Rumble", emoji: "🌋", fileName: "earthquake_rumble", categoryID: "nature_weather",
                relatedTales: ["잭과 콩나무", "오즈의 마법사"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "earthquake_rumble")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🐾 동물 (Animals)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "wolf_howl", nameKo: "아우우 (늑대 울음)", nameEn: "Wolf Howl", emoji: "🐺", fileName: "wolf_howl", categoryID: "animals",
                relatedTales: ["빨간모자", "아기돼지 삼형제", "늑대와 일곱 마리 아기 염소", "피터와 늑대"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "wolf_howl")),
            
            SoundEffect(id: "wolf_growl", nameKo: "그르르 (늑대 으르렁)", nameEn: "Wolf Growl", emoji: "🐺", fileName: "wolf_growl", categoryID: "animals",
                relatedTales: ["빨간모자", "아기돼지 삼형제"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "wolf_growl")),
            
            SoundEffect(id: "bird_singing", nameKo: "짹짹 (새 노래)", nameEn: "Bird Singing", emoji: "🐦", fileName: "bird_singing", categoryID: "animals",
                relatedTales: ["백설공주", "신데렐라", "잠자는 숲속의 미녀", "엄지공주", "나이팅게일"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "bird_singing")),
            
            SoundEffect(id: "rooster_crow", nameKo: "꼬끼오 (수탉)", nameEn: "Rooster Crow", emoji: "🐓", fileName: "rooster_crow", categoryID: "animals",
                relatedTales: ["브레멘 음악대", "해님 달님"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "rooster_crow")),
            
            SoundEffect(id: "frog_croak", nameKo: "개굴개굴 (개구리)", nameEn: "Frog Croak", emoji: "🐸", fileName: "frog_croak", categoryID: "animals",
                relatedTales: ["개구리 왕자", "엄지공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "frog_croak")),
            
            SoundEffect(id: "bear_growl", nameKo: "으르렁 (곰)", nameEn: "Bear Growl", emoji: "🐻", fileName: "bear_growl", categoryID: "animals",
                relatedTales: ["골디락스와 곰 세 마리", "백설장미와 빨간장미"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "bear_growl")),
            
            SoundEffect(id: "horse_neigh", nameKo: "히이잉 (말 울음)", nameEn: "Horse Neigh", emoji: "🐴", fileName: "horse_neigh", categoryID: "animals",
                relatedTales: ["신데렐라", "잠자는 숲속의 미녀", "로빈 후드", "무란"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "horse_neigh")),
            
            SoundEffect(id: "cat_meow", nameKo: "야옹 (고양이)", nameEn: "Cat Meow", emoji: "🐱", fileName: "cat_meow", categoryID: "animals",
                relatedTales: ["장화신은 고양이", "브레멘 음악대"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "cat_meow")),
            
            SoundEffect(id: "dog_bark", nameKo: "멍멍 (개)", nameEn: "Dog Bark", emoji: "🐶", fileName: "dog_bark", categoryID: "animals",
                relatedTales: ["브레멘 음악대", "오즈의 마법사"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "dog_bark")),
            
            SoundEffect(id: "donkey_bray", nameKo: "히이하 (당나귀)", nameEn: "Donkey Bray", emoji: "🫏", fileName: "donkey_bray", categoryID: "animals",
                relatedTales: ["브레멘 음악대", "슈렉", "피노키오"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "donkey_bray")),
            
            SoundEffect(id: "mouse_squeak", nameKo: "찍찍 (쥐)", nameEn: "Mouse Squeak", emoji: "🐭", fileName: "mouse_squeak", categoryID: "animals",
                relatedTales: ["신데렐라", "호두까기 인형", "엄지공주", "사자와 쥐"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "mouse_squeak")),
            
            SoundEffect(id: "snake_hiss", nameKo: "쉬이이 (뱀)", nameEn: "Snake Hiss", emoji: "🐍", fileName: "snake_hiss", categoryID: "animals",
                relatedTales: ["정글북", "알라딘"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "snake_hiss")),
            
            SoundEffect(id: "lion_roar", nameKo: "어흥 (사자)", nameEn: "Lion Roar", emoji: "🦁", fileName: "lion_roar", categoryID: "animals",
                relatedTales: ["오즈의 마법사", "나니아 연대기", "사자와 쥐"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "lion_roar")),
            
            SoundEffect(id: "pig_oink", nameKo: "꿀꿀 (돼지)", nameEn: "Pig Oink", emoji: "🐷", fileName: "pig_oink", categoryID: "animals",
                relatedTales: ["아기돼지 삼형제"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "pig_oink")),
            
            SoundEffect(id: "duck_quack", nameKo: "꽥꽥 (오리)", nameEn: "Duck Quack", emoji: "🦆", fileName: "duck_quack", categoryID: "animals",
                relatedTales: ["미운 오리 새끼"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "duck_quack")),
            
            SoundEffect(id: "cricket_chirp", nameKo: "귀뚜르 (귀뚜라미)", nameEn: "Cricket Chirp", emoji: "🦗", fileName: "cricket_chirp", categoryID: "animals",
                relatedTales: ["개미와 배짱이", "피노키오"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "cricket_chirp")),
            
            SoundEffect(id: "bee_buzz", nameKo: "윙윙 (벌)", nameEn: "Bee Buzz", emoji: "🐝", fileName: "bee_buzz", categoryID: "animals",
                relatedTales: ["곰돌이 푸", "엄지공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "bee_buzz")),

            SoundEffect(id: "goat_bleat", nameKo: "매애 (아기 염소)", nameEn: "Goat Bleat", emoji: "🐐", fileName: "goat_bleat", categoryID: "animals",
                relatedTales: ["늑대와 일곱 마리 아기 염소", "아기 염소 삼형제"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "goat_bleat")),

            SoundEffect(id: "hen_cluck", nameKo: "꼬꼬댁 (암탉)", nameEn: "Hen Cluck", emoji: "🐔", fileName: "hen_cluck", categoryID: "animals",
                relatedTales: ["잭과 콩나무", "황금알을 낳는 거위", "빨간 암탉"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "hen_cluck")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🌊 바다와 물 (Ocean & Water)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "ocean_waves", nameKo: "파도 소리", nameEn: "Ocean Waves", emoji: "🌊", fileName: "ocean_waves", categoryID: "ocean_water",
                relatedTales: ["인어공주", "신밧드의 모험", "피터팬", "보물섬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "ocean_waves")),
            
            SoundEffect(id: "water_splash", nameKo: "첨벙! (물 튀김)", nameEn: "Water Splash", emoji: "💦", fileName: "water_splash", categoryID: "ocean_water",
                relatedTales: ["개구리 왕자", "인어공주", "엄지공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "water_splash")),
            
            SoundEffect(id: "water_drip", nameKo: "똑똑 (물방울)", nameEn: "Water Drip", emoji: "💧", fileName: "water_drip", categoryID: "ocean_water",
                relatedTales: ["알리바바와 40인의 도적", "동굴 탐험"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "water_drip")),
            
            SoundEffect(id: "stream_flow", nameKo: "졸졸 (시냇물)", nameEn: "Stream Flow", emoji: "🏞️", fileName: "stream_flow", categoryID: "ocean_water",
                relatedTales: ["빨간모자", "백설공주", "엄지공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "stream_flow")),
            
            SoundEffect(id: "underwater_bubble", nameKo: "보글보글 (수중 거품)", nameEn: "Underwater Bubbles", emoji: "🫧", fileName: "underwater_bubble", categoryID: "ocean_water",
                relatedTales: ["인어공주", "니모를 찾아서"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "underwater_bubble")),
            
            SoundEffect(id: "seagull_cry", nameKo: "끼룩 (갈매기)", nameEn: "Seagull Cry", emoji: "🕊️", fileName: "seagull_cry", categoryID: "ocean_water",
                relatedTales: ["인어공주", "보물섬", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "seagull_cry")),
            
            SoundEffect(id: "whale_song", nameKo: "고래 노래", nameEn: "Whale Song", emoji: "🐋", fileName: "whale_song", categoryID: "ocean_water",
                relatedTales: ["피노키오", "모비딕"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "whale_song")),
            
            SoundEffect(id: "waterfall", nameKo: "콸콸 (폭포)", nameEn: "Waterfall", emoji: "🌊", fileName: "waterfall", categoryID: "ocean_water",
                relatedTales: ["정글북", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "waterfall")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: ✨ 마법과 판타지 (Magic & Fantasy)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "magic_sparkle", nameKo: "반짝✨ (마법 반짝임)", nameEn: "Magic Sparkle", emoji: "✨", fileName: "magic_sparkle", categoryID: "magic_fantasy",
                relatedTales: ["신데렐라", "잠자는 숲속의 미녀", "피터팬", "알라딘"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magic_sparkle")),
            
            SoundEffect(id: "magic_wand", nameKo: "슈웅 (마법 지팡이)", nameEn: "Magic Wand Wave", emoji: "🪄", fileName: "magic_wand", categoryID: "magic_fantasy",
                relatedTales: ["신데렐라", "잠자는 숲속의 미녀", "해리 포터"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magic_wand")),
            
            SoundEffect(id: "magic_transform", nameKo: "변신! (마법 변신)", nameEn: "Transformation", emoji: "🔮", fileName: "magic_transform", categoryID: "magic_fantasy",
                relatedTales: ["개구리 왕자", "신데렐라", "백조의 호수", "미녀와 야수"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magic_transform")),
            
            SoundEffect(id: "magic_poof", nameKo: "펑! (마법 연기)", nameEn: "Magic Poof", emoji: "💨", fileName: "magic_poof", categoryID: "magic_fantasy",
                relatedTales: ["알라딘", "신데렐라", "지니"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magic_poof")),
            
            SoundEffect(id: "fairy_wings", nameKo: "파르르 (요정 날개)", nameEn: "Fairy Wings Flutter", emoji: "🧚", fileName: "fairy_wings", categoryID: "magic_fantasy",
                relatedTales: ["피터팬", "엄지공주", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "fairy_wings")),
            
            SoundEffect(id: "magic_potion", nameKo: "보글보글 (마법 물약)", nameEn: "Magic Potion Bubble", emoji: "🧪", fileName: "magic_potion", categoryID: "magic_fantasy",
                relatedTales: ["백설공주", "인어공주", "알라딘", "이상한 나라의 앨리스"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magic_potion")),
            
            SoundEffect(id: "magic_chime", nameKo: "띵~ (마법 종소리)", nameEn: "Magic Chime", emoji: "🔔", fileName: "magic_chime", categoryID: "magic_fantasy",
                relatedTales: ["피터팬", "크리스마스 캐럴", "엘프"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magic_chime")),
            
            SoundEffect(id: "magic_whoosh", nameKo: "휘이잉 (마법 바람)", nameEn: "Magic Whoosh", emoji: "🌀", fileName: "magic_whoosh", categoryID: "magic_fantasy",
                relatedTales: ["오즈의 마법사", "알라딘", "해리 포터"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magic_whoosh")),
            
            SoundEffect(id: "spell_cast", nameKo: "주문 외우기", nameEn: "Spell Casting", emoji: "📜", fileName: "spell_cast", categoryID: "magic_fantasy",
                relatedTales: ["잠자는 숲속의 미녀", "눈의 여왕", "알라딘"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "spell_cast")),
            
            SoundEffect(id: "mirror_magic", nameKo: "거울아 거울아", nameEn: "Magic Mirror", emoji: "🪞", fileName: "mirror_magic", categoryID: "magic_fantasy",
                relatedTales: ["백설공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "mirror_magic")),
            
            SoundEffect(id: "genie_appear", nameKo: "지니 등장", nameEn: "Genie Appear", emoji: "🧞", fileName: "genie_appear", categoryID: "magic_fantasy",
                relatedTales: ["알라딘"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "genie_appear")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 👣 발자국과 움직임 (Footsteps & Movement)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "footstep_walk", nameKo: "뚜벅뚜벅 (걷기)", nameEn: "Walking", emoji: "🚶", fileName: "footstep_walk", categoryID: "footsteps_movement",
                relatedTales: ["빨간모자", "헨젤과 그레텔", "오즈의 마법사"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "footstep_walk")),
            
            SoundEffect(id: "footstep_run", nameKo: "다다다 (달리기)", nameEn: "Running", emoji: "🏃", fileName: "footstep_run", categoryID: "footsteps_movement",
                relatedTales: ["빨간모자", "잭과 콩나무", "헨젤과 그레텔"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "footstep_run")),
            
            SoundEffect(id: "footstep_tiptoe", nameKo: "사뿐사뿐 (살금살금)", nameEn: "Tiptoeing", emoji: "🤫", fileName: "footstep_tiptoe", categoryID: "footsteps_movement",
                relatedTales: ["골디락스와 곰 세 마리", "잭과 콩나무", "늑대와 일곱 마리 아기 염소"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "footstep_tiptoe")),
            
            SoundEffect(id: "giant_footstep", nameKo: "쿵쿵쿵 (거인 발자국)", nameEn: "Giant Footsteps", emoji: "🦶", fileName: "giant_footstep", categoryID: "footsteps_movement",
                relatedTales: ["잭과 콩나무", "걸리버 여행기"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "giant_footstep")),
            
            SoundEffect(id: "climbing", nameKo: "영차영차 (오르기)", nameEn: "Climbing", emoji: "🧗", fileName: "climbing", categoryID: "footsteps_movement",
                relatedTales: ["잭과 콩나무", "라푼젤"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "climbing")),
            
            SoundEffect(id: "jumping", nameKo: "폴짝! (점프)", nameEn: "Jumping", emoji: "⬆️", fileName: "jumping", categoryID: "footsteps_movement",
                relatedTales: ["개구리 왕자", "이상한 나라의 앨리스"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "jumping")),
            
            SoundEffect(id: "falling", nameKo: "으아아 (떨어지기)", nameEn: "Falling", emoji: "⬇️", fileName: "falling", categoryID: "footsteps_movement",
                relatedTales: ["이상한 나라의 앨리스", "잭과 콩나무", "라푼젤"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "falling")),
            
            SoundEffect(id: "sliding", nameKo: "미끄르르 (미끄러지기)", nameEn: "Sliding", emoji: "🛝", fileName: "sliding", categoryID: "footsteps_movement",
                relatedTales: ["이상한 나라의 앨리스", "눈의 여왕"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "sliding")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🔥 불과 부엌 (Fire & Kitchen)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "fire_crackle", nameKo: "타닥타닥 (모닥불)", nameEn: "Fire Crackling", emoji: "🔥", fileName: "fire_crackle", categoryID: "fire_kitchen",
                relatedTales: ["성냥팔이 소녀", "헨젤과 그레텔", "백설공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "fire_crackle")),
            
            SoundEffect(id: "pot_boiling", nameKo: "보글보글 (냄비 끓기)", nameEn: "Pot Boiling", emoji: "🫕", fileName: "pot_boiling", categoryID: "fire_kitchen",
                relatedTales: ["헨젤과 그레텔", "백설공주", "잭과 콩나무", "요술 냄비"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "pot_boiling")),
            
            SoundEffect(id: "oven_door", nameKo: "끼이익 (오븐 문)", nameEn: "Oven Door", emoji: "🫕", fileName: "oven_door", categoryID: "fire_kitchen",
                relatedTales: ["헨젤과 그레텔"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "oven_door")),
            
            SoundEffect(id: "chopping", nameKo: "똑똑똑 (칼질)", nameEn: "Chopping", emoji: "🔪", fileName: "chopping", categoryID: "fire_kitchen",
                relatedTales: ["잭과 콩나무", "빨간모자"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "chopping")),
            
            SoundEffect(id: "eating_crunching", nameKo: "아삭아삭 (먹기)", nameEn: "Eating/Crunching", emoji: "🍎", fileName: "eating_crunching", categoryID: "fire_kitchen",
                relatedTales: ["백설공주", "골디락스와 곰 세 마리", "헨젤과 그레텔"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "eating_crunching")),
            
            SoundEffect(id: "pouring_liquid", nameKo: "쏴아 (따르기)", nameEn: "Pouring", emoji: "🫖", fileName: "pouring_liquid", categoryID: "fire_kitchen",
                relatedTales: ["이상한 나라의 앨리스", "골디락스와 곰 세 마리"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "pouring_liquid")),
            
            SoundEffect(id: "match_strike", nameKo: "치익 (성냥)", nameEn: "Match Strike", emoji: "🔥", fileName: "match_strike", categoryID: "fire_kitchen",
                relatedTales: ["성냥팔이 소녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "match_strike")),
            
            SoundEffect(id: "candle_blow", nameKo: "후~ (촛불 끄기)", nameEn: "Candle Blow", emoji: "🕯️", fileName: "candle_blow", categoryID: "fire_kitchen",
                relatedTales: ["잠자는 숲속의 미녀", "크리스마스 캐럴"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "candle_blow")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🎵 음악과 악기 (Music & Instruments)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "harp_strum", nameKo: "딩딩~ (하프)", nameEn: "Harp Strum", emoji: "🎶", fileName: "harp_strum", categoryID: "music_instruments",
                relatedTales: ["잭과 콩나무", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "harp_strum")),
            
            SoundEffect(id: "music_box", nameKo: "오르골", nameEn: "Music Box", emoji: "🎁", fileName: "music_box", categoryID: "music_instruments",
                relatedTales: ["호두까기 인형", "발레리나"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "music_box")),
            
            SoundEffect(id: "flute_play", nameKo: "피리 연주", nameEn: "Flute Playing", emoji: "🎵", fileName: "flute_play", categoryID: "music_instruments",
                relatedTales: ["피리 부는 사나이", "피터와 늑대"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "flute_play")),
            
            SoundEffect(id: "drum_beat", nameKo: "둥둥 (북)", nameEn: "Drum Beat", emoji: "🥁", fileName: "drum_beat", categoryID: "music_instruments",
                relatedTales: ["호두까기 인형", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "drum_beat")),
            
            SoundEffect(id: "trumpet_fanfare", nameKo: "빠빠빠~ (나팔)", nameEn: "Trumpet Fanfare", emoji: "🎺", fileName: "trumpet_fanfare", categoryID: "music_instruments",
                relatedTales: ["잠자는 숲속의 미녀", "신데렐라", "왕자와 거지"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "trumpet_fanfare")),
            
            SoundEffect(id: "bell_ring", nameKo: "땡땡 (종)", nameEn: "Bell Ring", emoji: "🔔", fileName: "bell_ring", categoryID: "music_instruments",
                relatedTales: ["크리스마스 캐럴", "노트르담의 꼽추"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "bell_ring")),
            
            SoundEffect(id: "singing_voice", nameKo: "라라라~ (노래)", nameEn: "Singing Voice", emoji: "🎤", fileName: "singing_voice", categoryID: "music_instruments",
                relatedTales: ["인어공주", "라푼젤", "백설공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "singing_voice")),
            
            SoundEffect(id: "lullaby", nameKo: "자장가 멜로디", nameEn: "Lullaby", emoji: "🌙", fileName: "lullaby", categoryID: "music_instruments",
                relatedTales: ["잠자는 숲속의 미녀", "엄지공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "lullaby")),
            
            SoundEffect(id: "spinning_wheel", nameKo: "물레 돌아가는 소리", nameEn: "Spinning Wheel", emoji: "🧶", fileName: "spinning_wheel", categoryID: "music_instruments",
                relatedTales: ["잠자는 숲속의 미녀", "룸펠슈틸츠킨"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "spinning_wheel")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🌙 으스스한 밤 (Spooky & Night)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "owl_hoot", nameKo: "부엉부엉 (부엉이)", nameEn: "Owl Hoot", emoji: "🦉", fileName: "owl_hoot", categoryID: "spooky_night",
                relatedTales: ["헨젤과 그레텔", "빨간모자", "곰돌이 푸"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "owl_hoot")),
            
            SoundEffect(id: "ghost_moan", nameKo: "으으으 (유령)", nameEn: "Ghost Moan", emoji: "👻", fileName: "ghost_moan", categoryID: "spooky_night",
                relatedTales: ["크리스마스 캐럴", "함흥 도깨비"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "ghost_moan")),
            
            SoundEffect(id: "witch_cackle", nameKo: "캬캬캬 (마녀 웃음)", nameEn: "Witch Cackle", emoji: "🧙‍♀️", fileName: "witch_cackle", categoryID: "spooky_night",
                relatedTales: ["헨젤과 그레텔", "백설공주", "오즈의 마법사", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "witch_cackle")),
            
            SoundEffect(id: "bat_flutter", nameKo: "퍼덕퍼덕 (박쥐)", nameEn: "Bat Flutter", emoji: "🦇", fileName: "bat_flutter", categoryID: "spooky_night",
                relatedTales: ["드라큘라", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "bat_flutter")),
            
            SoundEffect(id: "night_ambience", nameKo: "고요한 밤", nameEn: "Night Ambience", emoji: "🌙", fileName: "night_ambience", categoryID: "spooky_night",
                relatedTales: ["빨간모자", "헨젤과 그레텔", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "night_ambience")),
            
            SoundEffect(id: "creepy_music", nameKo: "으스스한 배경음", nameEn: "Creepy Music", emoji: "🎃", fileName: "creepy_music", categoryID: "spooky_night",
                relatedTales: ["헨젤과 그레텔", "백설공주", "푸른 수염"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "creepy_music")),
            
            SoundEffect(id: "wolf_howl_night", nameKo: "밤의 늑대 울음", nameEn: "Nighttime Wolf Howl", emoji: "🌕", fileName: "wolf_howl_night", categoryID: "spooky_night",
                relatedTales: ["빨간모자", "아기돼지 삼형제"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "wolf_howl_night")),
            
            SoundEffect(id: "chains_rattle", nameKo: "쩔컹쩔컹 (쇠사슬)", nameEn: "Chains Rattling", emoji: "⛓️", fileName: "chains_rattle", categoryID: "spooky_night",
                relatedTales: ["크리스마스 캐럴", "감옥"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "chains_rattle")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: ⚔️ 모험과 액션 (Adventure & Action)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "sword_clash", nameKo: "챙! (칼 부딪힘)", nameEn: "Sword Clash", emoji: "⚔️", fileName: "sword_clash", categoryID: "adventure_action",
                relatedTales: ["피터팬", "로빈 후드", "아서왕", "무란"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "sword_clash")),
            
            SoundEffect(id: "sword_draw", nameKo: "슈잉 (칼 뽑기)", nameEn: "Sword Draw", emoji: "🗡️", fileName: "sword_draw", categoryID: "adventure_action",
                relatedTales: ["아서왕", "피터팬", "로빈 후드"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "sword_draw")),
            
            SoundEffect(id: "arrow_shoot", nameKo: "휘잉 (화살)", nameEn: "Arrow Shoot", emoji: "🏹", fileName: "arrow_shoot", categoryID: "adventure_action",
                relatedTales: ["로빈 후드", "메리다"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "arrow_shoot")),
            
            SoundEffect(id: "treasure_open", nameKo: "보물 상자 열기", nameEn: "Treasure Chest Open", emoji: "💰", fileName: "treasure_open", categoryID: "adventure_action",
                relatedTales: ["알리바바와 40인의 도적", "보물섬", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "treasure_open")),
            
            SoundEffect(id: "rope_swing", nameKo: "로프 스윙", nameEn: "Rope Swing", emoji: "🪢", fileName: "rope_swing", categoryID: "adventure_action",
                relatedTales: ["타잔", "피터팬", "잭과 콩나무"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "rope_swing")),
            
            SoundEffect(id: "shield_block", nameKo: "탕! (방패 막기)", nameEn: "Shield Block", emoji: "🛡️", fileName: "shield_block", categoryID: "adventure_action",
                relatedTales: ["아서왕", "무란"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "shield_block")),
            
            SoundEffect(id: "explosion", nameKo: "펑! (폭발)", nameEn: "Explosion", emoji: "💥", fileName: "explosion", categoryID: "adventure_action",
                relatedTales: ["오즈의 마법사", "해리 포터"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "explosion")),
            
            SoundEffect(id: "map_unroll", nameKo: "바스락 (지도 펼치기)", nameEn: "Map Unroll", emoji: "🗺️", fileName: "map_unroll", categoryID: "adventure_action",
                relatedTales: ["보물섬", "피터팬", "신밧드의 모험"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "map_unroll")),

            SoundEffect(id: "axe_chop", nameKo: "쿵! (도끼질)", nameEn: "Axe Chop", emoji: "🪓", fileName: "axe_chop", categoryID: "adventure_action",
                relatedTales: ["잭과 콩나무", "금도끼 은도끼", "아기 돼지 삼형제"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "axe_chop")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🐴 이동수단 (Transport & Travel)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "horse_gallop", nameKo: "따그닥 (말 달리기)", nameEn: "Horse Gallop", emoji: "🐴", fileName: "horse_gallop", categoryID: "transport_travel",
                relatedTales: ["신데렐라", "잠자는 숲속의 미녀", "무란", "로빈 후드"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "horse_gallop")),
            
            SoundEffect(id: "carriage_ride", nameKo: "덜커덩 (마차)", nameEn: "Carriage Ride", emoji: "🎠", fileName: "carriage_ride", categoryID: "transport_travel",
                relatedTales: ["신데렐라", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "carriage_ride")),
            
            SoundEffect(id: "boat_rowing", nameKo: "첨벙첨벙 (노 젓기)", nameEn: "Boat Rowing", emoji: "🚣", fileName: "boat_rowing", categoryID: "transport_travel",
                relatedTales: ["인어공주", "엄지공주", "보물섬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "boat_rowing")),
            
            SoundEffect(id: "ship_creak", nameKo: "삐걱 (배 흔들림)", nameEn: "Ship Creaking", emoji: "⛵", fileName: "ship_creak", categoryID: "transport_travel",
                relatedTales: ["피터팬", "보물섬", "신밧드의 모험"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "ship_creak")),
            
            SoundEffect(id: "flying_carpet", nameKo: "부웅 (마법 양탄자)", nameEn: "Flying Carpet", emoji: "🧞", fileName: "flying_carpet", categoryID: "transport_travel",
                relatedTales: ["알라딘"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "flying_carpet")),
            
            SoundEffect(id: "broomstick_fly", nameKo: "쌩! (빗자루 비행)", nameEn: "Broomstick Flying", emoji: "🧹", fileName: "broomstick_fly", categoryID: "transport_travel",
                relatedTales: ["오즈의 마법사", "해리 포터"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "broomstick_fly")),
            
            SoundEffect(id: "sled_sliding", nameKo: "스윽스윽 (썰매)", nameEn: "Sled Sliding", emoji: "🛷", fileName: "sled_sliding", categoryID: "transport_travel",
                relatedTales: ["눈의 여왕", "산타클로스"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "sled_sliding")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 👶 사람과 목소리 (People & Voices)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "laughing", nameKo: "하하하 (웃음)", nameEn: "Laughing", emoji: "😄", fileName: "laughing", categoryID: "people_voice",
                relatedTales: ["피터팬", "피노키오", "골디락스와 곰 세 마리"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "laughing")),
            
            SoundEffect(id: "crying", nameKo: "흑흑 (울음)", nameEn: "Crying", emoji: "😢", fileName: "crying", categoryID: "people_voice",
                relatedTales: ["인어공주", "신데렐라", "성냥팔이 소녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "crying")),
            
            SoundEffect(id: "gasp_surprise", nameKo: "헐! (놀람)", nameEn: "Gasp", emoji: "😲", fileName: "gasp_surprise", categoryID: "people_voice",
                relatedTales: ["백설공주", "이상한 나라의 앨리스", "미녀와 야수"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "gasp_surprise")),
            
            SoundEffect(id: "whisper", nameKo: "쉿 (속삭임)", nameEn: "Whisper", emoji: "🤫", fileName: "whisper", categoryID: "people_voice",
                relatedTales: ["헨젤과 그레텔", "엄지공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "whisper")),
            
            SoundEffect(id: "cheer_crowd", nameKo: "와아! (환호)", nameEn: "Crowd Cheer", emoji: "🎉", fileName: "cheer_crowd", categoryID: "people_voice",
                relatedTales: ["신데렐라", "잠자는 숲속의 미녀", "벌거벗은 임금님"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "cheer_crowd")),
            
            SoundEffect(id: "snoring", nameKo: "드르렁 (코골이)", nameEn: "Snoring", emoji: "😴", fileName: "snoring", categoryID: "people_voice",
                relatedTales: ["잠자는 숲속의 미녀", "골디락스와 곰 세 마리", "백설공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "snoring")),
            
            SoundEffect(id: "yawn", nameKo: "하아암 (하품)", nameEn: "Yawn", emoji: "🥱", fileName: "yawn", categoryID: "people_voice",
                relatedTales: ["잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "yawn")),
            
            SoundEffect(id: "evil_laugh", nameKo: "크크크 (악당 웃음)", nameEn: "Evil Laugh", emoji: "😈", fileName: "evil_laugh", categoryID: "people_voice",
                relatedTales: ["백설공주", "헨젤과 그레텔", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "evil_laugh")),
            
            SoundEffect(id: "baby_giggle", nameKo: "까르르 (아기 웃음)", nameEn: "Baby Giggle", emoji: "👶", fileName: "baby_giggle", categoryID: "people_voice",
                relatedTales: ["엄지공주", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "baby_giggle")),
            
            SoundEffect(id: "scream", nameKo: "꺄아! (비명)", nameEn: "Scream", emoji: "😱", fileName: "scream", categoryID: "people_voice",
                relatedTales: ["잭과 콩나무", "헨젤과 그레텔"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "scream")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🏰 성과 궁전 (Castle & Palace)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "castle_gate", nameKo: "끼이이익 (성문 열림)", nameEn: "Castle Gate Open", emoji: "🏰", fileName: "castle_gate", categoryID: "castle_palace",
                relatedTales: ["잠자는 숲속의 미녀", "신데렐라", "미녀와 야수"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "castle_gate")),
            
            SoundEffect(id: "armor_clank", nameKo: "철컹 (갑옷)", nameEn: "Armor Clank", emoji: "🛡️", fileName: "armor_clank", categoryID: "castle_palace",
                relatedTales: ["아서왕", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "armor_clank")),
            
            SoundEffect(id: "royal_fanfare", nameKo: "팡파레", nameEn: "Royal Fanfare", emoji: "👑", fileName: "royal_fanfare", categoryID: "castle_palace",
                relatedTales: ["신데렐라", "잠자는 숲속의 미녀", "벌거벗은 임금님"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "royal_fanfare")),
            
            SoundEffect(id: "throne_sit", nameKo: "왕좌에 앉기", nameEn: "Sitting on Throne", emoji: "🪑", fileName: "throne_sit", categoryID: "castle_palace",
                relatedTales: ["벌거벗은 임금님", "아서왕"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "throne_sit")),
            
            SoundEffect(id: "glass_slipper", nameKo: "딸깍 (유리 구두)", nameEn: "Glass Slipper", emoji: "👠", fileName: "glass_slipper", categoryID: "castle_palace",
                relatedTales: ["신데렐라"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "glass_slipper")),
            
            SoundEffect(id: "ballroom_music", nameKo: "무도회 음악", nameEn: "Ballroom Music", emoji: "💃", fileName: "ballroom_music", categoryID: "castle_palace",
                relatedTales: ["신데렐라", "미녀와 야수", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "ballroom_music")),
            
            SoundEffect(id: "drawbridge", nameKo: "도개교 내리기", nameEn: "Drawbridge", emoji: "🏰", fileName: "drawbridge", categoryID: "castle_palace",
                relatedTales: ["잠자는 숲속의 미녀", "아서왕"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "drawbridge")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: ⏰ 시계와 시간 (Clock & Time)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "clock_tick", nameKo: "째깍째깍 (시계)", nameEn: "Clock Ticking", emoji: "⏰", fileName: "clock_tick", categoryID: "clock_time",
                relatedTales: ["신데렐라", "이상한 나라의 앨리스", "피터팬"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "clock_tick")),
            
            SoundEffect(id: "clock_chime_12", nameKo: "뎅뎅뎅 (12시 종)", nameEn: "Midnight Chime", emoji: "🕛", fileName: "clock_chime_12", categoryID: "clock_time",
                relatedTales: ["신데렐라"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "clock_chime_12")),
            
            SoundEffect(id: "clock_cuckoo", nameKo: "뻐꾸 (뻐꾸기 시계)", nameEn: "Cuckoo Clock", emoji: "🐦", fileName: "clock_cuckoo", categoryID: "clock_time",
                relatedTales: ["피노키오", "이상한 나라의 앨리스"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "clock_cuckoo")),
            
            SoundEffect(id: "hourglass_flip", nameKo: "모래시계 뒤집기", nameEn: "Hourglass Flip", emoji: "⏳", fileName: "hourglass_flip", categoryID: "clock_time",
                relatedTales: ["오즈의 마법사", "알라딘"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "hourglass_flip")),
            
            SoundEffect(id: "alarm_ring", nameKo: "따르르릉 (알람)", nameEn: "Alarm Ring", emoji: "⏰", fileName: "alarm_ring", categoryID: "clock_time",
                relatedTales: ["잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "alarm_ring")),
        ])
        
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // MARK: 🎭 분위기와 배경 (Ambience & Mood)
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        sounds.append(contentsOf: [
            SoundEffect(id: "village_ambience", nameKo: "마을 배경음", nameEn: "Village Ambience", emoji: "🏘️", fileName: "village_ambience", categoryID: "ambience_mood",
                relatedTales: ["빨간모자", "피리 부는 사나이", "브레멘 음악대"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "village_ambience")),
            
            SoundEffect(id: "market_bustle", nameKo: "시장 소리", nameEn: "Market Bustle", emoji: "🏪", fileName: "market_bustle", categoryID: "ambience_mood",
                relatedTales: ["알라딘", "잭과 콩나무"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "market_bustle")),
            
            SoundEffect(id: "garden_peaceful", nameKo: "평화로운 정원", nameEn: "Peaceful Garden", emoji: "🌷", fileName: "garden_peaceful", categoryID: "ambience_mood",
                relatedTales: ["비밀의 정원", "이상한 나라의 앨리스", "엄지공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "garden_peaceful")),
            
            SoundEffect(id: "cave_echo", nameKo: "동굴 울림", nameEn: "Cave Echo", emoji: "🦇", fileName: "cave_echo", categoryID: "ambience_mood",
                relatedTales: ["알리바바와 40인의 도적", "알라딘"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "cave_echo")),
            
            SoundEffect(id: "desert_wind", nameKo: "사막 바람", nameEn: "Desert Wind", emoji: "🏜️", fileName: "desert_wind", categoryID: "ambience_mood",
                relatedTales: ["알라딘", "알리바바와 40인의 도적"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "desert_wind")),
            
            SoundEffect(id: "mountain_wind", nameKo: "산 바람", nameEn: "Mountain Wind", emoji: "🏔️", fileName: "mountain_wind", categoryID: "ambience_mood",
                relatedTales: ["잭과 콩나무", "하이디"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "mountain_wind")),
            
            SoundEffect(id: "sunrise_birds", nameKo: "새벽 새소리", nameEn: "Dawn Birdsong", emoji: "🌅", fileName: "sunrise_birds", categoryID: "ambience_mood",
                relatedTales: ["잠자는 숲속의 미녀", "백설공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "sunrise_birds")),
            
            SoundEffect(id: "magical_forest", nameKo: "마법의 숲", nameEn: "Magical Forest", emoji: "🌳", fileName: "magical_forest", categoryID: "ambience_mood",
                relatedTales: ["이상한 나라의 앨리스", "나니아 연대기", "잠자는 숲속의 미녀"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "magical_forest")),
            
            SoundEffect(id: "underwater_ambience", nameKo: "수중 배경음", nameEn: "Underwater Ambience", emoji: "🐠", fileName: "underwater_ambience", categoryID: "ambience_mood",
                relatedTales: ["인어공주"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "underwater_ambience")),
            
            SoundEffect(id: "happy_ending", nameKo: "해피엔딩 음악", nameEn: "Happy Ending Music", emoji: "🌈", fileName: "happy_ending", categoryID: "ambience_mood",
                relatedTales: ["신데렐라", "백설공주", "잠자는 숲속의 미녀", "미녀와 야수"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "happy_ending")),
            
            SoundEffect(id: "once_upon_time", nameKo: "옛날 옛적에...", nameEn: "Once Upon a Time", emoji: "📖", fileName: "once_upon_time", categoryID: "ambience_mood",
                relatedTales: ["모든 동화"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "once_upon_time")),
            
            SoundEffect(id: "page_turn", nameKo: "책장 넘기기", nameEn: "Page Turn", emoji: "📖", fileName: "page_turn", categoryID: "ambience_mood",
                relatedTales: ["모든 동화"],
                hasAudioFile: SoundEffect.checkAudioExists(fileName: "page_turn")),
        ])
        
        self.allSounds = sounds
        self.soundsByID = Dictionary(sounds.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
    }
    
    /// Get sounds for a specific category
    func sounds(for categoryID: String) -> [SoundEffect] {
        allSounds.filter { $0.categoryID == categoryID }
    }
    
    /// Get sounds related to a specific fairy tale
    func sounds(forTale taleName: String) -> [SoundEffect] {
        allSounds.filter { $0.relatedTales.contains(taleName) }
    }
    
    /// Get all unique fairy tale names
    var allTaleNames: [String] {
        Array(Set(allSounds.flatMap { $0.relatedTales })).sorted()
    }
    
    /// Total sound count
    var totalCount: Int { allSounds.count }
    
    /// Count of sounds missing audio files
    var missingAudioCount: Int { allSounds.filter { !$0.hasAudioFile }.count }
}
