import UIKit

final class ThemePreferenceStore {
    static let shared = ThemePreferenceStore()

    private let isDarkModeEnabledKey = "isDarkModeEnabled"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isDarkModeEnabled: Bool {
        defaults.bool(forKey: isDarkModeEnabledKey)
    }

    func setDarkModeEnabled(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: isDarkModeEnabledKey)
    }

    func applyTheme(to window: UIWindow?) {
        window?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
}
