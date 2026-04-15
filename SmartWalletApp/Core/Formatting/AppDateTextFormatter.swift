import Foundation

enum AppDateOutputStyle {
    case transactionDateTime
    case investmentHistoryDateTime
}

enum AppDateTextFormatter {
    static func parseServerDate(_ rawValue: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]

        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US_POSIX")
        localFormatter.timeZone = TimeZone.current
        localFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"

        let shortFractionFormatter = DateFormatter()
        shortFractionFormatter.locale = Locale(identifier: "en_US_POSIX")
        shortFractionFormatter.timeZone = TimeZone.current
        shortFractionFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        let plainFormatter = DateFormatter()
        plainFormatter.locale = Locale(identifier: "en_US_POSIX")
        plainFormatter.timeZone = TimeZone.current
        plainFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return formatter.date(from: rawValue)
            ?? fallbackFormatter.date(from: rawValue)
            ?? localFormatter.date(from: rawValue)
            ?? shortFractionFormatter.date(from: rawValue)
            ?? plainFormatter.date(from: rawValue)
            ?? Date()
    }

    static func string(from rawValue: String, style: AppDateOutputStyle) -> String {
        string(from: parseServerDate(rawValue), style: style)
    }

    static func string(from date: Date, style: AppDateOutputStyle) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = style.formatString
        return formatter.string(from: date)
    }
}

private extension AppDateOutputStyle {
    var formatString: String {
        switch self {
        case .transactionDateTime:
            return "d MMMM yyyy, HH.mm"
        case .investmentHistoryDateTime:
            return "dd MMMM yyyy • HH:mm"
        }
    }
}
