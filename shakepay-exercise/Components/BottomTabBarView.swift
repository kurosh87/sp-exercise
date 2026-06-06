import SwiftUI

struct BottomTabBarView: View {
    @Binding var selected: Int

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(height: 1)
            HStack(alignment: .bottom, spacing: 0) {
                tabItem(index: 0, icon: "house.fill")
                tabItem(index: 1, icon: "creditcard")
                exchangeSlot
                tabItem(index: 3, icon: "dollarsign")
                tabItem(index: 4, icon: "clock")
            }
            .padding(.top, 10)
            .padding(.bottom, 4)
            .background(AppTheme.tabBar.ignoresSafeArea(edges: .bottom))
        }
    }

    private func tabItem(index: Int, icon: String) -> some View {
        Button { selected = index } label: {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(selected == index ? AppTheme.accentBlue : Color(hex: 0x6E6E75))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
        }
    }

    private var exchangeSlot: some View {
        Button { selected = 2 } label: {
            ZStack {
                Circle()
                    .fill(AppTheme.accentBlue)
                    .frame(width: 58, height: 58)
                    .shadow(color: AppTheme.accentBlue.opacity(0.4), radius: 10, y: 4)
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .offset(y: -10)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
    }
}
