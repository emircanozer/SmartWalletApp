import Foundation

enum InvestmentTradingValueFormatter {
    static func quantity(_ value: Decimal) -> String {
        AppNumberTextFormatter.decimal(
            value,
            minimumFractionDigits: 0,
            maximumFractionDigits: 4
        )
    }

    static func estimatedAssetAmount(_ value: Decimal, asset: InvestmentTradingAssetType) -> String {
        switch asset {
        case .gold, .silver:
            return AppNumberTextFormatter.decimal(
                value,
                minimumFractionDigits: 0,
                maximumFractionDigits: 4
            )
        default:
            return AppNumberTextFormatter.decimal(
                value,
                minimumFractionDigits: 0,
                maximumFractionDigits: 2
            )
        }
    }

    static func unitPrice(_ value: Decimal, asset: InvestmentTradingAssetType) -> String {
        switch asset {
        case .gold, .silver:
            return AppNumberTextFormatter.prefixedLira(
                value,
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            )
        default:
            return AppNumberTextFormatter.prefixedLira(
                value,
                minimumFractionDigits: 4,
                maximumFractionDigits: 4
            )
        }
    }
}
