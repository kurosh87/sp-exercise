import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0
    @State private var showProposed = false

    // Shared demo account state — same across all tabs
    private let accountState = AccountState.incompleteSetup

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.background.ignoresSafeArea()
            contentView
            BottomTabBarView(selected: $selectedTab)
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case 1:
            CardView(accountState: accountState)
        case 2:
            ExchangeView(accountState: accountState)
        case 3:
            PaymentsView()
        case 4:
            PlaceholderView(title: "Activity", icon: "clock.fill")
        default:
            if showProposed {
                ProposedHomeView(showProposed: $showProposed)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                HomeView(showProposed: $showProposed)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
    }
}
