import Foundation
import SwiftUI

/// Sound effect categories organized by storytelling themes
struct SoundCategory: Identifiable, Hashable {
    let id: String
    let nameKo: String
    let nameEn: String
    let emoji: String
    let color: Color
    let description: String
    
    var displayName: String { "\(emoji) \(nameKo)" }
    
    static let allCategories: [SoundCategory] = [
        SoundCategory(
            id: "door_house",
            nameKo: "문과 집",
            nameEn: "Doors & House",
            emoji: "🚪",
            color: Color(red: 0.55, green: 0.35, blue: 0.17),
            description: "문 두드리기, 문 열기/닫기, 자물쇠 등"
        ),
        SoundCategory(
            id: "nature_weather",
            nameKo: "자연과 날씨",
            nameEn: "Nature & Weather",
            emoji: "🌿",
            color: Color(red: 0.2, green: 0.6, blue: 0.3),
            description: "바람, 비, 천둥, 숲, 강 등"
        ),
        SoundCategory(
            id: "animals",
            nameKo: "동물",
            nameEn: "Animals",
            emoji: "🐾",
            color: Color(red: 0.8, green: 0.5, blue: 0.2),
            description: "새, 늑대, 개구리, 곰 등 동물 소리"
        ),
        SoundCategory(
            id: "ocean_water",
            nameKo: "바다와 물",
            nameEn: "Ocean & Water",
            emoji: "🌊",
            color: Color(red: 0.15, green: 0.45, blue: 0.75),
            description: "파도, 물방울, 시냇물, 물속 소리 등"
        ),
        SoundCategory(
            id: "magic_fantasy",
            nameKo: "마법과 판타지",
            nameEn: "Magic & Fantasy",
            emoji: "✨",
            color: Color(red: 0.6, green: 0.3, blue: 0.8),
            description: "마법 주문, 반짝임, 변신, 요정 등"
        ),
        SoundCategory(
            id: "footsteps_movement",
            nameKo: "발자국과 움직임",
            nameEn: "Footsteps & Movement",
            emoji: "👣",
            color: Color(red: 0.5, green: 0.4, blue: 0.35),
            description: "걸음, 뛰기, 살금살금, 점프 등"
        ),
        SoundCategory(
            id: "fire_kitchen",
            nameKo: "불과 부엌",
            nameEn: "Fire & Kitchen",
            emoji: "🔥",
            color: Color(red: 0.85, green: 0.3, blue: 0.15),
            description: "모닥불, 요리, 냄비 끓기, 오븐 등"
        ),
        SoundCategory(
            id: "music_instruments",
            nameKo: "음악과 악기",
            nameEn: "Music & Instruments",
            emoji: "🎵",
            color: Color(red: 0.9, green: 0.6, blue: 0.1),
            description: "피리, 하프, 종, 오르골 등"
        ),
        SoundCategory(
            id: "spooky_night",
            nameKo: "으스스한 밤",
            nameEn: "Spooky & Night",
            emoji: "🌙",
            color: Color(red: 0.2, green: 0.15, blue: 0.35),
            description: "부엉이, 유령, 삐걱소리, 박쥐 등"
        ),
        SoundCategory(
            id: "adventure_action",
            nameKo: "모험과 액션",
            nameEn: "Adventure & Action",
            emoji: "⚔️",
            color: Color(red: 0.7, green: 0.15, blue: 0.15),
            description: "칼, 활, 폭발, 달리기 등"
        ),
        SoundCategory(
            id: "transport_travel",
            nameKo: "이동수단",
            nameEn: "Transport & Travel",
            emoji: "🐴",
            color: Color(red: 0.45, green: 0.55, blue: 0.35),
            description: "말 달리기, 마차, 배, 비행 등"
        ),
        SoundCategory(
            id: "people_voice",
            nameKo: "사람과 목소리",
            nameEn: "People & Voices",
            emoji: "👶",
            color: Color(red: 0.9, green: 0.65, blue: 0.65),
            description: "웃음, 울음, 환호, 속삭임 등"
        ),
        SoundCategory(
            id: "castle_palace",
            nameKo: "성과 궁전",
            nameEn: "Castle & Palace",
            emoji: "🏰",
            color: Color(red: 0.55, green: 0.55, blue: 0.65),
            description: "팡파레, 갑옷, 철문, 왕좌 등"
        ),
        SoundCategory(
            id: "clock_time",
            nameKo: "시계와 시간",
            nameEn: "Clock & Time",
            emoji: "⏰",
            color: Color(red: 0.4, green: 0.35, blue: 0.5),
            description: "시계 째깍, 종소리, 자정 등"
        ),
        SoundCategory(
            id: "ambience_mood",
            nameKo: "분위기와 배경",
            nameEn: "Ambience & Mood",
            emoji: "🎭",
            color: Color(red: 0.3, green: 0.5, blue: 0.55),
            description: "마을, 시장, 정원, 동굴 등 배경음"
        ),
    ]
}
