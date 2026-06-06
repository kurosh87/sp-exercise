import SwiftUI

// MARK: - Account State Model

struct AccountState {
    var emailConfirmed: Bool
    var identityVerified: Bool
    var riskProfileComplete: Bool
    var cashBalance: Double
    var cardSetupComplete: Bool
    var securityUpgraded: Bool

    // MARK: Demo presets

    static let incompleteSetup = AccountState(
        emailConfirmed: false,
        identityVerified: false,
        riskProfileComplete: false,
        cashBalance: 0,
        cardSetupComplete: false,
        securityUpgraded: false
    )

    static let verifiedUnfunded = AccountState(
        emailConfirmed: true,
        identityVerified: true,
        riskProfileComplete: true,
        cashBalance: 0,
        cardSetupComplete: false,
        securityUpgraded: false
    )

    static let fundedReady = AccountState(
        emailConfirmed: true,
        identityVerified: true,
        riskProfileComplete: true,
        cashBalance: 100,
        cardSetupComplete: false,
        securityUpgraded: false
    )
}

// MARK: - Next Best Action

enum NextBestAction: Equatable {
    case confirmEmail
    case verifyIdentity
    case completeRiskProfile
    case addCash
    case buyBitcoin

    var title: String {
        switch self {
        case .confirmEmail:       return "Confirm email"
        case .verifyIdentity:     return "Verify identity"
        case .completeRiskProfile: return "Complete risk profile"
        case .addCash:            return "Add cash"
        case .buyBitcoin:         return "Buy bitcoin"
        }
    }

    var description: String {
        switch self {
        case .confirmEmail:
            return "Confirm your email to finish setting up your account."
        case .verifyIdentity:
            return "Verify your identity to unlock buying, sending, and card setup."
        case .completeRiskProfile:
            return "Complete your risk profile before buying crypto."
        case .addCash, .buyBitcoin:
            return ""
        }
    }

    var showsNextStepCard: Bool {
        switch self {
        case .confirmEmail, .verifyIdentity, .completeRiskProfile: return true
        case .addCash, .buyBitcoin: return false
        }
    }

    var systemIcon: String {
        switch self {
        case .confirmEmail:        return "envelope.fill"
        case .verifyIdentity:      return "person.badge.shield.checkmark.fill"
        case .completeRiskProfile: return "checklist"
        case .addCash:             return "plus.circle.fill"
        case .buyBitcoin:          return "bitcoinsign.circle.fill"
        }
    }
}

func nextBestAction(for state: AccountState) -> NextBestAction {
    if !state.emailConfirmed        { return .confirmEmail }
    if !state.identityVerified      { return .verifyIdentity }
    if !state.riskProfileComplete   { return .completeRiskProfile }
    if state.cashBalance == 0       { return .addCash }
    return .buyBitcoin
}

// MARK: - Demo State Preset

enum DemoPreset: String, CaseIterable {
    case incompleteSetup  = "Incomplete"
    case verifiedUnfunded = "Verified"
    case fundedReady      = "Funded"

    var state: AccountState {
        switch self {
        case .incompleteSetup:  return .incompleteSetup
        case .verifiedUnfunded: return .verifiedUnfunded
        case .fundedReady:      return .fundedReady
        }
    }

    var balanceDisplay: String {
        switch self {
        case .incompleteSetup, .verifiedUnfunded: return "$0"
        case .fundedReady: return "$100"
        }
    }
}
