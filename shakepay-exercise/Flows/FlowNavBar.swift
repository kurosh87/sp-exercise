import SwiftUI

/// Shared custom nav bar for full-screen flow screens (Send, Add, etc.)
func flowNavBar(title: String, dismiss: DismissAction) -> some View {
    FlowNavBarView(title: title, dismiss: dismiss)
}

struct FlowNavBarView: View {
    let title: String
    let dismiss: DismissAction

    var body: some View {
        ZStack {
            // Centered title
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            HStack {
                // Back button
                Button { dismiss() } label: {
                    ZStack {
                        Circle()
                            .fill(AppTheme.button)
                            .frame(width: 38, height: 38)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 56)
        .padding(.top, 8)
    }
}
