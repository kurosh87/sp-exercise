import SwiftUI

// MARK: - Main state-aware action area

struct StateAwareActionAreaView: View {
    let state: AccountState
    var onAdd:  (() -> Void)? = nil
    var onSend: (() -> Void)? = nil

    @State private var activeSheet: SetupSheet? = nil

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
        HStack(spacing: 12) {
            Image(systemName: action.systemIcon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.accentBlue)
                .symbolRenderingMode(.hierarchical)
            VStack(alignment: .leading, spacing: 3) {
                Text("Next step")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.6)
                    .foregroundColor(AppTheme.accentBlue)
                Text(action.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(1.5)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.accentBlue.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppTheme.accentBlue.opacity(0.22), lineWidth: 1)
        )
    }

    // MARK: Action buttons

    @ViewBuilder
    private var actionButtons: some View {
        if action.showsNextStepCard {
            // Setup incomplete: full-width primary setup CTA, then Add + Send side by side
            VStack(spacing: 12) {
                PrimaryActionButton(title: action.title) { activeSheet = .setupAction }
                HStack(spacing: 14) {
                    SecondaryActionButton(title: "Add cash") { onAdd?() }
                    SecondaryActionButton(title: "Send")     { onSend?() }
                }
            }
        } else {
            // Setup complete: primary action + Send side by side
            HStack(spacing: 14) {
                PrimaryActionButton(title: action.title) {
                    if action == .addCash { onAdd?() } else { activeSheet = .setupAction }
                }
                SecondaryActionButton(title: "Send") { onSend?() }
            }
        }
    }

    // MARK: Sheet destinations (setup flows only)

    @ViewBuilder
    private func sheetDestination(for sheet: SetupSheet) -> some View {
        switch action {
        case .confirmEmail:        ConfirmEmailView()
        case .verifyIdentity:      VerifyIdentityView()
        case .completeRiskProfile: RiskProfileView()
        case .buyBitcoin:          ExchangeView()
        case .addCash:             EmptyView() // handled by onAdd nav
        }
    }
}

// MARK: - Sheet identifier (setup flows)

private enum SetupSheet: Identifiable {
    case setupAction
    var id: Self { self }
}

// MARK: - Button components

struct PrimaryActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Capsule().fill(AppTheme.accentBlue))
        }
        .buttonStyle(.plain)
    }
}

struct SecondaryActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Capsule().fill(AppTheme.button))
        }
        .buttonStyle(.plain)
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
                            .background(Capsule().fill(preset == p ? Color.white : Color.clear))
                    }
                }
            }
            .padding(3)
            .background(Capsule().fill(Color.white.opacity(0.07)))
            .overlay(Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1))
        }
        .frame(maxWidth: .infinity)
    }
}
