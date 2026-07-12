#!/usr/bin/env python3
"""
StoryMood BGM 다운로드 스크립트 (Freesound.org API 사용)
각 무드에 맞는 배경음악 트랙 다운로드
"""

import os
import time
import json
import urllib.request
import urllib.parse

API_TOKEN = os.environ.get("FREESOUND_API_TOKEN", "YOUR_FREESOUND_TOKEN")
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "StoryMood", "Sounds")
DELAY_SECONDS = 0.5

# 각 무드 BGM 파일명 → 검색어 목록 (앞에서부터 순서대로 시도)
BGM_TRACKS = [
    (
        "village_ambience",   # 🌟 밝은 모험
        "bright_adventure",
        [
            "adventure orchestral music loop",
            "upbeat adventure background music",
            "heroic adventure theme music",
            "cheerful orchestral adventure",
            "fantasy adventure music loop",
        ]
    ),
    (
        "creepy_music",       # 🌑 음산한 공포
        "dark_spooky",
        [
            "dark horror background music loop",
            "spooky horror ambient music",
            "creepy dark orchestral music",
            "horror suspense music loop",
            "eerie dark music background",
        ]
    ),
    (
        "magical_forest",     # ✨ 신비한 마법
        "magic_mystical",
        [
            "magical fantasy music loop",
            "enchanted fantasy orchestral",
            "fairy tale magical background music",
            "mystical fantasy music harp",
            "whimsical magical music loop",
        ]
    ),
    (
        "garden_peaceful",    # 🏡 포근한 일상
        "cozy_warm",
        [
            "peaceful cozy background music loop",
            "warm acoustic guitar background",
            "soft piano cozy music",
            "gentle warm background music",
            "relaxing peaceful music loop",
        ]
    ),
    (
        "ballroom_music",     # 👑 웅장한 왕국
        "grand_kingdom",
        [
            "royal orchestral music loop",
            "grand kingdom orchestral theme",
            "majestic royal fanfare music",
            "epic orchestral royal background",
            "classical royal court music",
        ]
    ),
    (
        "forest_ambience",    # 🌿 자연과 동물
        "nature_wild",
        [
            "nature forest music loop",
            "peaceful nature background music",
            "forest ambient music flute",
            "wild nature orchestral music",
            "nature inspired music loop",
        ]
    ),
]


def search_freesound(query, min_duration=30):
    """Freesound에서 음악 트랙 검색, preview URL 반환"""
    params = urllib.parse.urlencode({
        "query": query,
        "token": API_TOKEN,
        "fields": "id,name,duration,previews,tags",
        "filter": f"duration:[{min_duration} TO 300] tag:music",
        "sort": "rating_desc",
        "page_size": 10,
    })
    url = f"https://freesound.org/apiv2/search/text/?{params}"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "StoryMoodApp/1.0"})
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read())
            return data.get("results", [])
    except Exception as e:
        print(f"  검색 오류: {e}")
        return []


def download_file(url, dest_path):
    """파일 다운로드 및 MP3 유효성 검증"""
    try:
        req = urllib.request.Request(url, headers={
            "User-Agent": "StoryMoodApp/1.0",
            "Authorization": f"Token {API_TOKEN}",
        })
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = resp.read()

        # MPEG 헤더 검증 (ID3 태그 또는 MPEG sync byte)
        if data[:3] == b'ID3' or (len(data) > 1 and data[0] == 0xFF and (data[1] & 0xE0) == 0xE0):
            with open(dest_path, "wb") as f:
                f.write(data)
            return len(data)
        else:
            print(f"  유효하지 않은 오디오 파일 (헤더: {data[:4].hex()})")
            return 0
    except Exception as e:
        print(f"  다운로드 오류: {e}")
        return 0


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"출력 폴더: {OUTPUT_DIR}\n")

    success = 0
    for file_name, mood_name, queries in BGM_TRACKS:
        dest = os.path.join(OUTPUT_DIR, f"{file_name}.mp3")

        # 이미 존재하면 건너뜀
        if os.path.exists(dest) and os.path.getsize(dest) > 50_000:
            print(f"[SKIP] {file_name}.mp3 (이미 존재)")
            success += 1
            continue

        print(f"[{mood_name}] {file_name} 검색 중...")
        downloaded = False

        for query in queries:
            print(f"  쿼리: \"{query}\"")
            results = search_freesound(query, min_duration=30)

            for r in results:
                preview_url = r.get("previews", {}).get("preview-hq-mp3")
                if not preview_url:
                    continue

                duration = r.get("duration", 0)
                name = r.get("name", "")
                print(f"  후보: {name} ({duration:.0f}초)")

                size = download_file(preview_url, dest)
                if size > 50_000:
                    print(f"  ✅ 저장 완료 ({size/1024:.0f} KB): {file_name}.mp3")
                    success += 1
                    downloaded = True
                    break

                time.sleep(DELAY_SECONDS)

            if downloaded:
                break

            time.sleep(DELAY_SECONDS)

        if not downloaded:
            print(f"  ❌ 실패: {file_name}")

        time.sleep(DELAY_SECONDS)

    print(f"\n완료: {success}/{len(BGM_TRACKS)} BGM 트랙 다운로드")


if __name__ == "__main__":
    main()
