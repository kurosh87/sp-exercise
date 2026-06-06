import SwiftUI

// MARK: - Main state-aware action area

struct StateAwareActionAreaView: View {
    let state: AccountState
    @State private var activeSheet: ActionSheet? = nil

    private var action: NextBestAction { nextBestAction(for: state) }

    var body: some View {
        VStack(spacing: 16) {
            if action.showsNextStepCard {
                nextStepCard
            }
            actionButtons
        }
        .sheet(item: $activeSheet) { sheet in
            sheetDestination(for: sheet)
        }
    }

    // MARK: Next step card

    private var nextStepCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text("Next step")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(0.8)
                    .foregroundColor(AppTheme.accentBlue)
            } icon: {
                Image(systemName: action.systemIcon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(AppTheme.accentBlue)
            }

            Text(action.description)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color.white.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(1.5)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppTheme.accentBlue.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.accentBlue.opacity(0.20), lineWidth: 1)
        )
    }

    // MARK: Action buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Primary blue action
            PrimaryActionButton(title: action.title) {
                activeSheet = .primary
            }

            // Secondary row: Add cash + Send (or just Send when primary is add cash)
            if action != .addCash && action != .buyBitcoin {
                HStack(spacing: 14) {
                    SecondaryActionButton(title: "Add cash") { activeSheet = .addCash }
                    SecondaryActionButton(title: "Send") { activeSheet = .send }
                }
            } else if action == .buyBitcoin {
                SecondaryActionButton(title: "Send") { activeSheet = .send }
                    .frame(maxWidth: .infinity)
            } else {
                // addCash is primary — show Send as secondary full-width
                SecondaryActionButton(title: "Send") { activeSheet = .send }
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: Sheet routing

    @ViewBuilder
    private func sheetDestination(for sheet: ActionSheet) -> some View {
        switch sheet {
        case .primary:
            switch action {
            case .confirmEmail:        ConfirmEmailView()
            case .verifyIdentity:      VerifyIdentityView()
            case .completeRiskProfile: RiskProfileView()
            case .addCash:             AddCashView()
            case .buyBitcoin:          ExchangeView()
            }
        case .addCash: AddCashView()
        case .send:    PaymentsView()
        }
    }
}

// MARK: - Sheet identifier

enum ActionSheet: Identifiable {
    case primary, addCash, send
    var id: Self { self }
}

// MARK: - Button components

struct PrimaryActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Capsule().fill(AppTheme.accentBlue))
        }
    }
}

struct SecondaryActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Capsule().fill(AppTheme.button))
        }
    }
}

// MARK: - Demo state switcher

struct DemoStateSwitcher: View {
    @Binding var preset: DemoPreset

    var body: some View {
        VStack(spacing: 6) {
            Text("DEMO STATE")
                .font(.system(size: 10, weight: .bold))
                .tracking(1.2)
                .foregroundColor(AppTheme.textMuted.opacity(0.5))

            HStack(spacing: 0) {
                ForEach(DemoPreset.allCases, id: \.self) { p in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { preset = p }
                    } label: {
                        Text(p.rawValue)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(preset == p ? .black : AppTheme.textMuted)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                Capsule().fill(preset == p ? Color.white : Color.clear)
                            )
                    }
                }
            }
            .padding(3)
            .background(
                Capsule().fill(Color.white.opacity(0.07))
            )
            .overlay(
                Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity)
    }
}
