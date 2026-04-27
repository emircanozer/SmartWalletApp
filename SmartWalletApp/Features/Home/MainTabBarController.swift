import UIKit

class MainTabBarController: UITabBarController { // tabbar tanımlanması için sayfa açtık
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }

    func configureAssistantItem(_ item: UITabBarItem) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "apple.intelligence", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        item.image = image
        item.selectedImage = image
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
    }
}

extension MainTabBarController {
    func configureTabBar() {
        tabBar.backgroundColor = AppColor.whitePrimary
        tabBar.tintColor = AppColor.primaryYellow
        tabBar.unselectedItemTintColor = AppColor.tabInactive
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.08
        tabBar.layer.shadowRadius = 18
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.whitePrimary
        appearance.stackedLayoutAppearance.selected.iconColor = AppColor.primaryYellow
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: AppColor.primaryYellow,
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = AppColor.tabInactive
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: AppColor.tabInactive,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        selectedIndex = 0
    }
}
