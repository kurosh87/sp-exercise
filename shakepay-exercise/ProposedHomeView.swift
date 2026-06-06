import SwiftUI

struct ProposedHomeView: View {
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HeaderView()
                    BalanceHeroView()
                    ActionButtonsView()
                    AccountReadinessCard(steps: SampleData.readinessSteps)
                    assetList
                    ForYouSectionView(cards: SampleData.forYouCards)
                    DoMoreGridView(items: SampleData.doMoreItems)
                }
                .padding(.horizontal, 24)
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
