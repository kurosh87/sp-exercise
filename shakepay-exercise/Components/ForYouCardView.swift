import SwiftUI

// MARK: - Section container

struct ForYouSectionView: View {
    let cards: [ForYouCard]
    @State private var index = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("For you")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            TabView(selection: $index) {
                ForEach(Array(cards.enumerated()), id: \.element.id) { i, card in
                    ForYouCardView(card: card)
                        .padding(.horizontal, 2)
                        .tag(i)
                }
            }
            .frame(height: 200)
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(0..<cards.count, id: \.self) { i in
                    Capsule()
                        .fill(i == index ? AppTheme.accentBlue : Color.white.opacity(0.25))
                        .frame(width: i == index ? 22 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: index)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Individual "For you" card

struct ForYouCardView: View {
    let card: ForYouCard

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left: text + CTA
            VStack(alignment: .leading, spacing: 10) {
                Text(card.title)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(card.body)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.white.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(1.5)

                Spacer(minLength: 0)

                ctaPill
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Right: illustration tile
            illustrationTile
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AppTheme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(AppTheme.stroke, lineWidth: 1)
        )
        .overlay(alignment: .topTrailing) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .padding(16)
        }
    }

    private var illustrationTile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(card.illustrationColor)
                .frame(width: 104, height: 112)

            illustrationIcon
        }
        .padding(.top, 2)
    }

    @ViewBuilder
    private var illustrationIcon: some View {
        switch card.icon {
        case .sfSymbol(let name, let color):
            Image(systemName: name)
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(color)
                .symbolRenderingMode(.hierarchical)
        }
    }

    private var ctaPill: some View {
        HStack(spacing: 6) {
            Text(card.cta)
                .font(.system(size: 15, weight: .bold))
            Image(systemName: "arrow.right")
                .font(.system(size: 12, weight: .bold))
        }
        .foregroundColor(.black)
        .padding(.horizontal, 20)
        .padding(.vertical, 11)
        .background(Capsule().fill(Color(hex: 0xE8E8EA)))
    }
}
