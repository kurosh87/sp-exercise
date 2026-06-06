import SwiftUI

struct SendView: View {
    @Environment(\.dismiss) private var dismiss

    private let options: [FlowOption] = [
        FlowOption(icon: "person.2.fill",
                   iconBg: Color(hex: 0x1A3A5C), iconFg: AppTheme.accentBlue,
                   title: "Pay a friend",
                   subtitle: "Send cash instantly"),
        FlowOption(icon: "arrow.left.arrow.right",
                   iconBg: Color(hex: 0x9A6E00), iconFg: Color(hex: 0xFFD700),
                   title: "Interac e-Transfer®",
                   subtitle: "Send up to $10,000 within 1 hour"),
        FlowOption(icon: "doc.text.fill",
                   iconBg: Color(hex: 0x222224), iconFg: Color.white,
                   title: "Pay a bill",
                   subtitle: "Pay utilities or other bills"),
        FlowOption(icon: "arrow.triangle.2.circlepath",
                   iconBg: Color(hex: 0x222224), iconFg: Color.white,
                   title: "Pre-authorized debits",
                   subtitle: "Automate payments & transfers"),
        FlowOption(icon: "arrow.up.circle.fill",
                   iconBg: Color(hex: 0x222224), iconFg: Color.white,
                   title: "Send crypto",
                   subtitle: "Bitcoin, Ethereum, or USDC"),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                flowNavBar(title: "Send", dismiss: dismiss)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(options) { FlowOptionRow(option: $0) }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
