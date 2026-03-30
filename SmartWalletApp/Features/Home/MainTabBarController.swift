import UIKit

class MainTabBarController: UITabBarController { // tabbar tanımlanması için sayfa açtık
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
}

extension MainTabBarController {
    func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: 0.68, green: 0.71, blue: 0.78, alpha: 1.0)
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.08
        tabBar.layer.shadowRadius = 18
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.68, green: 0.71, blue: 0.78, alpha: 1.0)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.68, green: 0.71, blue: 0.78, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        selectedIndex = 0
    }
}
