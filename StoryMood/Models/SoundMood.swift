import Foundation
import SwiftUI

/// Storytelling mood themes — each sound can belong to multiple moods
struct SoundMood: Identifiable, Hashable {
    let id: String
    let nameKo: String
    let emoji: String
    let color: Color
    let description: String
    let bgmFileName: String  // BGM 파일명 (Sounds/ 폴더)

    static let allMoods: [SoundMood] = [
        SoundMood(
            id: "bright_adventure",
            nameKo: "밝은 모험",
            emoji: "🌟",
            color: Color(red: 0.95, green: 0.60, blue: 0.10),
            description: "신나고 활기찬 모험 이야기",
            bgmFileName: "village_ambience"
        ),
        SoundMood(
            id: "dark_spooky",
            nameKo: "음산한 공포",
            emoji: "🌑",
            color: Color(red: 0.50, green: 0.20, blue: 0.75),
            description: "으스스하고 긴장감 넘치는 이야기",
            bgmFileName: "creepy_music"
        ),
        SoundMood(
            id: "magic_mystical",
            nameKo: "신비한 마법",
            emoji: "✨",
            color: Color(red: 0.55, green: 0.20, blue: 0.90),
            description: "마법과 환상이 가득한 이야기",
            bgmFileName: "magical_forest"
        ),
        SoundMood(
            id: "cozy_warm",
            nameKo: "포근한 일상",
            emoji: "🏡",
            color: Color(red: 0.75, green: 0.45, blue: 0.20),
            description: "따뜻하고 아늑한 일상의 이야기",
            bgmFileName: "garden_peaceful"
        ),
        SoundMood(
            id: "grand_kingdom",
            nameKo: "웅장한 왕국",
            emoji: "👑",
            color: Color(red: 0.70, green: 0.50, blue: 0.10),
            description: "왕국과 영웅의 장엄한 이야기",
            bgmFileName: "ballroom_music"
        ),
        SoundMood(
            id: "nature_wild",
            nameKo: "자연과 동물",
            emoji: "🌿",
            color: Color(red: 0.18, green: 0.58, blue: 0.30),
            description: "자연과 동물이 살아 숨쉬는 이야기",
            bgmFileName: "forest_ambience"
        ),
    ]

    // MARK: - Sound → Mood mapping
    // Each sound ID maps to one or more mood IDs
    static let soundMoodMapping: [String: [String]] = [

        // 🚪 문과 집
        "door_knock":       ["cozy_warm", "grand_kingdom"],
        "door_creak":       ["dark_spooky"],
        "door_slam":        ["dark_spooky", "bright_adventure"],
        "lock_unlock":      ["dark_spooky"],
        "key_jingle":       ["dark_spooky", "bright_adventure"],
        "window_open":      ["cozy_warm", "magic_mystical"],
        "floor_creak":      ["dark_spooky"],
        "chimney_sweep":    ["cozy_warm"],
        "house_collapse":   ["bright_adventure"],
        "curtain_swoosh":   ["magic_mystical", "grand_kingdom"],

        // 🌿 자연과 날씨
        "wind_blow":            ["nature_wild", "dark_spooky"],
        "wind_howl":            ["dark_spooky"],
        "rain_light":           ["cozy_warm", "nature_wild"],
        "rain_heavy":           ["dark_spooky", "nature_wild"],
        "thunder":              ["dark_spooky"],
        "leaves_rustle":        ["nature_wild", "cozy_warm"],
        "tree_branch_snap":     ["nature_wild", "dark_spooky"],
        "snow_crunch":          ["cozy_warm", "nature_wild"],
        "forest_ambience":      ["nature_wild"],
        "earthquake_rumble":    ["bright_adventure", "dark_spooky"],

        // 🐾 동물
        "wolf_howl":        ["dark_spooky"],
        "wolf_growl":       ["dark_spooky"],
        "bird_singing":     ["nature_wild", "cozy_warm"],
        "rooster_crow":     ["cozy_warm", "nature_wild"],
        "frog_croak":       ["nature_wild"],
        "bear_growl":       ["dark_spooky", "nature_wild"],
        "horse_neigh":      ["grand_kingdom", "bright_adventure"],
        "cat_meow":         ["cozy_warm"],
        "dog_bark":         ["cozy_warm"],
        "donkey_bray":      ["bright_adventure", "cozy_warm"],
        "mouse_squeak":     ["cozy_warm", "magic_mystical"],
        "snake_hiss":       ["dark_spooky"],
        "lion_roar":        ["bright_adventure", "nature_wild"],
        "pig_oink":         ["cozy_warm"],
        "duck_quack":       ["cozy_warm", "nature_wild"],
        "cricket_chirp":    ["nature_wild", "dark_spooky"],
        "bee_buzz":         ["nature_wild", "cozy_warm"],
        "goat_bleat":       ["cozy_warm", "nature_wild"],
        "hen_cluck":        ["cozy_warm"],

        // 🌊 바다와 물
        "ocean_waves":          ["nature_wild"],
        "water_splash":         ["nature_wild", "bright_adventure"],
        "water_drip":           ["dark_spooky", "nature_wild"],
        "stream_flow":          ["nature_wild", "cozy_warm"],
        "underwater_bubble":    ["magic_mystical", "nature_wild"],
        "seagull_cry":          ["nature_wild"],
        "whale_song":           ["magic_mystical", "nature_wild"],
        "waterfall":            ["nature_wild"],

        // ✨ 마법과 판타지
        "magic_sparkle":    ["magic_mystical"],
        "magic_wand":       ["magic_mystical"],
        "magic_transform":  ["magic_mystical"],
        "magic_poof":       ["magic_mystical"],
        "fairy_wings":      ["magic_mystical"],
        "magic_potion":     ["magic_mystical", "dark_spooky"],
        "magic_chime":      ["magic_mystical"],
        "magic_whoosh":     ["magic_mystical"],
        "spell_cast":       ["magic_mystical", "dark_spooky"],
        "mirror_magic":     ["magic_mystical"],
        "genie_appear":     ["magic_mystical", "bright_adventure"],

        // 👣 발자국과 움직임
        "footstep_walk":    ["cozy_warm"],
        "footstep_run":     ["bright_adventure"],
        "footstep_tiptoe":  ["dark_spooky", "bright_adventure"],
        "giant_footstep":   ["dark_spooky", "bright_adventure"],
        "climbing":         ["bright_adventure"],
        "jumping":          ["bright_adventure", "cozy_warm"],
        "falling":          ["bright_adventure"],
        "sliding":          ["bright_adventure", "cozy_warm"],

        // 🔥 불과 부엌
        "fire_crackle":     ["cozy_warm", "dark_spooky"],
        "pot_boiling":      ["cozy_warm"],
        "oven_door":        ["cozy_warm"],
        "chopping":         ["cozy_warm"],
        "eating_crunching": ["cozy_warm"],
        "pouring_liquid":   ["cozy_warm"],
        "match_strike":     ["dark_spooky", "cozy_warm"],
        "candle_blow":      ["magic_mystical", "cozy_warm"],

        // 🎵 음악과 악기
        "harp_strum":       ["magic_mystical", "grand_kingdom"],
        "music_box":        ["magic_mystical", "cozy_warm"],
        "flute_play":       ["nature_wild", "magic_mystical"],
        "drum_beat":        ["bright_adventure", "grand_kingdom"],
        "trumpet_fanfare":  ["grand_kingdom", "bright_adventure"],
        "bell_ring":        ["grand_kingdom", "magic_mystical"],
        "singing_voice":    ["magic_mystical", "cozy_warm"],
        "lullaby":          ["cozy_warm"],
        "spinning_wheel":   ["dark_spooky", "cozy_warm"],

        // 🌙 으스스한 밤
        "owl_hoot":         ["dark_spooky"],
        "ghost_moan":       ["dark_spooky"],
        "witch_cackle":     ["dark_spooky"],
        "bat_flutter":      ["dark_spooky"],
        "night_ambience":   ["dark_spooky"],
        "creepy_music":     ["dark_spooky"],
        "wolf_howl_night":  ["dark_spooky"],
        "chains_rattle":    ["dark_spooky"],

        // ⚔️ 모험과 액션
        "sword_clash":      ["bright_adventure", "grand_kingdom"],
        "sword_draw":       ["bright_adventure", "grand_kingdom"],
        "arrow_shoot":      ["bright_adventure"],
        "treasure_open":    ["bright_adventure", "magic_mystical"],
        "rope_swing":       ["bright_adventure"],
        "shield_block":     ["bright_adventure", "grand_kingdom"],
        "explosion":        ["bright_adventure"],
        "map_unroll":       ["bright_adventure"],
        "axe_chop":         ["bright_adventure", "nature_wild"],

        // 🐴 이동수단
        "horse_gallop":     ["bright_adventure", "grand_kingdom"],
        "carriage_ride":    ["grand_kingdom", "cozy_warm"],
        "boat_rowing":      ["bright_adventure", "nature_wild"],
        "ship_creak":       ["bright_adventure", "dark_spooky"],
        "flying_carpet":    ["magic_mystical", "bright_adventure"],
        "broomstick_fly":   ["magic_mystical", "dark_spooky"],
        "sled_sliding":     ["cozy_warm", "bright_adventure"],

        // 👶 사람과 목소리
        "laughing":         ["cozy_warm", "bright_adventure"],
        "crying":           ["dark_spooky", "cozy_warm"],
        "gasp_surprise":    ["bright_adventure", "magic_mystical"],
        "whisper":          ["dark_spooky", "magic_mystical"],
        "cheer_crowd":      ["bright_adventure", "grand_kingdom"],
        "snoring":          ["cozy_warm"],
        "yawn":             ["cozy_warm"],
        "evil_laugh":       ["dark_spooky"],
        "baby_giggle":      ["cozy_warm"],
        "scream":           ["dark_spooky", "bright_adventure"],

        // 🏰 성과 궁전
        "castle_gate":      ["grand_kingdom", "dark_spooky"],
        "armor_clank":      ["grand_kingdom"],
        "royal_fanfare":    ["grand_kingdom"],
        "throne_sit":       ["grand_kingdom"],
        "glass_slipper":    ["magic_mystical", "grand_kingdom"],
        "ballroom_music":   ["grand_kingdom", "magic_mystical"],
        "drawbridge":       ["grand_kingdom"],

        // ⏰ 시계와 시간
        "clock_tick":       ["dark_spooky", "magic_mystical"],
        "clock_chime_12":   ["dark_spooky", "magic_mystical"],
        "clock_cuckoo":     ["cozy_warm"],
        "hourglass_flip":   ["magic_mystical"],
        "alarm_ring":       ["cozy_warm"],

        // 🎭 분위기와 배경
        "village_ambience":     ["cozy_warm"],
        "market_bustle":        ["bright_adventure", "cozy_warm"],
        "garden_peaceful":      ["cozy_warm", "nature_wild"],
        "cave_echo":            ["dark_spooky", "bright_adventure"],
        "desert_wind":          ["bright_adventure", "nature_wild"],
        "mountain_wind":        ["nature_wild", "bright_adventure"],
        "sunrise_birds":        ["cozy_warm", "nature_wild"],
        "magical_forest":       ["magic_mystical", "nature_wild"],
        "underwater_ambience":  ["magic_mystical", "nature_wild"],
        "happy_ending":         ["magic_mystical", "bright_adventure", "grand_kingdom"],
        "once_upon_time":       ["magic_mystical", "cozy_warm"],
        "page_turn":            ["cozy_warm"],

        // 🎪 추가 효과음 (Mixkit)
        "cow_moo":             ["nature_wild", "cozy_warm"],
        "sheep_baa":           ["nature_wild", "cozy_warm"],
        "goose_honk":          ["nature_wild"],
        "crow_caw":            ["dark_spooky", "nature_wild"],
        "monkey_screech":      ["nature_wild", "bright_adventure"],
        "beast_roar":          ["dark_spooky", "bright_adventure"],
        "dragon_roar":         ["dark_spooky", "magic_mystical"],
        "rubber_duck":         ["cozy_warm", "bright_adventure"],
        "applause":            ["bright_adventure", "grand_kingdom"],
        "kid_giggle":          ["cozy_warm", "bright_adventure"],
        "sneeze":              ["cozy_warm", "bright_adventure"],
        "kiss":                ["cozy_warm", "grand_kingdom"],
        "fart":                ["bright_adventure", "cozy_warm"],
        "hiccup":              ["cozy_warm", "bright_adventure"],
        "drink_sip":           ["cozy_warm"],
        "glass_break":         ["dark_spooky", "bright_adventure"],
        "balloon_pop":         ["bright_adventure"],
        "coins_jingle":        ["grand_kingdom", "bright_adventure"],
        "hammer_wood":         ["cozy_warm", "bright_adventure"],
        "hand_saw":            ["cozy_warm", "bright_adventure"],
        "broom_sweep":         ["cozy_warm"],
        "scissors_cut":        ["cozy_warm"],
        "paper_crumple":       ["cozy_warm"],
        "soap_bubble":         ["cozy_warm", "magic_mystical"],
        "cartoon_boing":       ["bright_adventure"],
        "cartoon_pop":         ["bright_adventure"],
        "cartoon_whistle":     ["bright_adventure", "cozy_warm"],
        "church_bell":         ["grand_kingdom", "cozy_warm"],
        "fireworks":           ["bright_adventure", "grand_kingdom"],
    ]
}
