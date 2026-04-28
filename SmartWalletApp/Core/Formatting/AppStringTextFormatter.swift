import Foundation

enum AppStringTextFormatter {
    static func displayName(_ fullName: String) -> String {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmed.first else { return trimmed }
        return firstCharacter.uppercased() + trimmed.dropFirst()
    }

    static func normalizedOptionalText(_ text: String, fallback: String = "-") -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? fallback : trimmed
    }

    static func transactionSubtitle(_ description: String, fallback: String) -> String {
        normalizedOptionalText(description, fallback: fallback)
    }

    static func formattedIBAN(_ iban: String, fallback: String = "-") -> String {
        let trimmed = iban.replacingOccurrences(of: " ", with: "")
        guard !trimmed.isEmpty else { return fallback }

        var chunks: [String] = []
        var index = trimmed.startIndex
        while index < trimmed.endIndex {
            let nextIndex = trimmed.index(index, offsetBy: 4, limitedBy: trimmed.endIndex) ?? trimmed.endIndex
            chunks.append(String(trimmed[index..<nextIndex]))
            index = nextIndex
        }

        return chunks.joined(separator: " ")
    }

    static func maskedName(_ fullName: String, minimumMaskCount: Int = 5) -> String {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first else { return "" }
        let suffix = trimmed.suffix(1)
        let starCount = max(trimmed.count - 2, minimumMaskCount)
        return "\(first)\(String(repeating: "*", count: starCount))\(suffix)"
    }

    static func prettifiedCategory(_ text: String, fallback: String = "-") -> String {
        guard !text.isEmpty else { return fallback }

        return text
            .replacingOccurrences(of: "Ö", with: " Ö")
            .replacingOccurrences(of: "İ", with: " İ")
            .replacingOccurrences(
                of: "([a-zçğıöşü])([A-ZÇĞİÖŞÜ])",
                with: "$1 $2",
                options: .regularExpression
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
