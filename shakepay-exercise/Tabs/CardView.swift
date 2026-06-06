import SwiftUI

struct CardView: View {
    let accountState: AccountState

    private var isEligible: Bool {
        accountState.emailConfirmed &&
        accountState.identityVerified &&
        accountState.securityUpgraded
    }

    private let benefits = [
        ("bitcoinsign.circle.fill", "Earn bitcoin, not points"),
        ("mappin.circle.fill",      "Available to all Canadians"),
        ("wave.3.right",            "Tap and pay anywhere"),
        ("arrow.up.circle.fill",    "Round it up"),
        ("person.2.fill",           "Stack sats with friends"),
    ]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    cardIllustration
                    VStack(alignment: .leading, spacing: 20) {
                        headline
                        ctaArea
                        Divider().background(AppTheme.stroke).padding(.vertical, 4)
                        benefitsList
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 110)
                }
            }
        }
    }

    // MARK: Card illustration

    private var cardIllustration: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x1A1A2E), Color(hex: 0x0B0B0D)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 260)

            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient(
                        colors: [AppTheme.accentBlue, Color(hex: 0x0066CC)],
                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 240, height: 152)
                    .shadow(color: AppTheme.accentBlue.opacity(0.4), radius: 24, y: 12)

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("shakepay")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                        Image(systemName: "wave.3.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                        Text("VISA")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                    }
                }
                .padding(18)
                .frame(width: 240, height: 152)
            }
            .offset(y: 10)
        }
    }

    // MARK: Headline

    private var headline: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Get bitcoin back on every purchase")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text("Earn up to 1.5% bitcoin cashback when you shop.")
                .font(.system(size: 17))
                .foregroundColor(AppTheme.textMuted)
        }
        .padding(.top, 28)
    }

    // MARK: CTA area

    @ViewBuilder
    private var ctaArea: some View {
        if isEligible {
            Button {} label: {
                Text("Get the Shakepay Card")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(Capsule().fill(AppTheme.accentBlue))
            }
            .buttonStyle(.plain)
        } else {
            setupRequiredCard
        }
    }

    private var setupRequiredCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Finish setup to get the Shakepay Card")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 10) {
                setupStep(label: "Confirm email",          done: accountState.emailConfirmed)
                setupStep(label: "Verify identity",        done: accountState.identityVerified)
                setupStep(label: "Upgrade account security", done: accountState.securityUpgraded)
            }

            Button {} label: {
                Text("Continue setup")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Capsule().fill(AppTheme.accentBlue))
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    private func setupStep(label: String, done: Bool) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(done ? AppTheme.accentBlue.opacity(0.15) : Color.white.opacity(0.06))
                    .frame(width: 22, height: 22)
                if done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppTheme.accentBlue)
                }
            }
            Text(label)
                .font(.system(size: 15, weight: done ? .semibold : .medium))
                .foregroundColor(done ? AppTheme.textMuted : .white)
                .strikethrough(done, color: AppTheme.textMuted)
        }
    }

    // MARK: Benefits list

    private var benefitsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(benefits, id: \.1) { icon, text in
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.accentBlue)
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 28)
                    Text(text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
    }
}
