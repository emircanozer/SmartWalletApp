import Foundation

@MainActor
final class SplashViewModel {
    var onStateChange: ((SplashViewState) -> Void)?
    var onFlowCompleted: (() -> Void)?

    private var completionTask: Task<Void, Never>?

    deinit {
        completionTask?.cancel()
    }
}

extension SplashViewModel {
    func load() {
        onStateChange?(
            .loaded(
                SplashViewData(
                    titleText: "SmartWallet",
                    subtitleText: "Cebinizdeki Akilli Cuzdan",
                    footerText: "GUVENLI FINANS DENEYIMI",
                    logoImageName: "logo"
                )
            )
        )

        completionTask?.cancel()
        completionTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            guard !Task.isCancelled else { return }
            self?.onFlowCompleted?()
        }
    }
}
