import UIKit

final class ProfileViewController: UIViewController {
    var onActionSelected: ((ProfileRowAction) -> Void)?
    var onEmailSelected: ((String) -> Void)?
    var onLogout: (() -> Void)?

    private let viewModel: ProfileViewModel
    private let contentView = ProfileContentView()
    private let refreshControl = UIRefreshControl()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
        bindViewModel()
        configureRefreshControl()
        loadProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension ProfileViewController {
    func bindActions() {
        contentView.onRowSelected = { [weak self] action in
            self?.onActionSelected?(action)
        }
        contentView.onEmailSelected = { [weak self] email in
            self?.onEmailSelected?(email)
        }
        contentView.darkModeButton.addTarget(self, action: #selector(handleDarkModeTap), for: .touchUpInside)
        contentView.logoutButton.addTarget(self, action: #selector(handleLogoutTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
            case .loading:
                if !self.refreshControl.isRefreshing {
                    self.setCenteredLoading(true)
                }
            case .loaded(let data):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.contentView.apply(data)
            case .logoutSucceeded:
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.onLogout?()
            case .failure(let message):
                self.setCenteredLoading(false)
                self.refreshControl.endRefreshing()
                self.showAlert(message: message)
            }
        }
    }

    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        contentView.setRefreshControl(refreshControl)
    }

    func loadProfile() {
        Task {
            await viewModel.load()
        }
    }

    func applyDarkMode(_ isEnabled: Bool) {
        viewModel.updateDarkMode(isEnabled)
        view.window?.overrideUserInterfaceStyle = isEnabled ? .dark : .light
        contentView.updateDarkModeButton(isEnabled: isEnabled)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "Çıkış Yap",
            message: "Çıkış yapmak istediğinize emin misiniz?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Çıkış Yap", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        present(alert, animated: true)
    }

    func performLogout() {
        Task {
            await viewModel.logout()
        }
    }

    @objc func handlePullToRefresh() {
        loadProfile()
    }

    @objc func handleDarkModeTap() {
        let willEnableDarkMode = !viewModel.isDarkModeEnabled
        applyDarkMode(willEnableDarkMode)
    }

    @objc func handleLogoutTap() {
        showLogoutConfirmation()
    }
}
