import SwiftUI

// MARK: - Supporting types

enum OrderType: String {
    case oneTime  = "One time"
    case recurring = "Recurring buy"
    case custom   = "Custom order"

    var pillLabel: String {
        switch self {
        case .oneTime:   return "One time"
        case .recurring: return "Weekly"
        case .custom:    return "Custom"
        }
    }
}

enum ExchangeCTAState { case needsCash, needsRiskProfile, ready }

// MARK: - Asset model

struct ExchangeAsset: Identifiable, Equatable {
    let id: String
    let name: String
    let balance: String       // e.g. "$0.00" or "0 BTC"
    let balanceCAD: String?   // secondary balance line, nil if not applicable
    let iconColor: Color
    let iconSF: String?       // SF symbol name, nil if emoji
    let iconEmoji: String?    // emoji, nil if SF symbol
}

private let assetCatalog: [ExchangeAsset] = [
    ExchangeAsset(id: "cad", name: "Cash",      balance: "$0.00",   balanceCAD: nil,
                  iconColor: Color(red: 0.85, green: 0.15, blue: 0.35),
                  iconSF: nil, iconEmoji: "🍁"),
    ExchangeAsset(id: "usd", name: "US dollar", balance: "US$0.00", balanceCAD: "$0.00",
                  iconColor: Color(red: 0.2, green: 0.45, blue: 0.9),
                  iconSF: nil, iconEmoji: "🇺🇸"),
    ExchangeAsset(id: "btc", name: "Bitcoin",   balance: "0 BTC",   balanceCAD: "$0",
                  iconColor: Color(red: 0.96, green: 0.62, blue: 0.10),
                  iconSF: "bitcoinsign", iconEmoji: nil),
    ExchangeAsset(id: "eth", name: "Ethereum",  balance: "0 ETH",   balanceCAD: "$0",
                  iconColor: Color(red: 0.35, green: 0.45, blue: 0.85),
                  iconSF: "diamond.fill", iconEmoji: nil),
]

// MARK: - Asset picker sheet

struct AssetPickerSheet: View {
    @Binding var selected: ExchangeAsset
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 4)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 14)
                    .padding(.bottom, 24)

                Text("Select asset")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)

                VStack(spacing: 0) {
                    ForEach(assetCatalog) { asset in
                        assetRow(asset)
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(AppTheme.background)
        .presentationCornerRadius(32)
    }

    private func assetRow(_ asset: ExchangeAsset) -> some View {
        let isSelected = asset.id == selected.id
        return Button {
            selected = asset
            dismiss()
        } label: {
            HStack(spacing: 14) {
                assetIcon(asset, size: 44)
                VStack(alignment: .leading, spacing: 2) {
                    Text(asset.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Text(asset.balance)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textMuted)
                    if let cad = asset.balanceCAD {
                        Text(cad)
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textMuted)
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.accentBlue)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? AppTheme.card : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func assetIcon(_ asset: ExchangeAsset, size: CGFloat) -> some View {
        ZStack {
            Circle().fill(asset.iconColor).frame(width: size, height: size)
            if let emoji = asset.iconEmoji {
                Text(emoji).font(.system(size: size * 0.46))
            } else if let sf = asset.iconSF {
                Image(systemName: sf)
                    .font(.system(size: size * 0.38, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - ExchangeView

struct ExchangeView: View {
    let accountState: AccountState
    @Binding var selectedTab: Int

    init(accountState: AccountState, selectedTab: Binding<Int>) {
        self.accountState = accountState
        self._selectedTab = selectedTab
    }
    @State private var enteredAmount = ""
    @State private var orderType: OrderType = .oneTime
    @State private var showOrderSheet = false
    @State private var showPayPicker = false
    @State private var showReceivePicker = false

    @State private var payAsset: ExchangeAsset = assetCatalog[0]     // Cash
    @State private var receiveAsset: ExchangeAsset = assetCatalog[2] // Bitcoin

    private let btcRate: Double = 85_541.70

    private var numericAmount: Double { Double(enteredAmount) ?? 0 }
    private var displayAmount: String { enteredAmount.isEmpty ? "0" : enteredAmount }

    private var btcReceived: String {
        let v = numericAmount / btcRate
        return v > 0 ? String(format: "%.8f", v) : "0.00000000"
    }

    // CTA state: only evaluated when the user has typed an amount
    private var ctaState: ExchangeCTAState {
        if !accountState.riskProfileComplete { return .needsRiskProfile }
        if accountState.cashBalance == 0     { return .needsCash }
        return .ready
    }

    private var keys: [[String]] {
        [["1","2","3"],["4","5","6"],["7","8","9"],[".","0","⌫"]]
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        exchangeCards.padding(.top, 12)
                        rateLabel
                        numPad
                        ctaButton
                        Color.clear.frame(height: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showOrderSheet) { OrderTypeSheet(selected: $orderType) }
        .sheet(isPresented: $showPayPicker)  { AssetPickerSheet(selected: $payAsset) }
        .sheet(isPresented: $showReceivePicker) { AssetPickerSheet(selected: $receiveAsset) }
    }

    // MARK: - Nav bar

    private var navBar: some View {
        ZStack {
            Text("Exchange")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            HStack {
                Button { selectedTab = 0 } label: {
                    ZStack {
                        Circle().fill(AppTheme.button).frame(width: 38, height: 38)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                Button { showOrderSheet = true } label: {
                    HStack(spacing: 4) {
                        Text(orderType.pillLabel)
                            .font(.system(size: 14, weight: .bold))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1.5))
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 56)
        .padding(.top, 8)
    }

    // MARK: - Exchange cards

    private var exchangeCards: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 2) {
                payCard
                receiveCard
            }
            swapButton
        }
    }

    private var payCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pay")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.textMuted)
                    HStack(spacing: 0) {
                        Text("$")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(enteredAmount.isEmpty ? AppTheme.textMuted : .white)
                        Text(displayAmount)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                assetBadgeButton(payAsset, action: { showPayPicker = true })
            }
            HStack {
                Spacer()
                Text(payAsset.balance)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(.top, 6)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    private var receiveCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Receive")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.textMuted)
                    Text(btcReceived)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                Spacer()
                assetBadgeButton(receiveAsset, action: { showReceivePicker = true })
            }
            HStack {
                if numericAmount > 0 {
                    Text(String(format: "$%.2f", numericAmount * 0.97))
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textMuted)
                }
                Spacer()
                Text(receiveAsset.balance)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(.top, 6)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    private func assetBadgeButton(_ asset: ExchangeAsset, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                miniIcon(asset)
                Text(asset.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(AppTheme.button))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func miniIcon(_ asset: ExchangeAsset) -> some View {
        ZStack {
            Circle().fill(asset.iconColor).frame(width: 22, height: 22)
            if let emoji = asset.iconEmoji {
                Text(emoji).font(.system(size: 11))
            } else if let sf = asset.iconSF {
                Image(systemName: sf)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }

    private var swapButton: some View {
        ZStack {
            Circle().fill(AppTheme.background).frame(width: 36, height: 36)
            Circle().fill(AppTheme.card).frame(width: 30, height: 30)
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(AppTheme.textMuted)
        }
    }

    private var rateLabel: some View {
        HStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.96, green: 0.62, blue: 0.10))
                    .frame(width: 18, height: 18)
                Image(systemName: "bitcoinsign")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
            }
            Text("1 BTC = $\(btcRate, specifier: "%.2f")")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Inline blocker card (shown always — no promo here)

    @ViewBuilder
    private var blockerCard: some View {
        switch ctaState {
        case .needsCash:
            blockerTile(
                icon: "banknote.fill",
                title: "You need cash to continue",
                body: "Add funds before placing this order."
            )
        case .needsRiskProfile:
            blockerTile(
                icon: "checklist",
                title: "Complete your risk profile to buy crypto",
                body: "Required before your first crypto purchase."
            )
        case .ready:
            EmptyView()
        }
    }

    private func blockerTile(icon: String, title: String, body: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(AppTheme.accentBlue)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text(body)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppTheme.accentBlue.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.accentBlue.opacity(0.20), lineWidth: 1)
        )
    }

    // MARK: - Number pad

    private var numPad: some View {
        VStack(spacing: 4) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(row, id: \.self) { key in
                        Button { handleKey(key) } label: {
                            Group {
                                if key == "⌫" {
                                    Image(systemName: "delete.backward")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                } else {
                                    Text(key)
                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AppTheme.card)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func handleKey(_ key: String) {
        switch key {
        case "⌫":
            if !enteredAmount.isEmpty { enteredAmount.removeLast() }
        case ".":
            if !enteredAmount.contains(".") { enteredAmount += key }
        default:
            if enteredAmount == "0" { enteredAmount = key }
            else { enteredAmount += key }
        }
    }

    // MARK: - CTA button

    private var ctaButton: some View {
        Button {} label: {
            Text(ctaLabel)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Capsule().fill(AppTheme.accentBlue))
        }
        .buttonStyle(.plain)
    }

    private var ctaLabel: String {
        switch ctaState {
        case .needsCash:        return "Add cash"
        case .needsRiskProfile: return "Complete risk profile"
        case .ready:
            if enteredAmount.isEmpty { return "Review buy" }
            return "Review buy · $\(enteredAmount)"
        }
    }
}
