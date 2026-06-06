import SwiftUI

struct AssetInsightsView: View {
    let asset: AssetItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroIcon
                        performanceCard
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                        creditsCard
                            .padding(.horizontal, 24)
                            .padding(.top, 14)
                        debitsCard
                            .padding(.horizontal, 24)
                            .padding(.top, 14)
                        disclaimer
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 50)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: Nav

    private var navBar: some View {
        ZStack {
            Text("\(asset.name) insights")
                .font(.system(size: 18, weight: .bold))
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
            .padding(.horizontal, 12)
        }
        .frame(height: 56)
        .padding(.top, 4)
    }

    // MARK: Hero icon + balance

    private var heroIcon: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(asset.iconBackground)
                    .frame(width: 80, height: 80)
                    .overlay(assetSymbol)
                ZStack {
                    Circle().fill(AppTheme.background).frame(width: 30, height: 30)
                    Circle().fill(AppTheme.button).frame(width: 26, height: 26)
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: 4, y: 4)
            }
            Text("0.00 \(asset.symbol)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(asset.fiat)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
        }
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var assetSymbol: some View {
        switch asset.iconContent {
        case .text(let t):
            Text(t).font(.system(size: t.count > 1 ? 18 : 28, weight: .bold)).foregroundColor(.white)
        case .symbol(let s):
            Image(systemName: s).font(.system(size: 20, weight: .bold)).foregroundColor(.white)
        }
    }

    // MARK: Performance card

    private var performanceCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Performance")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 16)
            insightRow(label: "Unrealized returns", value: "$0.00")
            Divider().background(AppTheme.stroke).padding(.vertical, 2)
            insightRow(label: "Original cost", value: "$0.00")
            Divider().background(AppTheme.stroke).padding(.vertical, 2)
            insightRow(label: "Average price", value: "$0.00")
            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textMuted)
                Text("These figures are based on your current balance.")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(.top, 12)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    private func insightRow(label: String, value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 16)).foregroundColor(AppTheme.textMuted)
            Spacer()
            Text(value).font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
        }
        .padding(.vertical, 12)
    }

    // MARK: Credits / Debits

    private var creditsCard: some View {
        collapsibleCard(title: "Credits", value: "0.00 \(asset.symbol)", isExpanded: false)
    }

    private var debitsCard: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Debits").font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                Spacer()
                HStack(spacing: 6) {
                    Text("0.00 \(asset.symbol)").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                    Image(systemName: "chevron.up").font(.system(size: 13, weight: .bold)).foregroundColor(AppTheme.textMuted)
                }
            }
            .padding(20)
            Divider().background(AppTheme.stroke).padding(.horizontal, 20)
            debitRow(icon: "arrow.left.arrow.right", label: "Sell")
            Divider().background(AppTheme.stroke).padding(.horizontal, 20)
            debitRow(icon: "arrow.up.circle.fill", label: "Withdraw")
            Divider().background(AppTheme.stroke).padding(.horizontal, 20)
            debitRow(icon: "play.fill", label: "Shakepay a friend")
        }
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    private func debitRow(icon: String, label: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(AppTheme.button).frame(width: 40, height: 40)
                Image(systemName: icon).font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                Text("-").font(.system(size: 13)).foregroundColor(AppTheme.textMuted)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("0.00").font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                Text("$0").font(.system(size: 13)).foregroundColor(AppTheme.textMuted)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private func collapsibleCard(title: String, value: String, isExpanded: Bool) -> some View {
        HStack {
            Text(title).font(.system(size: 18, weight: .bold)).foregroundColor(.white)
            Spacer()
            HStack(spacing: 6) {
                Text(value).font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                Image(systemName: "chevron.down").font(.system(size: 13, weight: .bold)).foregroundColor(AppTheme.textMuted)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    // MARK: Disclaimer

    private var disclaimer: some View {
        Text("Last updated on June 5, 2026 at 4:00 PM.\nMetrics are based on available data and may not capture all individual factors or adjustments. Provided for general information only, not intended for tax or reporting purposes.")
            .font(.system(size: 12))
            .foregroundColor(AppTheme.textMuted)
            .multilineTextAlignment(.center)
    }
}
