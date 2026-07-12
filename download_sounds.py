#!/usr/bin/env python3
"""
StoryMood 음원 자동 다운로드 스크립트 (Freesound.org API 사용)

사용법:
  1. https://freesound.org/apiv2/apply/ 에서 무료 API 키 발급
     (계정 생성 → API application 등록 → Client secret 복사)
  2. 환경변수로 설정: export FREESOUND_API_TOKEN="발급받은 토큰"
  3. python3 download_sounds.py 실행
"""

import os
import time
import json
import urllib.request
import urllib.parse

# ─────────────────────────────────────────────────────────────────
# ▶ Freesound.org API 토큰 입력 (https://freesound.org/apiv2/apply/)
API_TOKEN = os.environ.get("FREESOUND_API_TOKEN", "YOUR_FREESOUND_TOKEN")
# ─────────────────────────────────────────────────────────────────

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "StoryMood", "Sounds")
DELAY_SECONDS = 0.3

SOUNDS = [
    # 🚪 문과 집
    ("door_knock",       "똑똑똑 문 두드리기",   ["door knock", "knocking door"]),
    ("door_creak",       "끼이익 문 열림",        ["door creak", "creaky door"]),
    ("door_slam",        "쾅 문 닫힘",            ["door slam", "door close"]),
    ("lock_unlock",      "찰칵 자물쇠",           ["lock unlock", "door lock click"]),
    ("key_jingle",       "딸랑 열쇠",             ["key jingle", "keys rattle"]),
    ("window_open",      "창문 열기",             ["window open", "window slide"]),
    ("floor_creak",      "삐걱 바닥",             ["floor creak", "wooden floor creak"]),
    ("chimney_sweep",    "굴뚝 소리",             ["chimney wind", "fireplace draft"]),
    ("house_collapse",   "우당탕 집 무너짐",      ["building collapse", "debris falling"]),
    ("curtain_swoosh",   "스윽 커튼",             ["curtain swoosh", "fabric swoosh"]),

    # 🌿 자연과 날씨
    ("wind_blow",        "휘이잉 바람",           ["wind blowing", "gentle breeze"]),
    ("wind_howl",        "우우웅 강풍",           ["wind howling", "storm wind"]),
    ("rain_light",       "소슬소슬 이슬비",       ["light rain", "gentle rain drizzle"]),
    ("rain_heavy",       "콸콸 폭우",             ["heavy rain", "rain storm"]),
    ("thunder",          "쿠르르쾅 천둥",         ["thunder", "thunder rumble"]),
    ("leaves_rustle",    "사각사각 나뭇잎",       ["leaves rustling", "leaf rustle wind"]),
    ("tree_branch_snap", "뚝 나뭇가지",           ["branch snap", "twig break"]),
    ("snow_crunch",      "뽀드득 눈밟기",         ["snow crunch", "walking snow footstep"]),
    ("forest_ambience",  "숲속 배경음",           ["forest ambience", "woodland birds"]),
    ("earthquake_rumble","우르르 지진",           ["earthquake rumble", "ground shake"]),

    # 🐾 동물
    ("wolf_howl",        "아우우 늑대 울음",      ["wolf howl", "wolf howling"]),
    ("wolf_growl",       "그르르 늑대 으르렁",    ["wolf growl", "wolf snarl"]),
    ("bird_singing",     "짹짹 새 노래",          ["bird singing", "birds chirping"]),
    ("rooster_crow",     "꼬끼오 수탉",           ["rooster crow", "rooster crowing"]),
    ("frog_croak",       "개굴개굴 개구리",       ["frog croak", "frog ribbit"]),
    ("bear_growl",       "으르렁 곰",             ["bear growl", "bear roar"]),
    ("horse_neigh",      "히이잉 말 울음",        ["horse neigh", "horse whinny"]),
    ("cat_meow",         "야옹 고양이",           ["cat meow", "kitten meow"]),
    ("dog_bark",         "멍멍 개",               ["dog bark", "dog barking"]),
    ("donkey_bray",      "히이하 당나귀",         ["donkey bray", "donkey sound"]),
    ("mouse_squeak",     "찍찍 쥐",              ["mouse squeak", "rat squeak"]),
    ("snake_hiss",       "쉬이이 뱀",            ["snake hiss", "hissing snake"]),
    ("lion_roar",        "어흥 사자",             ["lion roar", "lion growl"]),
    ("pig_oink",         "꿀꿀 돼지",            ["pig oink", "pig squeal"]),
    ("duck_quack",       "꽥꽥 오리",            ["duck quack", "duck sound"]),
    ("cricket_chirp",    "귀뚜르 귀뚜라미",      ["cricket chirp", "crickets night"]),
    ("bee_buzz",         "윙윙 벌",              ["bee buzz", "bee buzzing"]),

    # 🌊 바다와 물
    ("ocean_waves",      "파도 소리",            ["ocean waves", "waves crashing beach"]),
    ("water_splash",     "첨벙 물 튀김",         ["water splash", "splash sound"]),
    ("water_drip",       "똑똑 물방울",          ["water drip", "water drop dripping"]),
    ("stream_flow",      "졸졸 시냇물",          ["stream flow", "babbling brook creek"]),
    ("underwater_bubble","보글보글 수중 거품",   ["underwater bubbles", "bubbling water"]),
    ("seagull_cry",      "끼룩 갈매기",          ["seagull cry", "seagull sound"]),
    ("whale_song",       "고래 노래",            ["whale song", "whale call"]),
    ("waterfall",        "콸콸 폭포",            ["waterfall sound"]),

    # ✨ 마법과 판타지
    ("magic_sparkle",    "반짝 마법 반짝임",     ["magic sparkle", "fairy dust twinkle"]),
    ("magic_wand",       "슈웅 마법 지팡이",     ["magic wand", "spell cast wand"]),
    ("magic_transform",  "변신 마법 변신",       ["magic transform", "transformation sound"]),
    ("magic_poof",       "펑 마법 연기",         ["magic poof", "disappear appear"]),
    ("fairy_wings",      "파르르 요정 날개",     ["fairy wings flutter", "wing flutter"]),
    ("magic_potion",     "보글보글 마법 물약",   ["magic potion", "potion bubble cauldron"]),
    ("magic_chime",      "띵 마법 종소리",       ["magic chime", "magical bell fairy"]),
    ("magic_whoosh",     "휘이잉 마법 바람",     ["magic whoosh", "spell whoosh"]),
    ("spell_cast",       "주문 외우기",          ["spell casting", "magic spell enchantment"]),
    ("mirror_magic",     "거울아 거울아",        ["magic mirror shimmer", "glass shimmer"]),
    ("genie_appear",     "지니 등장",            ["genie appear", "magical appearance"]),

    # 👣 발자국과 움직임
    ("footstep_walk",    "뚜벅뚜벅 걷기",       ["footsteps walking", "walking footstep"]),
    ("footstep_run",     "다다다 달리기",        ["footsteps running", "running fast footstep"]),
    ("footstep_tiptoe",  "사뿐사뿐 살금살금",   ["tiptoeing", "sneaking quiet footstep"]),
    ("giant_footstep",   "쿵쿵쿵 거인 발자국",  ["giant footstep", "heavy stomp"]),
    ("climbing",         "영차영차 오르기",      ["climbing rope", "ladder climb"]),
    ("jumping",          "폴짝 점프",            ["jump sound", "hop jump"]),
    ("falling",          "으아아 떨어지기",      ["falling sound", "fall down"]),
    ("sliding",          "미끄르르 미끄러지기",  ["sliding", "slip slide sound"]),

    # 🔥 불과 부엌
    ("fire_crackle",     "타닥타닥 모닥불",      ["fire crackling", "campfire crackle"]),
    ("pot_boiling",      "보글보글 냄비 끓기",   ["pot boiling", "water boiling bubbles"]),
    ("oven_door",        "끼이익 오븐 문",       ["oven door", "oven open"]),
    ("chopping",         "똑똑똑 칼질",          ["chopping vegetables", "knife chop"]),
    ("eating_crunching", "아삭아삭 먹기",        ["eating crunching", "food crunch bite"]),
    ("pouring_liquid",   "쏴아 따르기",          ["pouring liquid", "water pour"]),
    ("match_strike",     "치익 성냥",            ["match strike", "match light"]),
    ("candle_blow",      "후 촛불 끄기",         ["candle blow out", "blowing candle"]),

    # 🎵 음악과 악기
    ("harp_strum",       "딩딩 하프",            ["harp strum", "harp glissando"]),
    ("music_box",        "오르골",               ["music box", "music box melody"]),
    ("flute_play",       "피리 연주",            ["flute melody", "pan flute"]),
    ("drum_beat",        "둥둥 북",              ["drum beat", "timpani drum"]),
    ("trumpet_fanfare",  "빠빠빠 나팔",          ["trumpet fanfare", "horn fanfare"]),
    ("bell_ring",        "땡땡 종",              ["bell ring", "church bell toll"]),
    ("singing_voice",    "라라라 노래",          ["female humming", "vocal melody hum"]),
    ("lullaby",          "자장가 멜로디",        ["lullaby music", "sleep melody"]),
    ("spinning_wheel",   "물레 돌아가는 소리",   ["spinning wheel", "wheel spinning"]),

    # 🌙 으스스한 밤
    ("owl_hoot",         "부엉부엉 부엉이",      ["owl hoot", "owl sound"]),
    ("ghost_moan",       "으으으 유령",          ["ghost moan", "spooky ghost sound"]),
    ("witch_cackle",     "캬캬캬 마녀 웃음",     ["witch cackle", "witch laugh evil"]),
    ("bat_flutter",      "퍼덕퍼덕 박쥐",       ["bat wings flutter", "bat flying"]),
    ("night_ambience",   "고요한 밤",            ["night ambience", "quiet night crickets"]),
    ("creepy_music",     "으스스한 배경음",      ["creepy ambience", "spooky horror sound"]),
    ("wolf_howl_night",  "밤의 늑대 울음",       ["wolf howl night", "distant wolf howl"]),
    ("chains_rattle",    "쩔컹쩔컹 쇠사슬",     ["chains rattle", "rattling chains"]),

    # ⚔️ 모험과 액션
    ("sword_clash",      "챙 칼 부딪힘",         ["sword clash", "swords clashing metal"]),
    ("sword_draw",       "슈잉 칼 뽑기",         ["sword draw", "unsheathe sword"]),
    ("arrow_shoot",      "휘잉 화살",            ["arrow shoot", "bow arrow fly"]),
    ("treasure_open",    "보물 상자 열기",       ["treasure chest open", "chest open"]),
    ("rope_swing",       "로프 스윙",            ["rope swing whoosh", "rope whoosh"]),
    ("shield_block",     "탕 방패 막기",         ["shield block", "metal shield impact"]),
    ("explosion",        "펑 폭발",              ["explosion", "boom blast"]),
    ("map_unroll",       "바스락 지도 펼치기",   ["paper unroll", "parchment scroll"]),

    # 🐴 이동수단
    ("horse_gallop",     "따그닥 말 달리기",     ["horse gallop", "horse hooves galloping"]),
    ("carriage_ride",    "덜커덩 마차",          ["horse carriage", "wagon ride"]),
    ("boat_rowing",      "첨벙첨벙 노 젓기",     ["boat rowing", "oar rowing water"]),
    ("ship_creak",       "삐걱 배 흔들림",       ["ship creak", "wooden ship creak"]),
    ("flying_carpet",    "부웅 마법 양탄자",     ["whoosh fly", "flying magical"]),
    ("broomstick_fly",   "쌩 빗자루 비행",       ["swoosh fly fast", "fast whoosh"]),
    ("sled_sliding",     "스윽스윽 썰매",        ["sled snow sliding", "sleigh snow"]),

    # 👶 사람과 목소리
    ("laughing",         "하하하 웃음",          ["laughing", "happy laugh"]),
    ("crying",           "흑흑 울음",            ["crying", "sobbing cry"]),
    ("gasp_surprise",    "헐 놀람",              ["gasp surprise", "shocked gasp"]),
    ("whisper",          "쉿 속삭임",            ["whisper", "whispering shh"]),
    ("cheer_crowd",      "와아 환호",            ["crowd cheer", "crowd cheering applause"]),
    ("snoring",          "드르렁 코골이",        ["snoring", "snore sound"]),
    ("yawn",             "하아암 하품",          ["yawn", "yawning"]),
    ("evil_laugh",       "크크크 악당 웃음",     ["evil laugh", "villain sinister laugh"]),
    ("baby_giggle",      "까르르 아기 웃음",     ["baby giggle", "baby laugh infant"]),
    ("scream",           "꺄아 비명",            ["scream", "short scream yell"]),

    # 🏰 성과 궁전
    ("castle_gate",      "끼이이익 성문 열림",   ["castle gate", "heavy iron gate open"]),
    ("armor_clank",      "철컹 갑옷",            ["armor clank", "knight armor"]),
    ("royal_fanfare",    "팡파레",               ["royal fanfare", "king trumpet fanfare"]),
    ("throne_sit",       "왕좌에 앉기",          ["sit down chair", "throne sit"]),
    ("glass_slipper",    "딸깍 유리 구두",       ["glass clink", "crystal glass tap"]),
    ("ballroom_music",   "무도회 음악",          ["ballroom waltz", "waltz music dance"]),
    ("drawbridge",       "도개교 내리기",        ["drawbridge lower", "castle bridge"]),

    # ⏰ 시계와 시간
    ("clock_tick",       "째깍째깍 시계",        ["clock ticking", "tick tock clock"]),
    ("clock_chime_12",   "뎅뎅뎅 12시 종",       ["clock chime", "grandfather clock twelve"]),
    ("clock_cuckoo",     "뻐꾸 뻐꾸기 시계",     ["cuckoo clock", "cuckoo sound"]),
    ("hourglass_flip",   "모래시계 뒤집기",      ["sand pouring", "hourglass sand timer"]),
    ("alarm_ring",       "따르르릉 알람",        ["alarm clock ring", "alarm bell"]),

    # 🎭 분위기와 배경
    ("village_ambience", "마을 배경음",          ["village ambience", "medieval village town"]),
    ("market_bustle",    "시장 소리",            ["market bustle", "marketplace bazaar"]),
    ("garden_peaceful",  "평화로운 정원",        ["peaceful garden", "garden birds nature"]),
    ("cave_echo",        "동굴 울림",            ["cave echo", "cave ambience drip"]),
    ("desert_wind",      "사막 바람",            ["desert wind", "sand wind ambience"]),
    ("mountain_wind",    "산 바람",              ["mountain wind", "high wind ambience"]),
    ("sunrise_birds",    "새벽 새소리",          ["dawn chorus", "morning birds sunrise"]),
    ("magical_forest",   "마법의 숲",            ["magical forest", "enchanted forest"]),
    ("underwater_ambience","수중 배경음",        ["underwater ambience", "deep sea"]),
    ("happy_ending",     "해피엔딩 음악",        ["triumphant music", "fairy tale ending"]),
    ("once_upon_time",   "옛날 옛적에",          ["storybook intro", "once upon a time"]),
    ("page_turn",        "책장 넘기기",          ["page turn", "book page flip"]),
]


def search_freesound(query: str) -> list:
    params = urllib.parse.urlencode({
        "token": API_TOKEN,
        "query": query,
        "fields": "id,name,previews,license",
        "filter": "type:mp3 OR type:wav OR type:ogg",
        "sort": "score",
        "page_size": 5,
        "format": "json",
    })
    url = f"https://freesound.org/apiv2/search/text/?{params}"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "StoryMoodApp/1.0"})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read())
            return data.get("results", [])
    except Exception as e:
        print(f"  검색 오류 ({query}): {e}")
        return []


def download_file(url: str, dest_path: str) -> bool:
    try:
        # Freesound preview URLs need token appended
        if "freesound.org" in url and "token" not in url:
            url += f"?token={API_TOKEN}"
        req = urllib.request.Request(url, headers={"User-Agent": "StoryMoodApp/1.0"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = resp.read()
        # 실제 오디오인지 확인 (JPEG/PNG가 아닌지)
        if data[:4] in (b'\xff\xd8\xff\xe0', b'\x89PNG', b'\xff\xd8\xff\xe1'):
            return False
        with open(dest_path, "wb") as f:
            f.write(data)
        return True
    except Exception as e:
        print(f"  다운로드 오류: {e}")
        return False


def get_audio_url(hit: dict) -> str | None:
    previews = hit.get("previews", {})
    return (previews.get("preview-hq-mp3")
            or previews.get("preview-lq-mp3")
            or previews.get("preview-hq-ogg")
            or previews.get("preview-lq-ogg"))


def process_sound(file_name: str, korean_name: str, keywords: list) -> bool:
    dest_path = os.path.join(OUTPUT_DIR, f"{file_name}.mp3")

    if os.path.exists(dest_path) and os.path.getsize(dest_path) > 2000:
        print(f"  ✅ 이미 있음 ({os.path.getsize(dest_path) // 1024}KB)")
        return True

    for keyword in keywords:
        time.sleep(DELAY_SECONDS)
        hits = search_freesound(keyword)

        for hit in hits:
            audio_url = get_audio_url(hit)
            if not audio_url:
                continue

            print(f"  ⬇️  [{hit.get('license', '?')}] {hit.get('name', '')[:40]}")
            if download_file(audio_url, dest_path):
                size = os.path.getsize(dest_path)
                if size > 2000:
                    print(f"  ✅ 완료 ({size // 1024}KB)")
                    return True
                else:
                    os.remove(dest_path)

    return False


def main():
    if API_TOKEN == "YOUR_FREESOUND_TOKEN":
        print("=" * 60)
        print("❗ Freesound API 토큰을 설정해주세요!")
        print()
        print("1. https://freesound.org/home/register/ 무료 가입")
        print("2. https://freesound.org/apiv2/apply/   API 신청")
        print("3. Client secret을 이 파일의 API_TOKEN에 입력")
        print("=" * 60)
        return

    os.makedirs(OUTPUT_DIR, exist_ok=True)

    total = len(SOUNDS)
    success = 0
    failed = []

    print(f"🎵 StoryMood 음원 다운로드 (Freesound.org) — 총 {total}개")
    print(f"📁 {OUTPUT_DIR}")
    print("=" * 60)

    for i, (file_name, korean_name, keywords) in enumerate(SOUNDS, 1):
        print(f"\n[{i:3d}/{total}] {korean_name}")
        if process_sound(file_name, korean_name, keywords):
            success += 1
        else:
            print(f"  ❌ 실패")
            failed.append((file_name, korean_name))

    print("\n" + "=" * 60)
    print(f"✅ 성공: {success}/{total}")
    if failed:
        print(f"❌ 실패 목록:")
        for fn, kn in failed:
            print(f"   {fn}.mp3  ({kn})")
        print("\n수동 소싱: https://freesound.org (CC0 필터)")
        print("           https://mixkit.co/free-sound-effects/")


if __name__ == "__main__":
    main()
