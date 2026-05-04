import Foundation

struct EditFinancialGoalViewData {
    let titleText: String
    let nameTitleText: String
    let amountTitleText: String
    let dateTitleText: String
    let noteTitleText: String
    let notePlaceholderText: String
    let saveButtonTitleText: String
    let cancelButtonTitleText: String
    let deleteButtonTitleText: String
    let deleteDescriptionText: String
}

struct EditFinancialGoalFormState {
    let selectedDateText: String?
    let isSaveEnabled: Bool
}
