import SwiftUI

struct DoMoreGridView: View {
    let items: [DoMoreItem]
    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Do more with Shakepay")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(items) { item in
                    DoMoreCardView(item: item)
                }
            }
        }
    }
}

struct DoMoreCardView: View {
    let item: DoMoreItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            iconView
            Spacer(minLength: 16)
            Text(item.title)
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 164, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AppTheme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(AppTheme.stroke, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var iconView: some View {
        if let gradient = item.gradient {
            Image(systemName: item.systemIcon)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(
                    LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom)
                )
        } else {
            Image(systemName: item.systemIcon)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(item.iconColor)
        }
    }
}
