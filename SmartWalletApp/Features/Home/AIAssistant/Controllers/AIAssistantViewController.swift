import UIKit

final class AIAssistantViewController: UIViewController {
    private enum Constants {
        static let cellIdentifier = "AIAssistantMessageCell"
    }

    private let viewModel: AIAssistantViewModel
    private let contentView = AIAssistantContentView()
    private var currentMessages: [AIAssistantMessageItem] = []
    private var lastRenderedMessageIDs: [UUID] = []
    private var lastKnownTableWidth: CGFloat = 0

    init(viewModel: AIAssistantViewModel) {
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
        bindTableView()
        bindActions()
        bindViewModel()
        viewModel.load()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let tableWidth = contentView.tableView.bounds.width
        guard tableWidth > 0, abs(tableWidth - lastKnownTableWidth) > 1 else { return }

        lastKnownTableWidth = tableWidth
        contentView.tableView.reloadData()
        contentView.tableView.layoutIfNeeded()
        scrollToBottomIfNeeded()
    }
}

extension AIAssistantViewController {
    func bindTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(AIAssistantMessageCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }

    func bindActions() {
        contentView.messageTextField.addTarget(self, action: #selector(handleDraftChanged), for: .editingChanged)
        contentView.messageTextField.addTarget(self, action: #selector(handleReturnTap), for: .editingDidEndOnExit)
        contentView.sendButton.addTarget(self, action: #selector(handleSendTap), for: .touchUpInside)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .loaded(let data):
                let incomingIDs = data.messages.map(\.id)
                let shouldReloadMessages = incomingIDs != self.lastRenderedMessageIDs
                self.currentMessages = data.messages
                self.contentView.apply(data)
                if shouldReloadMessages {
                    self.lastRenderedMessageIDs = incomingIDs
                    self.contentView.tableView.reloadData()
                    self.scrollToBottomIfNeeded()
                }
            case .failure(let message):
                self.showAlert(message: message)
            }
        }
    }

    func scrollToBottomIfNeeded() {
        guard !currentMessages.isEmpty else { return }
        let lastRow = currentMessages.count - 1
        contentView.tableView.layoutIfNeeded()
        contentView.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc func handleDraftChanged() {
        viewModel.updateDraft(contentView.messageTextField.text ?? "")
    }

    @objc func handleReturnTap() {
        handleSendTap()
    }

    @objc func handleSendTap() {
        let message = contentView.messageTextField.text ?? ""
        contentView.messageTextField.text = ""
        viewModel.updateDraft("")
        Task {
            await viewModel.sendMessage(message)
        }
    }
}

extension AIAssistantViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? AIAssistantMessageCell else {
            return UITableViewCell()
        }

        cell.delegate = self
        cell.configure(with: currentMessages[indexPath.row])
        return cell
    }
}

extension AIAssistantViewController: AIAssistantMessageCellDelegate {
    func aiAssistantMessageCellDidTapAccept(_ cell: AIAssistantMessageCell) {
        guard let indexPath = contentView.tableView.indexPath(for: cell) else { return }
        viewModel.acceptAction(for: currentMessages[indexPath.row].id)
    }

    func aiAssistantMessageCellDidTapDecline(_ cell: AIAssistantMessageCell) {
        guard let indexPath = contentView.tableView.indexPath(for: cell) else { return }
        viewModel.declineAction(for: currentMessages[indexPath.row].id)
    }
}
