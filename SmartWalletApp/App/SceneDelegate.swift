import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        ThemePreferenceStore.shared.applyTheme(to: window)
        let coordinator = AppCoordinator(window: window)

        self.window = window
        appCoordinator = coordinator

        coordinator.start() // first screen 
    }
}

// MARK: sayfa ilk açıldığında scenedelegate cordinatörü başlatır kordinatör de Hoşgeldin sayfasını açtırır
