import Foundation

struct CreateFinancialGoalViewData {
    let titleText: String
    let subtitleText: String
    let nameTitleText: String
    let namePlaceholderText: String
    let targetTitleText: String
    let targetPlaceholderText: String
    let deadlineTitleText: String
    let deadlinePlaceholderText: String
    let aiHintTitleText: String
    let aiHintBodyText: String
    let approveButtonTitleText: String
}

struct CreateFinancialGoalFormState {
    let selectedDateText: String?
    let isApproveEnabled: Bool
    let isSubmitting: Bool
}
