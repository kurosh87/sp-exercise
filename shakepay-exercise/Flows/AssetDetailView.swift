import SwiftUI

// MARK: - Asset Detail Screen

struct AssetDetailView: View {
    let asset: AssetItem
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter = 0
    @State private var showInsights = false
    private let filters = ["All", "Recurring buys", "Custom orders"]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroSection
                        actionButtons
                            .padding(.horizontal, 24)
                            .padding(.top, 28)
                        priceCard
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        transactionsSection
                            .padding(.top, 28)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showInsights) {
            AssetInsightsView(asset: asset)
        }
    }

    // MARK: Nav bar

    private var navBar: some View {
        ZStack {
            Text(asset.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(asset.iconBackground)
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                Spacer()
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 56)
        .padding(.top, 4)
    }

    // MARK: Hero

    private var heroSection: some View {
        VStack(spacing: 4) {
            Text("\(asset.holdings) \(asset.symbol)")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.textMuted)
            Text(asset.fiat)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(AppTheme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    // MARK: 4 action buttons

    private var actionButtons: some View {
        HStack(spacing: 12) {
            assetAction(icon: "qrcode", label: "Deposit")
            assetAction(icon: "arrow.left.arrow.right", label: "Exchange")
            assetAction(icon: "chart.bar.fill", label: "Insights") {
                showInsights = true
            }
            assetAction(icon: "arrow.up", label: "Send")
        }
    }

    private func assetAction(icon: String, label: String, action: (() -> Void)? = nil) -> some View {
        Button { action?() } label: {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppTheme.button)
                        .frame(width: 68, height: 68)
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    // MARK: Price card with sparkline

    private var priceCard: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(asset.iconBackground)
                Text(asset.symbol)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textMuted)
            }
            Spacer()
            SparklineView(isUp: asset.isUp)
                .frame(width: 100, height: 40)
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(asset.price)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                HStack(spacing: 3) {
                    Image(systemName: asset.isUp ? "arrow.up" : "arrow.down")
                        .font(.system(size: 12, weight: .bold))
                    Text(asset.change)
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(asset.isUp ? AppTheme.up : AppTheme.down)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }

    // MARK: Latest transactions

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Latest transactions")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            // Filter pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(filters.enumerated()), id: \.offset) { i, f in
                        Button { selectedFilter = i } label: {
                            Text(f)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule().fill(i == selectedFilter ? AppTheme.button : Color.clear)
                                )
                                .overlay(
                                    Capsule().stroke(i == selectedFilter ? Color.clear : AppTheme.stroke, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
            }

            emptyStateCard(for: selectedFilter)
                .padding(.horizontal, 24)
        }
    }

    @ViewBuilder
    private func emptyStateCard(for filter: Int) -> some View {
        switch filter {
        case 0:
            emptyCard(
                title: "No transactions yet",
                subtitle: "You're just a few minutes away from buying your first \(asset.name.lowercased()).",
                cta: "Verify your identity",
                icon: "🏝️"
            )
        case 1:
            emptyCard(
                title: "Buy \(asset.symbol) automatically",
                subtitle: "Daily, weekly, biweekly, or monthly",
                cta: "Create a recurring buy",
                icon: nil,
                systemIcon: "arrow.clockwise.circle.fill"
            )
        default:
            emptyCard(
                title: "Custom orders",
                subtitle: "Place a buy or sell order at a price you set",
                cta: "Create a custom order",
                icon: nil,
                systemIcon: "tag.fill"
            )
        }
    }

    private func emptyCard(title: String, subtitle: String, cta: String, icon: String?, systemIcon: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                if let emoji = icon {
                    Text(emoji).font(.system(size: 36))
                } else if let sf = systemIcon {
                    Image(systemName: sf)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(AppTheme.accentBlue)
                }
            }
            Text(cta)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Capsule().fill(AppTheme.accentBlue))
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.stroke, lineWidth: 1))
    }
}

// MARK: - Simple sparkline placeholder

struct SparklineView: View {
    let isUp: Bool
    private let points: [CGFloat] = [0.8, 0.75, 0.82, 0.70, 0.60, 0.55, 0.65, 0.50, 0.45, 0.48]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let pts = points.enumerated().map { i, v in
                CGPoint(x: CGFloat(i) / CGFloat(points.count - 1) * w, y: (1 - v) * h)
            }
            Path { path in
                guard let first = pts.first else { return }
                path.move(to: first)
                pts.dropFirst().forEach { path.addLine(to: $0) }
            }
            .stroke(AppTheme.accentBlue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}
