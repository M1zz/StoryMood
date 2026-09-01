#!/usr/bin/env python3
from __future__ import annotations
"""
StoryMood 사운드 버튼 배경 이미지 다운로드 (Openverse API)

Openverse는 API 키 없이 검색할 수 있고, license=cc0,pdm 으로 걸러
'퍼블릭 도메인 / 저작자 표시 불필요' 이미지만 받는다.
(Pixabay용 download_images.py는 API 키가 필요해서 이 스크립트를 따로 둔다)

사용법:  python3 download_images_openverse.py
"""

import io
import json
import os
import subprocess
import time
import urllib.parse
import urllib.request

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "StoryMood", "SoundImages")
API = "https://api.openverse.org/v1/images/"
UA = {"User-Agent": "StoryMood/1.0 (fairy tale sound app)"}
SIZE = 300          # 정사각형으로 잘라 저장 (버튼이 원형이라 가운데만 보인다)
DELAY = 0.4

# (파일명, 검색어 후보들)
IMAGES = [
    ("cow_moo",         ["cow", "cow farm"]),
    ("sheep_baa",       ["sheep", "sheep farm"]),
    ("goose_honk",      ["goose", "geese"]),
    ("crow_caw",        ["crow bird", "raven"]),
    ("monkey_screech",  ["monkey", "monkey face"]),
    ("beast_roar",      ["tiger", "tiger face"]),
    ("dragon_roar",     ["dragon statue", "dragon"]),
    ("rubber_duck",     ["rubber duck", "toy duck"]),
    ("applause",        ["applause", "clapping hands"]),
    ("kid_giggle",      ["children laughing", "happy children"]),
    ("sneeze",          ["sneeze", "tissue nose"]),
    ("kiss",            ["kiss", "lips"]),
    ("fart",            ["whoopee cushion", "cartoon cloud"]),
    ("hiccup",          ["surprised child", "open mouth"]),
    ("drink_sip",       ["glass of water", "drinking water"]),
    ("glass_break",     ["broken glass", "shattered glass"]),
    ("balloon_pop",     ["balloon", "party balloons"]),
    ("coins_jingle",    ["gold coins", "coins"]),
    ("hammer_wood",     ["hammer", "hammer nail"]),
    ("hand_saw",        ["hand saw", "saw tool"]),
    ("broom_sweep",     ["broom", "sweeping broom"]),
    ("scissors_cut",    ["scissors", "scissors paper"]),
    ("paper_crumple",   ["crumpled paper", "paper ball"]),
    ("soap_bubble",     ["soap bubbles", "bubbles"]),
    ("cartoon_boing",   ["spring coil", "metal spring"]),
    ("cartoon_pop",     ["bubble", "soap bubble"]),
    ("cartoon_whistle", ["whistle", "toy whistle"]),
    ("church_bell",     ["church bell", "bell tower"]),
    ("fireworks",       ["fireworks", "firework night"]),
]


def search(query: str):
    url = API + "?" + urllib.parse.urlencode({
        "q": query, "license": "cc0,pdm", "page_size": 8,
        "mature": "false", "extension": "jpg",
    })
    try:
        with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=30) as r:
            return json.load(r).get("results", [])
    except Exception as e:  # noqa: BLE001
        print(f"  ⚠️  검색 실패: {e}")
        return []


def fetch(url: str):
    try:
        with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=40) as r:
            return r.read()
    except Exception:  # noqa: BLE001
        return None


def save_square(data: bytes, dest: str) -> bool:
    tmp = dest + ".tmp"
    with open(tmp, "wb") as f:
        f.write(data)
    # sips: 짧은 변을 SIZE에 맞춘 뒤 가운데를 정사각형으로 자른다
    ok = subprocess.run(["sips", "-Z", str(SIZE * 2), tmp], capture_output=True).returncode == 0
    ok = ok and subprocess.run(["sips", "-c", str(SIZE), str(SIZE), tmp],
                               capture_output=True).returncode == 0
    ok = ok and subprocess.run(["sips", "-s", "format", "jpeg", "-s", "formatOptions", "70",
                                tmp, "--out", dest], capture_output=True).returncode == 0
    os.path.exists(tmp) and os.remove(tmp)
    return ok and os.path.exists(dest) and os.path.getsize(dest) > 2000


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"🖼  Openverse 이미지 — 총 {len(IMAGES)}개\n📁 {OUTPUT_DIR}\n" + "=" * 60)
    failed = []
    for i, (name, queries) in enumerate(IMAGES, 1):
        dest = os.path.join(OUTPUT_DIR, f"{name}.jpg")
        print(f"[{i:2d}/{len(IMAGES)}] {name}")
        if os.path.exists(dest) and os.path.getsize(dest) > 2000:
            print("  ⏭  이미 있음")
            continue
        done = False
        for q in queries:
            for hit in search(q):
                url = hit.get("url") or ""
                if not url.lower().split("?")[0].endswith((".jpg", ".jpeg")):
                    continue
                data = fetch(url)
                if not data or len(data) < 5000:
                    continue
                if save_square(data, dest):
                    print(f"  ✅ [{hit.get('license')}] {hit.get('title', '')[:40]}")
                    done = True
                    break
            if done:
                break
            time.sleep(DELAY)
        if not done:
            failed.append(name)
            print("  ❌ 실패")
        time.sleep(DELAY)

    print("=" * 60)
    print(f"✅ 성공: {len(IMAGES) - len(failed)}/{len(IMAGES)}")
    if failed:
        print("❌ 실패(이모지로 표시됨):", ", ".join(failed))


if __name__ == "__main__":
    main()
