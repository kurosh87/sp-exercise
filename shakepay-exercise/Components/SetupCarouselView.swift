import SwiftUI

struct SetupCarouselView: View {
    let cards: [SetupCard]
    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing: 14) {
            TabView(selection: $currentIndex) {
                ForEach(Array(cards.enumerated()), id: \.element.id) { i, card in
                    SetupCardView(card: card)
                        .padding(.horizontal, 24)
                        .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 204)

            pageIndicator
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<cards.count, id: \.self) { i in
                Capsule()
                    .fill(i == currentIndex ? AppTheme.accentBlue : Color.white.opacity(0.25))
                    .frame(width: i == currentIndex ? 22 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
    }
}

struct SetupCardView: View {
    let card: SetupCard

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                Text(card.label)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .tracking(1.0)
                    .foregroundColor(AppTheme.textMuted)
                Text(card.headline)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
                Spacer(minLength: 0)
                ctaPill
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(card.emoji)
                .font(.system(size: 58))
                .frame(width: 76)
                .padding(.top, 4)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AppTheme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(AppTheme.stroke, lineWidth: 1)
        )
    }

    private var ctaPill: some View {
        HStack(spacing: 6) {
            Text(card.cta)
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Image(systemName: "arrow.right")
                .font(.system(size: 13, weight: .bold))
        }
        .foregroundColor(.black)
        .padding(.horizontal, 18)
        .padding(.vertical, 11)
        .background(Capsule().fill(Color(hex: 0xEDEDED)))
    }
}
