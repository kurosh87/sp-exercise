import SwiftUI

struct ProposedHomeView: View {
    @State private var demoPreset: DemoPreset = .incompleteSetup
    @State private var showAdd  = false
    @State private var showSend = false

    private var accountState: AccountState { demoPreset.state }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Demo switcher
                        DemoStateSwitcher(preset: $demoPreset)
                            .padding(.horizontal, 24)
                            .padding(.top, 4)

                        // Header + hero + state-aware actions + readiness card
                        VStack(spacing: 24) {
                            HeaderView()
                            ProposedBalanceHero(balanceText: demoPreset.balanceDisplay)
                            StateAwareActionAreaView(
                                state: accountState,
                                onAdd:  { showAdd  = true },
                                onSend: { showSend = true }
                            )
                            AccountReadinessCard(state: accountState)
                        }
                        .padding(.horizontal, 24)

                        // Asset list + lower sections
                        VStack(spacing: 24) {
                            assetList
                            ForYouSectionView(cards: SampleData.forYouCards)
                            DoMoreGridView(items: SampleData.doMoreItems)
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 6)
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

// MARK: - Balance hero with dynamic text

struct ProposedBalanceHero: View {
    let balanceText: String

    var body: some View {
        VStack(spacing: 8) {
            Text(balanceText)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
                .tracking(-1)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: balanceText)
            HStack(spacing: 6) {
                Text("Cash balance")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
