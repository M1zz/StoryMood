#!/usr/bin/env python3
"""
StoryMood 사운드 버튼 배경 이미지 다운로드 (Pixabay Image API)
"""

import os
import time
import json
import urllib.request
import urllib.parse

PIXABAY_KEY = os.environ.get("PIXABAY_API_KEY", "YOUR_PIXABAY_KEY")
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "StoryMood", "SoundImages")
DELAY = 0.3

# (파일명, 검색키워드)
SOUNDS = [
    ("door_knock",        "door knocking wood"),
    ("door_creak",        "old creaky door"),
    ("door_slam",         "door slamming"),
    ("lock_unlock",       "padlock key"),
    ("key_jingle",        "keys keychain"),
    ("window_open",       "window opening"),
    ("floor_creak",       "wooden floor"),
    ("chimney_sweep",     "chimney fireplace"),
    ("house_collapse",    "house ruins"),
    ("curtain_swoosh",    "curtain fabric"),
    ("wind_blow",         "wind nature"),
    ("wind_howl",         "storm wind"),
    ("rain_light",        "rain drizzle"),
    ("rain_heavy",        "heavy rain storm"),
    ("thunder",           "lightning thunder"),
    ("leaves_rustle",     "autumn leaves"),
    ("tree_branch_snap",  "tree branch forest"),
    ("snow_crunch",       "snow winter footprint"),
    ("forest_ambience",   "forest woods"),
    ("earthquake_rumble", "earthquake crack"),
    ("wolf_howl",         "wolf howling"),
    ("wolf_growl",        "wolf close up"),
    ("bird_singing",      "singing bird"),
    ("rooster_crow",      "rooster farm"),
    ("frog_croak",        "frog pond"),
    ("bear_growl",        "bear wildlife"),
    ("horse_neigh",       "horse meadow"),
    ("cat_meow",          "cat cute"),
    ("dog_bark",          "dog bark"),
    ("donkey_bray",       "donkey animal"),
    ("mouse_squeak",      "mouse cute"),
    ("snake_hiss",        "snake reptile"),
    ("lion_roar",         "lion roar"),
    ("pig_oink",          "pig farm"),
    ("duck_quack",        "duck pond"),
    ("cricket_chirp",     "cricket insect night"),
    ("bee_buzz",          "bee flower"),
    ("ocean_waves",       "ocean waves beach"),
    ("water_splash",      "water splash"),
    ("water_drip",        "water drop"),
    ("stream_flow",       "stream creek water"),
    ("underwater_bubble", "underwater bubbles"),
    ("seagull_cry",       "seagull ocean"),
    ("whale_song",        "whale ocean"),
    ("waterfall",         "waterfall nature"),
    ("magic_sparkle",     "magic sparkle glitter"),
    ("magic_wand",        "magic wand stars"),
    ("magic_transform",   "magic transformation"),
    ("magic_poof",        "magic smoke poof"),
    ("fairy_wings",       "fairy wings"),
    ("magic_potion",      "magic potion bottle"),
    ("magic_chime",       "magic bell chime"),
    ("magic_whoosh",      "magic energy glow"),
    ("spell_cast",        "wizard spell magic"),
    ("mirror_magic",      "magic mirror"),
    ("genie_appear",      "genie lamp magic"),
    ("footstep_walk",     "footstep path walking"),
    ("footstep_run",      "running track"),
    ("footstep_tiptoe",   "tiptoe sneaking"),
    ("giant_footstep",    "giant footprint"),
    ("climbing",          "climbing rope"),
    ("jumping",           "jumping leap"),
    ("falling",           "falling sky"),
    ("sliding",           "sliding ice"),
    ("fire_crackle",      "campfire flames"),
    ("pot_boiling",       "pot boiling kitchen"),
    ("oven_door",         "oven kitchen"),
    ("chopping",          "chopping vegetables knife"),
    ("eating_crunching",  "eating food apple"),
    ("pouring_liquid",    "pouring tea cup"),
    ("match_strike",      "match fire light"),
    ("candle_blow",       "candle flame"),
    ("harp_strum",        "harp instrument music"),
    ("music_box",         "music box vintage"),
    ("flute_play",        "flute instrument"),
    ("drum_beat",         "drum percussion"),
    ("trumpet_fanfare",   "trumpet fanfare"),
    ("bell_ring",         "church bell tower"),
    ("singing_voice",     "singer voice"),
    ("lullaby",           "baby sleeping cradle"),
    ("spinning_wheel",    "spinning wheel thread"),
    ("owl_hoot",          "owl night"),
    ("ghost_moan",        "ghost spooky"),
    ("witch_cackle",      "witch halloween"),
    ("bat_flutter",       "bat cave"),
    ("night_ambience",    "night sky stars"),
    ("creepy_music",      "dark forest fog"),
    ("wolf_howl_night",   "wolf moon night"),
    ("chains_rattle",     "chains metal"),
    ("sword_clash",       "sword fight"),
    ("sword_draw",        "sword knight"),
    ("arrow_shoot",       "archer arrow bow"),
    ("treasure_open",     "treasure chest gold"),
    ("rope_swing",        "rope swing"),
    ("shield_block",      "shield medieval"),
    ("explosion",         "explosion fire"),
    ("map_unroll",        "old map parchment"),
    ("horse_gallop",      "horse gallop running"),
    ("carriage_ride",     "horse carriage vintage"),
    ("boat_rowing",       "rowing boat lake"),
    ("ship_creak",        "wooden sailing ship"),
    ("flying_carpet",     "flying carpet magic"),
    ("broomstick_fly",    "witch broomstick"),
    ("sled_sliding",      "sled snow winter"),
    ("laughing",          "laughing happy child"),
    ("crying",            "crying sad"),
    ("gasp_surprise",     "surprise shocked"),
    ("whisper",           "whisper secret"),
    ("cheer_crowd",       "crowd cheering"),
    ("snoring",           "sleeping bed"),
    ("yawn",              "yawning tired"),
    ("evil_laugh",        "villain evil"),
    ("baby_giggle",       "baby laughing cute"),
    ("scream",            "scream scared"),
    ("castle_gate",       "castle gate medieval"),
    ("armor_clank",       "knight armor medieval"),
    ("royal_fanfare",     "royal throne king"),
    ("throne_sit",        "throne room castle"),
    ("glass_slipper",     "glass slipper shoe"),
    ("ballroom_music",    "ballroom dance elegant"),
    ("drawbridge",        "drawbridge castle moat"),
    ("clock_tick",        "clock vintage tick"),
    ("clock_chime_12",    "grandfather clock"),
    ("clock_cuckoo",      "cuckoo clock wooden"),
    ("hourglass_flip",    "hourglass sand timer"),
    ("alarm_ring",        "alarm clock morning"),
    ("village_ambience",  "medieval village"),
    ("market_bustle",     "market bazaar"),
    ("garden_peaceful",   "garden flowers peaceful"),
    ("cave_echo",         "dark cave"),
    ("desert_wind",       "desert sand dunes"),
    ("mountain_wind",     "mountain peak"),
    ("sunrise_birds",     "sunrise morning birds"),
    ("magical_forest",    "enchanted forest magical"),
    ("underwater_ambience","underwater ocean deep"),
    ("happy_ending",      "sunset happy"),
    ("once_upon_time",    "fairy tale storybook"),
    ("page_turn",         "open book reading"),
]


def search_pixabay(query: str) -> str | None:
    params = urllib.parse.urlencode({
        "key": PIXABAY_KEY,
        "q": query,
        "image_type": "photo",
        "per_page": 3,
        "safesearch": "true",
        "min_width": 300,
    })
    url = f"https://pixabay.com/api/?{params}"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "StoryMoodApp/1.0"})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read())
            hits = data.get("hits", [])
            if hits:
                return hits[0].get("previewURL") or hits[0].get("webformatURL")
    except Exception as e:
        print(f"  오류: {e}")
    return None


def download_image(url: str, dest: str) -> bool:
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "StoryMoodApp/1.0"})
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = resp.read()
        # JPEG or PNG만 허용
        if data[:2] != b'\xff\xd8' and data[:4] != b'\x89PNG':
            return False
        with open(dest, "wb") as f:
            f.write(data)
        return True
    except Exception as e:
        print(f"  다운로드 오류: {e}")
        return False


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    total = len(SOUNDS)
    success = 0

    print(f"🖼️  사운드 배경 이미지 다운로드 — 총 {total}개")
    print(f"📁 {OUTPUT_DIR}")
    print("=" * 60)

    for i, (name, query) in enumerate(SOUNDS, 1):
        dest = os.path.join(OUTPUT_DIR, f"{name}.jpg")
        if os.path.exists(dest) and os.path.getsize(dest) > 500:
            print(f"[{i:3d}/{total}] ✅ 이미 있음: {name}")
            success += 1
            continue

        print(f"[{i:3d}/{total}] {name} ← \"{query}\"")
        time.sleep(DELAY)

        img_url = search_pixabay(query)
        if img_url and download_image(img_url, dest):
            size = os.path.getsize(dest)
            print(f"         ✅ {size // 1024}KB")
            success += 1
        else:
            print(f"         ❌ 실패")

    print(f"\n✅ {success}/{total} 완료")


if __name__ == "__main__":
    main()
