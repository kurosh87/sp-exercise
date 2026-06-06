import SwiftUI

struct HomeView: View {
    @State private var showAdd  = false
    @State private var showSend = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        VStack(spacing: 24) {
                            HeaderView()
                            BalanceHeroView()
                            ActionButtonsView(
                                onAdd:  { showAdd  = true },
                                onSend: { showSend = true }
                            )
                        }
                        .padding(.horizontal, 24)

                        SetupCarouselView(cards: SampleData.setupCards)

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
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showAdd)  { AddCashView() }
            .navigationDestination(isPresented: $showSend) { SendView() }
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
