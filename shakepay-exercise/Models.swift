import SwiftUI

enum CardIcon {
    case sfSymbol(name: String, color: Color)
}

struct SetupCard: Identifiable {
    let id = UUID()
    let label: String
    let headline: String
    let cta: String
    let icon: CardIcon
}

struct AssetItem: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let price: String
    let change: String
    let isUp: Bool
    let holdings: String
    let fiat: String
    let iconBackground: Color
    let iconContent: AssetIcon
}

enum AssetIcon {
    case text(String)
    case symbol(String)
}

struct ForYouCard: Identifiable {
    let id = UUID()
    let title: String
    let body: String
    let cta: String
    let icon: CardIcon
    let illustrationColor: Color
}

struct DoMoreItem: Identifiable {
    let id = UUID()
    let title: String
    let systemIcon: String
    let iconColor: Color
    let gradient: [Color]?
}

struct ReadinessStep: Identifiable {
    let id = UUID()
    let title: String
    let isComplete: Bool
    let actionLabel: String?
}

enum SampleData {
    static let readinessSteps: [ReadinessStep] = [
        ReadinessStep(title: "Phone verified", isComplete: true, actionLabel: nil),
        ReadinessStep(title: "Confirm email", isComplete: false, actionLabel: "Confirm"),
        ReadinessStep(title: "Verify identity", isComplete: false, actionLabel: "Verify"),
        ReadinessStep(title: "Complete risk profile", isComplete: false, actionLabel: "Start"),
        ReadinessStep(title: "Add cash", isComplete: false, actionLabel: "Add cash")
    ]

    static let setupCards: [SetupCard] = [
        SetupCard(label: "SECURITY", headline: "You need to verify your identity", cta: "Verify",
                  icon: .sfSymbol(name: "person.badge.shield.checkmark.fill", color: Color(hex: 0x8AADFF))),
        SetupCard(label: "SECURITY NOTIFICATION", headline: "Upgrade your account security.", cta: "Learn More",
                  icon: .sfSymbol(name: "lock.fill", color: Color(hex: 0xFFD166))),
        SetupCard(label: "GET STARTED", headline: "Confirm your email address", cta: "Confirm",
                  icon: .sfSymbol(name: "envelope.fill", color: Color(hex: 0x8AADFF)))
    ]

    static let assets: [AssetItem] = [
        AssetItem(name: "Bitcoin", symbol: "BTC", price: "$83,845.21", change: "5.39%", isUp: false, holdings: "0", fiat: "$0.00", iconBackground: Color(hex: 0xF7931A), iconContent: .text("₿")),
        AssetItem(name: "Ethereum", symbol: "ETH", price: "$2,183.74", change: "11.35%", isUp: false, holdings: "0", fiat: "$0.00", iconBackground: Color(hex: 0x6F7CF7), iconContent: .symbol("suit.diamond.fill")),
        AssetItem(name: "US dollar", symbol: "USD", price: "$1.3946", change: "0.33%", isUp: true, holdings: "US$0", fiat: "$0.00", iconBackground: Color(hex: 0x1F8FFF), iconContent: .text("US$"))
    ]

    static let forYouCards: [ForYouCard] = [
        ForYouCard(title: "Get more bitcoin with scheduled buys", body: "Pay no spread when you set up a recurring bitcoin buy", cta: "Set up",
                   icon: .sfSymbol(name: "bitcoinsign.circle.fill", color: Color(hex: 0xFFB347)),
                   illustrationColor: Color(hex: 0xFFC533)),
        ForYouCard(title: "Shakepay Card", body: "Earn up to 1.5% in bitcoin cashback on every purchase", cta: "Start earning",
                   icon: .sfSymbol(name: "creditcard.fill", color: .white),
                   illustrationColor: Color(hex: 0xFF5C1A))
    ]

    static let doMoreItems: [DoMoreItem] = [
        DoMoreItem(title: "Earn up to 3% interest", systemIcon: "bitcoinsign.circle.fill", iconColor: Color(hex: 0x2BB7FF), gradient: nil),
        DoMoreItem(title: "#shakepaid giveaway", systemIcon: "gift.fill", iconColor: AppTheme.accentOrange, gradient: nil),
        DoMoreItem(title: "Invite a friend, get $20", systemIcon: "person.fill.badge.plus", iconColor: Color(hex: 0x2BB7FF), gradient: nil),
        DoMoreItem(title: "See your insights", systemIcon: "chart.bar.fill", iconColor: .white, gradient: [Color(hex: 0xFFB13C), Color(hex: 0xFF3B6B)]),
        DoMoreItem(title: "Prepare for tax season", systemIcon: "doc.text.fill", iconColor: AppTheme.accentOrange, gradient: nil)
    ]
}
