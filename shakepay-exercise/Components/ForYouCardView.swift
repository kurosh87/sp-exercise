import SwiftUI

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
            .frame(height: 216)
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

struct ForYouCardView: View {
    let card: ForYouCard

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(card.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text(card.body)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.80))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
                ctaPill
            }
            VStack {
                illustration
                Spacer()
            }
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
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .padding(16)
        }
    }

    private var illustration: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(card.illustrationColor)
            .frame(width: 100, height: 110)
            .overlay(Text(card.emoji).font(.system(size: 46)))
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
