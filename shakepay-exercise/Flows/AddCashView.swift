import SwiftUI

struct AddCashView: View {
    @Environment(\.dismiss) private var dismiss

    private let options: [FlowOption] = [
        FlowOption(icon: "arrow.left.arrow.right",
                   iconBg: Color(hex: 0x9A6E00), iconFg: Color(hex: 0xFFD700),
                   title: "Interac e-Transfer®",
                   subtitle: "Get up to $10,000 instantly"),
        FlowOption(icon: "globe.americas.fill",
                   iconBg: Color(hex: 0x222224), iconFg: Color.white,
                   title: "Wire transfer",
                   subtitle: "≥ $10,000 within 2 working days"),
        FlowOption(icon: "qrcode",
                   iconBg: Color(hex: 0x222224), iconFg: Color.white,
                   title: "Deposit crypto",
                   subtitle: "Bitcoin, Ethereum, USDC, ERC-20 tokens"),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                flowNavBar(title: "Add", dismiss: dismiss)
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
