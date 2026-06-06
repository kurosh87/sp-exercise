import SwiftUI

// MARK: - Shared data model for flow option rows

struct FlowOption: Identifiable {
    let id = UUID()
    let icon: String
    let iconBg: Color
    let iconFg: Color
    let title: String
    let subtitle: String
}

// MARK: - Row view matching the Shakepay Send/Add screens

struct FlowOptionRow: View {
    let option: FlowOption

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                // Icon tile
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(option.iconBg)
                        .frame(width: 54, height: 54)
                    Image(systemName: option.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(option.iconFg)
                        .symbolRenderingMode(.hierarchical)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Text(option.subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.textMuted)
                }

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(AppTheme.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(AppTheme.stroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
