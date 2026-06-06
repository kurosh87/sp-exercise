import SwiftUI

struct VariantToggle: View {
    @Binding var showProposed: Bool

    var body: some View {
        HStack(spacing: 0) {
            segment(label: "Current",  isActive: !showProposed) {
                withAnimation(.easeInOut(duration: 0.25)) { showProposed = false }
            }
            segment(label: "Proposed", isActive: showProposed) {
                withAnimation(.easeInOut(duration: 0.25)) { showProposed = true }
            }
        }
        .padding(3)
        .background(Capsule().fill(Color(hex: 0x1C1C1E)))
        .overlay(Capsule().stroke(Color.white.opacity(0.10), lineWidth: 1))
        .frame(maxWidth: .infinity)
    }

    private func segment(label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(isActive ? .black : AppTheme.textMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(Capsule().fill(isActive ? Color.white : Color.clear))
        }
        .buttonStyle(.plain)
    }
}
