import SwiftUI

// MARK: - Sheet destination views for each action

struct ConfirmEmailView: View {
    var body: some View {
        ActionSheetPlaceholder(
            icon: "envelope.fill",
            iconColor: AppTheme.accentBlue,
            title: "Confirm your email",
            subtitle: "We sent a confirmation link to your email address. Check your inbox and tap the link to continue.",
            cta: "Resend email"
        )
    }
}

struct VerifyIdentityView: View {
    var body: some View {
        ActionSheetPlaceholder(
            icon: "person.badge.shield.checkmark.fill",
            iconColor: AppTheme.accentBlue,
            title: "Verify your identity",
            subtitle: "We need to confirm who you are before you can buy, send, or set up your card.",
            cta: "Start verification"
        )
    }
}

struct RiskProfileView: View {
    var body: some View {
        ActionSheetPlaceholder(
            icon: "checklist",
            iconColor: AppTheme.accentBlue,
            title: "Complete risk profile",
            subtitle: "Answer a few quick questions about your investment goals and experience.",
            cta: "Start questionnaire"
        )
    }
}

struct AddCashView: View {
    var body: some View {
        ActionSheetPlaceholder(
            icon: "banknote.fill",
            iconColor: AppTheme.accentBlue,
            title: "Add cash",
            subtitle: "Transfer funds from your bank account to start buying crypto.",
            cta: "Connect bank account"
        )
    }
}

struct ExchangeView: View {
    var body: some View {
        ActionSheetPlaceholder(
            icon: "bitcoinsign.circle.fill",
            iconColor: Color(hex: 0xF7931A),
            title: "Buy bitcoin",
            subtitle: "Purchase bitcoin instantly at the current market rate.",
            cta: "Buy BTC"
        )
    }
}

struct PaymentsView: View {
    var body: some View {
        ActionSheetPlaceholder(
            icon: "paperplane.fill",
            iconColor: AppTheme.accentBlue,
            title: "Send",
            subtitle: "Send crypto or cash to another Shakepay user.",
            cta: "Choose recipient"
        )
    }
}

// MARK: - Shared sheet placeholder layout

private struct ActionSheetPlaceholder: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let cta: String

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                // Drag handle
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 4)
                    .padding(.top, 14)
                    .padding(.bottom, 36)

                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 80, height: 80)
                    Image(systemName: icon)
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(iconColor)
                        .symbolRenderingMode(.hierarchical)
                }

                // Text
                VStack(spacing: 12) {
                    Text(title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(AppTheme.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 24)

                Spacer()

                // CTA
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
