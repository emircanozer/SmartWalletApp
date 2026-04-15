import Foundation

enum AppNumberTextFormatter {
    static func decimal(
        _ value: Decimal,
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int,
        locale: Locale = Locale(identifier: "tr_TR")
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: value as NSDecimalNumber) ?? "0"
    }

    static func currencyTRY(
        _ value: Decimal,
        minimumFractionDigits: Int = 2,
        maximumFractionDigits: Int = 2
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.currencySymbol = "₺"
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: value as NSDecimalNumber) ?? "₺0,00"
    }

    static func prefixedLira(
        _ value: Decimal,
        prefix: String = "",
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 0
    ) -> String {
        let formattedValue = decimal(
            value,
            minimumFractionDigits: minimumFractionDigits,
            maximumFractionDigits: maximumFractionDigits
        )
        return "\(prefix)₺\(formattedValue)"
    }

    static func signedPercent(
        _ value: Decimal,
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 2
    ) -> String {
        let absoluteValue = value < .zero ? -value : value
        let formattedValue = decimal(
            absoluteValue,
            minimumFractionDigits: minimumFractionDigits,
            maximumFractionDigits: maximumFractionDigits
        )
        return value < .zero ? "-%\(formattedValue)" : "+%\(formattedValue)"
    }

    static func signedCurrencyTRY(
        _ value: Decimal,
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 2
    ) -> String {
        let absoluteValue = value < .zero ? -value : value
        let formattedValue = currencyTRY(
            absoluteValue,
            minimumFractionDigits: minimumFractionDigits,
            maximumFractionDigits: maximumFractionDigits
        )
        return value < .zero ? "-\(formattedValue)" : "+\(formattedValue)"
    }

    static func inputDecimal(_ value: Decimal, maximumFractionDigits: Int = 4) -> String {
        decimal(
            value,
            minimumFractionDigits: 0,
            maximumFractionDigits: maximumFractionDigits,
            locale: Locale(identifier: "en_US_POSIX")
        )
    }
}
