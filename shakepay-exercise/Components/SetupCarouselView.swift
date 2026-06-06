import SwiftUI

// MARK: - Carousel container

struct SetupCarouselView: View {
    let cards: [SetupCard]
    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing: 14) {
            TabView(selection: $currentIndex) {
                ForEach(Array(cards.enumerated()), id: \.element.id) { i, card in
                    SetupCardView(card: card)
                        // Side padding gives the peek-through effect on adjacent cards
                        .padding(.horizontal, 24)
                        .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .frame(height: 200)

            pageIndicator
        }
        .frame(maxWidth: .infinity)
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
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Individual card

struct SetupCardView: View {
    let card: SetupCard

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left: label + headline + CTA
            VStack(alignment: .leading, spacing: 12) {
                Text(card.label)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .foregroundColor(AppTheme.textMuted)

                Text(card.headline)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(1)

                Spacer(minLength: 0)

                ctaPill
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Right: illustrated icon
            CardIllustrationView(icon: card.icon)
                .frame(width: 72, height: 72)
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

// MARK: - Reusable illustrated icon tile

struct CardIllustrationView: View {
    let icon: CardIcon

    var body: some View {
        switch icon {
        case .sfSymbol(let name, let color):
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(color.opacity(0.13))
                    .frame(width: 68, height: 68)
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(color.opacity(0.22), lineWidth: 1)
                    .frame(width: 68, height: 68)
                Image(systemName: name)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(color)
                    .symbolRenderingMode(.hierarchical)
            }
        }
    }
}
