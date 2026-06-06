import SwiftUI

struct AddCashView: View {
    @Environment(\.dismiss) private var dismiss

    private let options: [FlowOption] = [
        FlowOption(icon: "arrow.left.arrow.right", iconBg: Color(hex: 0xB8860B).opacity(0.9), iconFg: Color(hex: 0xFFD700),
                   title: "Interac e-Transfer®",   subtitle: "Get up to $10,000 instantly"),
        FlowOption(icon: "globe.americas.fill",    iconBg: Color(hex: 0x2A2A2D), iconFg: .white,
                   title: "Wire transfer",          subtitle: "≥ $10,000 within 2 working days"),
        FlowOption(icon: "qrcode",                 iconBg: Color(hex: 0x2A2A2D), iconFg: .white,
                   title: "Deposit crypto",         subtitle: "Bitcoin, Ethereum, USDC, ERC-20 tokens"),
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
            Text("Add")
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
