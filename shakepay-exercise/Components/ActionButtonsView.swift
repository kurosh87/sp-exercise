import SwiftUI

struct ActionButtonsView: View {
    var onAdd: (() -> Void)? = nil
    var onSend: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 14) {
            actionButton("Add",  action: onAdd)
            actionButton("Send", action: onSend)
        }
    }

    private func actionButton(_ title: String, action: (() -> Void)?) -> some View {
        Button { action?() } label: {
            Text(title)
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Capsule().fill(AppTheme.button))
        }
        .buttonStyle(.plain)
    }
}
