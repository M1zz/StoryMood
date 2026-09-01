#!/usr/bin/env python3
"""
StoryMood 추가 효과음 다운로드 (Mixkit)

Mixkit Free License — 상업적 이용 가능, 출처 표기 불필요.
https://mixkit.co/license/#sfxFree

Freesound(download_sounds.py)와 달리 API 키가 필요 없다.
아래 목록의 Mixkit 에셋 ID를 고정해 두었으므로 언제 실행해도 같은 음원을 받는다.

사용법:  python3 download_sounds_mixkit.py
"""

import os
import time
import urllib.request

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "StoryMood", "Sounds")
URL = "https://assets.mixkit.co/active_storage/sfx/{id}/{id}-preview.mp3"
DELAY = 0.3

# (파일명, Mixkit 에셋 ID, 원제)
SOUNDS = [
    # 🐾 동물
    ("cow_moo",         1747, "Cow single moo"),
    ("sheep_baa",       1741, "Sheep sounds"),
    ("goose_honk",        20, "Flock of wild geese"),
    ("crow_caw",         316, "Crow short crowing"),
    ("monkey_screech",   105, "Monkey excited screech"),
    ("beast_roar",        13, "Aggressive beast roar"),
    ("dragon_roar",       16, "Big dragon in the wild roar"),
    ("rubber_duck",     1014, "Rubber duck squeak"),

    # 🗣️ 사람과 아이
    ("applause",        3035, "Small crowd clapping"),
    ("kid_giggle",       431, "Kid giggle laugh"),
    ("sneeze",          2210, "Cartoon character cute sneeze"),
    ("kiss",            2192, "Little cute kiss"),
    ("fart",            2891, "Cartoon fart sound"),
    ("hiccup",            10, "Little cartoon creature hiccup"),
    ("drink_sip",       1307, "Sip of water"),

    # 🧹 집과 물건
    ("glass_break",      759, "Glass break with hammer thud"),
    ("balloon_pop",     3069, "Game balloon or bubble pop"),
    ("coins_jingle",    1993, "Clinking coins"),
    ("hammer_wood",      830, "Hammer hit on wood"),
    ("hand_saw",         827, "Hand saw tool on wood"),
    ("broom_sweep",     3087, "Long broom or wipe sweep sound"),
    ("scissors_cut",    2378, "Scissors cutting paper"),
    ("paper_crumple",   2996, "Quick paper crumple sound"),
    ("soap_bubble",     2925, "Soap bubble sound"),

    # 🎪 만화 효과
    ("cartoon_boing",   2894, "Boing hit sound"),
    ("cartoon_pop",     2358, "Long pop"),
    ("cartoon_whistle",  616, "Cartoon toy whistle"),

    # 🔔 그 밖에
    ("church_bell",      603, "Church bell calling"),
    ("fireworks",       3103, "Fast whistle firework"),
]


def download(file_name: str, asset_id: int) -> bool:
    dest = os.path.join(OUTPUT_DIR, f"{file_name}.mp3")
    if os.path.exists(dest) and os.path.getsize(dest) > 2000:
        print("  ⏭  이미 있음")
        return True
    req = urllib.request.Request(URL.format(id=asset_id),
                                 headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r, open(dest, "wb") as f:
            f.write(r.read())
    except Exception as e:  # noqa: BLE001
        print(f"  ❌ {e}")
        return False
    size = os.path.getsize(dest)
    if size < 2000:
        os.remove(dest)
        print("  ❌ 파일이 너무 작음")
        return False
    print(f"  ✅ 완료 ({size // 1024}KB)")
    return True


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"🎵 Mixkit 추가 효과음 — 총 {len(SOUNDS)}개")
    print(f"📁 {OUTPUT_DIR}")
    print("=" * 60)

    failed = []
    for i, (file_name, asset_id, title) in enumerate(SOUNDS, 1):
        print(f"[{i:2d}/{len(SOUNDS)}] {file_name}  ({title})")
        if not download(file_name, asset_id):
            failed.append(file_name)
        time.sleep(DELAY)

    print("=" * 60)
    print(f"✅ 성공: {len(SOUNDS) - len(failed)}/{len(SOUNDS)}")
    if failed:
        print("❌ 실패:", ", ".join(failed))


if __name__ == "__main__":
    main()
