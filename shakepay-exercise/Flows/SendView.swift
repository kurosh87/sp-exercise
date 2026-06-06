import SwiftUI

struct SendView: View {
    @Environment(\.dismiss) private var dismiss

    private let options: [FlowOption] = [
        FlowOption(icon: "person.2.fill",        iconBg: Color(hex: 0x1A3A5C), iconFg: AppTheme.accentBlue,
                   title: "Pay a friend",           subtitle: "Send cash instantly"),
        FlowOption(icon: "arrow.left.arrow.right", iconBg: Color(hex: 0xB8860B).opacity(0.9), iconFg: Color(hex: 0xFFD700),
                   title: "Interac e-Transfer®",    subtitle: "Send up to $10,000 within 1 hour"),
        FlowOption(icon: "doc.text.fill",          iconBg: Color(hex: 0x2A2A2D), iconFg: .white,
                   title: "Pay a bill",             subtitle: "Pay utilities or other bills"),
        FlowOption(icon: "arrow.triangle.2.circlepath", iconBg: Color(hex: 0x2A2A2D), iconFg: .white,
                   title: "Pre-authorized debits",  subtitle: "Automate payments & transfers"),
        FlowOption(icon: "arrow.up.circle.fill",   iconBg: Color(hex: 0x2A2A2D), iconFg: .white,
                   title: "Send crypto",            subtitle: "Bitcoin, Ethereum, or USDC"),
    ]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(options) { option in
                            FlowOptionRow(option: option)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private var navBar: some View {
        ZStack {
            Text("Send")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
    }
}
