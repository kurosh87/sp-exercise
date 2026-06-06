import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0

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
        case 1: PlaceholderView(title: "Card", icon: "creditcard.fill")
        case 2: PlaceholderView(title: "Exchange", icon: "arrow.left.arrow.right")
        case 3: PlaceholderView(title: "Pay", icon: "dollarsign.circle.fill")
        case 4: PlaceholderView(title: "Activity", icon: "clock.fill")
        default: HomeView()
        }
    }
}
