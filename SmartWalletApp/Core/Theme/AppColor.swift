import UIKit

enum AppColor {
    static let primaryYellow = named("PrimaryYellow", fallback: UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0))
    static let primaryText = themedNamed("PrimaryText", light: UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0), dark: UIColor(red: 0.94, green: 0.95, blue: 0.98, alpha: 1.0))
    static let authHeadingText = themedNamed("AuthHeadingText", light: UIColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0), dark: UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0))
    static let brandTextStrong = themedNamed("BrandTextStrong", light: UIColor(red: 0.23, green: 0.25, blue: 0.32, alpha: 1.0), dark: UIColor(red: 0.91, green: 0.92, blue: 0.95, alpha: 1.0))
    static let brandTextSoft = themedNamed("BrandTextSoft", light: UIColor(red: 0.2, green: 0.22, blue: 0.28, alpha: 1.0), dark: UIColor(red: 0.82, green: 0.84, blue: 0.89, alpha: 1.0))
    static let secondaryText = themedNamed("SecondaryText", light: UIColor(red: 0.55, green: 0.58, blue: 0.64, alpha: 1.0), dark: UIColor(red: 0.72, green: 0.75, blue: 0.8, alpha: 1.0))
    static let mutedText = themedNamed("MutedText", light: UIColor(red: 0.47, green: 0.49, blue: 0.56, alpha: 1.0), dark: UIColor(red: 0.68, green: 0.71, blue: 0.77, alpha: 1.0))
    static let navigationTint = themedNamed("NavigationTint", light: UIColor(red: 0.35, green: 0.38, blue: 0.46, alpha: 1.0), dark: UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0))
    static let actionMutedText = themedNamed("ActionMutedText", light: UIColor(red: 0.47, green: 0.49, blue: 0.56, alpha: 1.0), dark: UIColor(red: 0.72, green: 0.75, blue: 0.8, alpha: 1.0))
    static let warmActionText = themedNamed("WarmActionText", light: UIColor(red: 0.55, green: 0.42, blue: 0.09, alpha: 1.0), dark: UIColor(red: 0.97, green: 0.81, blue: 0.36, alpha: 1.0))
    static let fieldTitleText = themedNamed("FieldTitleText", light: UIColor(red: 0.39, green: 0.41, blue: 0.48, alpha: 1.0), dark: UIColor(red: 0.78, green: 0.8, blue: 0.86, alpha: 1.0))
    static let borderSoft = themedNamed("BorderSoft", light: UIColor(red: 0.91, green: 0.92, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.25, blue: 0.31, alpha: 1.0))
    static let iconMuted = themedNamed("IconMuted", light: UIColor(red: 0.72, green: 0.75, blue: 0.8, alpha: 1.0), dark: UIColor(red: 0.61, green: 0.65, blue: 0.72, alpha: 1.0))
    static let placeholderText = themedNamed("InputPlaceholderText", light: UIColor(red: 0.65, green: 0.69, blue: 0.76, alpha: 1.0), dark: UIColor(red: 0.56, green: 0.6, blue: 0.68, alpha: 1.0))
    static let helperText = themedNamed("HelperText", light: UIColor(red: 0.73, green: 0.75, blue: 0.8, alpha: 1.0), dark: UIColor(red: 0.6, green: 0.63, blue: 0.7, alpha: 1.0))
    static let inputText = themedNamed("InputText", light: UIColor(red: 0.28, green: 0.31, blue: 0.38, alpha: 1.0), dark: UIColor(red: 0.92, green: 0.93, blue: 0.96, alpha: 1.0))
    static let codeInactive = themedNamed("CodeInactive", light: UIColor(red: 0.91, green: 0.92, blue: 0.94, alpha: 1.0), dark: UIColor(red: 0.2, green: 0.23, blue: 0.29, alpha: 1.0))
    static let verificationEmptyText = themedNamed("VerificationEmptyText", light: UIColor(red: 0.54, green: 0.57, blue: 0.63, alpha: 1.0), dark: UIColor(red: 0.68, green: 0.72, blue: 0.79, alpha: 1.0))
    static let verificationFilledText = themedNamed("VerificationFilledText", light: UIColor(red: 0.24, green: 0.27, blue: 0.34, alpha: 1.0), dark: UIColor(red: 0.94, green: 0.95, blue: 0.98, alpha: 1.0))
    static let filledBorder = themedNamed("FilledBorder", light: UIColor(red: 0.86, green: 0.88, blue: 0.92, alpha: 1.0), dark: UIColor(red: 0.31, green: 0.34, blue: 0.41, alpha: 1.0))
    static let accentBlue = named("AccentBlue", fallback: UIColor(red: 0.2, green: 0.4, blue: 0.98, alpha: 1.0))

    static let appBackground = dynamic(light: UIColor(white: 1.0, alpha: 1.0), dark: UIColor(red: 0.07, green: 0.08, blue: 0.11, alpha: 1.0))
    static let titleDark = dynamic(light: UIColor(red: 0.11, green: 0.12, blue: 0.2, alpha: 1.0), dark: UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0))
    static let tertiaryText = dynamic(light: UIColor(red: 0.44, green: 0.47, blue: 0.55, alpha: 1.0), dark: UIColor(red: 0.72, green: 0.75, blue: 0.8, alpha: 1.0))
    static let bodyText = dynamic(light: UIColor(red: 0.45, green: 0.47, blue: 0.54, alpha: 1.0), dark: UIColor(red: 0.74, green: 0.76, blue: 0.81, alpha: 1.0))
    static let quietText = dynamic(light: UIColor(red: 0.48, green: 0.5, blue: 0.56, alpha: 1.0), dark: UIColor(red: 0.7, green: 0.73, blue: 0.78, alpha: 1.0))
    static let tabInactive = dynamic(light: UIColor(red: 0.68, green: 0.71, blue: 0.78, alpha: 1.0), dark: UIColor(red: 0.51, green: 0.55, blue: 0.62, alpha: 1.0))
    static let surfaceWarm = dynamic(light: UIColor(red: 1.0, green: 0.99, blue: 0.96, alpha: 1.0), dark: UIColor(red: 0.18, green: 0.15, blue: 0.11, alpha: 1.0))
    static let surfaceWarmSoft = dynamic(light: UIColor(red: 1.0, green: 0.98, blue: 0.93, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.18, blue: 0.12, alpha: 1.0))
    static let surfaceWarmMuted = dynamic(light: UIColor(red: 0.99, green: 0.96, blue: 0.92, alpha: 1.0), dark: UIColor(red: 0.24, green: 0.19, blue: 0.13, alpha: 1.0))
    static let borderWarm = dynamic(light: UIColor(red: 0.98, green: 0.92, blue: 0.76, alpha: 1.0), dark: UIColor(red: 0.39, green: 0.32, blue: 0.18, alpha: 1.0))
    static let accentYellow = UIColor(red: 0.98, green: 0.78, blue: 0.0, alpha: 1.0)
    static let accentGold = UIColor(red: 1.0, green: 0.76, blue: 0.06, alpha: 1.0)
    static let accentOlive = UIColor(red: 0.58, green: 0.49, blue: 0.13, alpha: 1.0)
    static let darkSurface = dynamic(light: UIColor(red: 0.18, green: 0.19, blue: 0.21, alpha: 1.0), dark: UIColor(red: 0.18, green: 0.19, blue: 0.21, alpha: 1.0))
    static let darkSurfaceAlt = dynamic(light: UIColor(red: 0.12, green: 0.15, blue: 0.2, alpha: 1.0), dark: UIColor(red: 0.12, green: 0.15, blue: 0.2, alpha: 1.0))
    static let darkSurfaceSoft = dynamic(light: UIColor(red: 0.14, green: 0.18, blue: 0.24, alpha: 1.0), dark: UIColor(red: 0.14, green: 0.18, blue: 0.24, alpha: 1.0))
    static let divider = dynamic(light: UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1.0), dark: UIColor(red: 0.18, green: 0.21, blue: 0.27, alpha: 1.0))
    static let surfaceMuted = dynamic(light: UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.12, green: 0.14, blue: 0.18, alpha: 1.0))
    static let surfacePanel = dynamic(light: UIColor(red: 0.99, green: 0.99, blue: 1.0, alpha: 1.0), dark: UIColor(red: 0.1, green: 0.12, blue: 0.16, alpha: 1.0))
    static let chipSurface = dynamic(light: UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1.0))
    static let chipBorder = dynamic(light: UIColor(red: 0.86, green: 0.87, blue: 0.9, alpha: 1.0), dark: UIColor(red: 0.24, green: 0.27, blue: 0.34, alpha: 1.0))
    static let success = UIColor(red: 0.33, green: 0.73, blue: 0.4, alpha: 1.0)
    static let successStrong = UIColor(red: 0.35, green: 0.75, blue: 0.39, alpha: 1.0)
    static let successSurface = dynamic(light: UIColor(red: 0.96, green: 0.99, blue: 0.96, alpha: 1.0), dark: UIColor(red: 0.1, green: 0.19, blue: 0.13, alpha: 1.0))
    static let danger = UIColor(red: 0.87, green: 0.27, blue: 0.23, alpha: 1.0)
    static let dangerStrong = UIColor(red: 0.9, green: 0.27, blue: 0.24, alpha: 1.0)
    static let dangerSurface = dynamic(light: UIColor(red: 1.0, green: 0.95, blue: 0.94, alpha: 1.0), dark: UIColor(red: 0.24, green: 0.13, blue: 0.13, alpha: 1.0))
    static let whitePrimary = dynamic(light: UIColor(white: 1.0, alpha: 1.0), dark: UIColor(red: 0.1, green: 0.12, blue: 0.16, alpha: 1.0))
    static let white62 = dynamic(light: UIColor(white: 1.0, alpha: 0.62), dark: UIColor(white: 1.0, alpha: 0.68))
    static let white70 = dynamic(light: UIColor(white: 1.0, alpha: 0.7), dark: UIColor(white: 1.0, alpha: 0.76))
    static let white92 = dynamic(light: UIColor(white: 1.0, alpha: 0.92), dark: UIColor(red: 0.14, green: 0.17, blue: 0.22, alpha: 1.0))
    static let heroOrange = UIColor(red: 0.9, green: 0.49, blue: 0.24, alpha: 1.0)
    static let warningOrange = UIColor(red: 0.96, green: 0.65, blue: 0.12, alpha: 1.0)
    static let balanceDisplay = dynamic(light: UIColor(red: 0.99, green: 0.97, blue: 0.92, alpha: 1.0), dark: UIColor(red: 0.98, green: 0.97, blue: 0.92, alpha: 1.0))
    static let notePlaceholder = dynamic(light: UIColor(red: 0.78, green: 0.79, blue: 0.83, alpha: 1.0), dark: UIColor(red: 0.47, green: 0.52, blue: 0.59, alpha: 1.0))
    static let amountLabelMuted = dynamic(light: UIColor(red: 0.57, green: 0.58, blue: 0.66, alpha: 1.0), dark: UIColor(red: 0.75, green: 0.78, blue: 0.84, alpha: 1.0))
    static let receiptSubtitle = UIColor(red: 0.74, green: 0.75, blue: 0.79, alpha: 1.0)
    static let receiptLabel = UIColor(red: 0.69, green: 0.71, blue: 0.76, alpha: 1.0)
    static let noteAccent = UIColor(red: 0.63, green: 0.54, blue: 0.11, alpha: 0.9)
    static let buttonGray = UIColor(red: 0.35, green: 0.35, blue: 0.37, alpha: 1.0)
    static let warmHighlight = dynamic(light: UIColor(red: 1.0, green: 0.97, blue: 0.88, alpha: 1.0), dark: UIColor(red: 0.27, green: 0.23, blue: 0.14, alpha: 1.0))
    static let quickActionHighlight = UIColor(red: 1.0, green: 0.92, blue: 0.53, alpha: 1.0)

    private static func named(_ name: String, fallback: UIColor) -> UIColor {
        UIColor(named: name) ?? fallback
    }

    private static func themedNamed(_ name: String, light: UIColor, dark: UIColor) -> UIColor {
        dynamic(light: UIColor(named: name) ?? light, dark: dark)
    }

    private static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
