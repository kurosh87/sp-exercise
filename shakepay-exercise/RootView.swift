import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0
    @State private var showProposed = false

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.background.ignoresSafeArea()
            contentView
            BottomTabBarView(selected: $selectedTab)
            if selectedTab == 0 {
                variantToggle
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Tab content

    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case 1: PlaceholderView(title: "Card", icon: "creditcard.fill")
        case 2: PlaceholderView(title: "Exchange", icon: "arrow.left.arrow.right")
        case 3: PlaceholderView(title: "Pay", icon: "dollarsign.circle.fill")
        case 4: PlaceholderView(title: "Activity", icon: "clock.fill")
        default:
            if showProposed {
                ProposedHomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
            } else {
                HomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    ))
            }
        }
    }

    // MARK: Variant toggle pill

    private var variantToggle: some View {
        HStack(spacing: 0) {
            toggleSegment(label: "Current", isActive: !showProposed) {
                withAnimation(.easeInOut(duration: 0.25)) { showProposed = false }
            }
            toggleSegment(label: "Proposed", isActive: showProposed) {
                withAnimation(.easeInOut(duration: 0.25)) { showProposed = true }
            }
        }
        .background(
            Capsule().fill(Color(hex: 0x1C1C1E))
        )
        .overlay(
            Capsule().stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .padding(.bottom, 96)
        .shadow(color: .black.opacity(0.5), radius: 12, y: 4)
    }

    private func toggleSegment(label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(isActive ? .black : AppTheme.textMuted)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    Group {
                        if isActive {
                            Capsule().fill(Color.white)
                        } else {
                            Capsule().fill(Color.clear)
                        }
                    }
                )
        }
    }
}
