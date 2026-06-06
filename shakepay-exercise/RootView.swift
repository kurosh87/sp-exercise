import SwiftUI

// MARK: - Shared observable state so demo switcher on Home drives all tabs

final class AppDemoState: ObservableObject {
    @Published var preset: DemoPreset = .incompleteSetup
    var accountState: AccountState { preset.state }
}

struct RootView: View {
    @State private var selectedTab = 0
    @State private var showProposed = false
    @StateObject private var demoState = AppDemoState()

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.background.ignoresSafeArea()
            contentView
            if selectedTab != 2 {
                BottomTabBarView(selected: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case 1:
            CardView(accountState: demoState.accountState)
        case 2:
            ExchangeView(accountState: demoState.accountState, selectedTab: $selectedTab, demoState: demoState)
        case 3:
            PaymentsView()
        case 4:
            PlaceholderView(title: "Activity", icon: "clock.fill")
        default:
            if showProposed {
                ProposedHomeView(showProposed: $showProposed, demoState: demoState)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                HomeView(showProposed: $showProposed)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
    }
}
