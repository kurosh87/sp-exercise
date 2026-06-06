import SwiftUI

struct ProposedHomeView: View {
    @State private var demoPreset: DemoPreset = .incompleteSetup

    private var accountState: AccountState { demoPreset.state }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // Demo switcher — subtle, prototype-only
                    DemoStateSwitcher(preset: $demoPreset)
                        .padding(.horizontal, 24)
                        .padding(.top, 4)

                    // Header + hero + state-aware actions
                    VStack(spacing: 24) {
                        HeaderView()
                        ProposedBalanceHero(balanceText: demoPreset.balanceDisplay)
                        StateAwareActionAreaView(state: accountState)
                        AccountReadinessCard(steps: SampleData.readinessSteps)
                    }
                    .padding(.horizontal, 24)

                    // Full-width carousel removed in Proposed — readiness card replaces it

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
    }

    private var assetList: some View {
        VStack(spacing: 12) {
            ForEach(SampleData.assets) { asset in
                AssetRowView(asset: asset)
            }
        }
    }
}

// Balance hero that accepts dynamic balance text
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
