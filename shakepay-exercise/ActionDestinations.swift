import SwiftUI

// MARK: - Setup flow sheet destinations (not navigation screens)

struct ConfirmEmailView: View {
    var body: some View {
        SetupSheetPlaceholder(
            icon: "envelope.fill", iconColor: AppTheme.accentBlue,
            title: "Confirm your email",
            subtitle: "We sent a confirmation link to your email address. Check your inbox and tap the link to continue.",
            cta: "Resend email"
        )
    }
}

struct VerifyIdentityView: View {
    var body: some View {
        SetupSheetPlaceholder(
            icon: "person.badge.shield.checkmark.fill", iconColor: AppTheme.accentBlue,
            title: "Verify your identity",
            subtitle: "We need to confirm who you are before you can buy, send, or set up your card.",
            cta: "Start verification"
        )
    }
}

struct RiskProfileSheet: View {
    var body: some View {
        SetupSheetPlaceholder(
            icon: "checklist", iconColor: AppTheme.accentBlue,
            title: "Complete risk profile",
            subtitle: "Answer a few quick questions about your investment goals and experience.",
            cta: "Start questionnaire"
        )
    }
}

struct BuyBitcoinSheet: View {
    var body: some View {
        SetupSheetPlaceholder(
            icon: "bitcoinsign.circle.fill", iconColor: Color(hex: 0xF7931A),
            title: "Buy bitcoin",
            subtitle: "Purchase bitcoin instantly at the current market rate.",
            cta: "Buy BTC"
        )
    }
}

// MARK: - Shared bottom sheet layout

private struct SetupSheetPlaceholder: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let cta: String

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 4)
                    .padding(.top, 14)
                    .padding(.bottom, 36)

                ZStack {
                    Circle().fill(iconColor.opacity(0.12)).frame(width: 80, height: 80)
                    Image(systemName: icon)
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(iconColor)
                        .symbolRenderingMode(.hierarchical)
                }

                VStack(spacing: 12) {
                    Text(title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 24)

                Spacer()

                Text(cta)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Capsule().fill(AppTheme.accentBlue))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
        .presentationDetents([.medium])
        .presentationBackground(AppTheme.background)
        .presentationCornerRadius(32)
    }
}
