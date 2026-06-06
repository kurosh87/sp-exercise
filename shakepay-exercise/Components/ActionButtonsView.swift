import SwiftUI

struct ActionButtonsView: View {
    var body: some View {
        HStack(spacing: 14) {
            actionButton("Add")
            actionButton("Send")
        }
    }

    private func actionButton(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 19, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(Capsule().fill(AppTheme.button))
    }
}
