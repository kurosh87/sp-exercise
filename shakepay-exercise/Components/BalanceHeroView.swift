import SwiftUI

struct BalanceHeroView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("$0")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
                .tracking(-1)
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
