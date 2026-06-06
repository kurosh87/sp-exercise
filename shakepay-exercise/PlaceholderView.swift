import SwiftUI

struct PlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 56, weight: .bold))
                    .foregroundColor(AppTheme.accentBlue)
                Text(title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                Text("Coming soon")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textMuted)
            }
        }
    }
}
