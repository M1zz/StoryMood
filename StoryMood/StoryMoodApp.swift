import SwiftUI

@main
struct StoryMoodApp: App {
    // 화면 방향을 앱이 직접 제어하기 위해 델리게이트를 연결한다
    // (이야기 화면의 [가로/세로] 버튼이 OrientationController를 통해 바꾼다)
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Orientation

final class AppDelegate: NSObject, UIApplicationDelegate {
    /// 현재 허용된 화면 방향 — OrientationController가 갱신한다
    static var orientationMask: UIInterfaceOrientationMask = .allButUpsideDown

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        AppDelegate.orientationMask
    }
}

/// 버튼으로 가로/세로를 직접 전환하기 위한 헬퍼.
/// 공연 중에 기기를 흔들거나 회전 잠금이 걸려 있어도 원하는 모드로 갈 수 있어야 한다.
enum OrientationController {

    /// 지정한 방향으로 회전시키고 그 방향으로 고정한다
    static func lock(_ mask: UIInterfaceOrientationMask) {
        apply(mask)
    }

    /// 고정 해제 — 기기 회전에 따라 자유롭게 회전 (이야기 화면을 벗어날 때)
    static func unlock() {
        apply(.allButUpsideDown)
    }

    private static var currentScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
    }

    private static func apply(_ mask: UIInterfaceOrientationMask) {
        AppDelegate.orientationMask = mask
        guard let scene = currentScene else { return }
        scene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        scene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
    }
}
