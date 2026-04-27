import Foundation

enum AppStringTextFormatter {
    static func displayName(_ fullName: String) -> String {
        let trimmed = trimmed(fullName)
        guard let firstCharacter = trimmed.first else { return trimmed }
        return firstCharacter.uppercased() + trimmed.dropFirst()
    }

    static func maskedName(_ fullName: String) -> String {
        let trimmed = trimmed(fullName)
        guard let first = trimmed.first else { return "" }
        let suffix = trimmed.suffix(1)
        let starCount = max(trimmed.count - 2, 5)
        return "\(first)\(String(repeating: "*", count: starCount))\(suffix)"
    }

    static func spacedIBAN(_ iban: String, emptyFallback: String = "-") -> String {
        let normalized = iban.replacingOccurrences(of: " ", with: "")
        guard !normalized.isEmpty else { return emptyFallback }

        var chunks: [String] = []
        var index = normalized.startIndex
        while index < normalized.endIndex {
            let nextIndex = normalized.index(index, offsetBy: 4, limitedBy: normalized.endIndex) ?? normalized.endIndex
            chunks.append(String(normalized[index..<nextIndex]))
            index = nextIndex
        }

        return chunks.joined(separator: " ")
    }

    static func normalizedOptionalText(_ text: String, emptyFallback: String = "-") -> String {
        let normalized = trimmed(text)
        return normalized.isEmpty ? emptyFallback : normalized
    }

    static func prettifiedCategory(_ text: String, emptyFallback: String = "-") -> String {
        guard !trimmed(text).isEmpty else { return emptyFallback }
        return text
            .replacingOccurrences(of: "Ö", with: " Ö")
            .replacingOccurrences(of: "İ", with: " İ")
            .replacingOccurrences(of: "([a-zçğıöşü])([A-ZÇĞİÖŞÜ])", with: "$1 $2", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
