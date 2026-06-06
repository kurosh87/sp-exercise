import SwiftUI

struct AssetRowView: View {
    let asset: AssetItem

    var body: some View {
        NavigationLink(destination: AssetDetailView(asset: asset)) {
        rowContent
        }
        .buttonStyle(.plain)
    }

    private var rowContent: some View {
        HStack(spacing: 14) {
            iconView
            VStack(alignment: .leading, spacing: 5) {
                Text(asset.name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                priceRow
            }
            Spacer(minLength: 4)
            VStack(alignment: .trailing, spacing: 5) {
                Text(asset.holdings)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(asset.fiat)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.textMuted)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 96)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AppTheme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(AppTheme.stroke, lineWidth: 1)
        )
    }

    private var iconView: some View {
        Circle()
            .fill(asset.iconBackground)
            .frame(width: 50, height: 50)
            .overlay(iconContent)
    }

    @ViewBuilder
    private var iconContent: some View {
        switch asset.iconContent {
        case .text(let t):
            Text(t)
                .font(.system(size: t.count > 2 ? 13 : (t.count > 1 ? 18 : 28), weight: .bold))
                .foregroundColor(.white)
        case .symbol(let s):
            Image(systemName: s)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private var priceRow: some View {
        HStack(spacing: 6) {
            Text(asset.price)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(AppTheme.textMuted)
            HStack(spacing: 2) {
                Image(systemName: asset.isUp ? "arrow.up" : "arrow.down")
                    .font(.system(size: 12, weight: .bold))
                Text(asset.change)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
            }
            .foregroundColor(asset.isUp ? AppTheme.up : AppTheme.down)
        }
    }
}
