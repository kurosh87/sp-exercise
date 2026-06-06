import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Padded header block
                    VStack(spacing: 24) {
                        HeaderView()
                        BalanceHeroView()
                        ActionButtonsView()
                    }
                    .padding(.horizontal, 24)

                    // Full-width carousel (manages its own padding)
                    SetupCarouselView(cards: SampleData.setupCards)

                    // Padded asset list + lower sections
                    VStack(spacing: 24) {
                        assetList
                        ForYouSectionView(cards: SampleData.forYouCards)
                        DoMoreGridView(items: SampleData.doMoreItems)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 10)
                .padding(.bottom, 110)
            }
        }
    }

    private var assetList: some View {
        VStack(spacing: 12) {
            ForEach(SampleData.assets) { asset in
                AssetRowView(asset: asset)
            }
        }
    }
}
