import UIKit

final class SplashViewController: UIViewController {
    private let viewModel: SplashViewModel
    private let contentView = SplashContentView()

    init(viewModel: SplashViewModel) {
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
        bindViewModel()
        viewModel.load()
    }
}

 extension SplashViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .loaded(let data):
                self.contentView.apply(data)
            }
        }
    }
}
