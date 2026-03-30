import UIKit

class HomeCoordinator: Coordinator {
    var children: [Coordinator] = []

    let rootViewController = MainTabBarController() // Home akışının kökü  UITabBarController bu bir tabbar instancesi

    func start() {
        //tabbar sayfalarını şimdilik öylesine oluşturduk
        let dashboardViewController = DashboardViewController()
        let walletViewController = PlaceholderViewController(titleText: "Cüzdan")
        let assistantViewController = PlaceholderViewController(titleText: "AI Asistan")
        let transferViewController = PlaceholderViewController(titleText: "Transfer")
        let profileViewController = PlaceholderViewController(titleText: "Profil")

        let controllers = [  // alltaki fonk sayesinde navcontrol ile sardık array yapıp tabbara verdik 
            makeNavigationController(root: dashboardViewController, title: "Ana Sayfa", imageName: "house"),
            makeNavigationController(root: walletViewController, title: "Cüzdan", imageName: "creditcard"),
            makeNavigationController(root: assistantViewController, title: "AI Asistan", imageName: "cpu"),
            makeNavigationController(root: transferViewController, title: "Transfer", imageName: "arrow.left.arrow.right"),
            makeNavigationController(root: profileViewController, title: "Profil", imageName: "person")
        ]

        // oluşturulan sayfalar set ile tabbara ekleniyor
        rootViewController.setViewControllers(controllers, animated: false)
    }

    //sayfaları oluşturup sonra  navcontrol ile sardık en son tabbara ekledik
    private func makeNavigationController(root: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        return navigationController
    }
}
