import SwiftUI

struct OrderTypeSheet: View {
    @Binding var selected: OrderType
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                // Handle
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 4)
                    .padding(.top, 14)
                    .padding(.bottom, 24)

                Text("Order type")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                VStack(spacing: 12) {
                    orderRow(
                        type: .oneTime,
                        icon: "arrow.left.arrow.right",
                        iconColor: .white,
                        title: "One time action",
                        subtitle: "Buy or sell at current price",
                        badge: nil
                    )
                    orderRow(
                        type: .recurring,
                        icon: "calendar",
                        iconColor: AppTheme.accentBlue,
                        title: "Recurring buy",
                        subtitle: "Buy automatically on a daily, weekly, bi-weekly, or monthly schedule",
                        badge: "No spread, no fees on BTC"
                    )
                    orderRow(
                        type: .custom,
                        icon: "chart.line.downtrend.xyaxis",
                        iconColor: AppTheme.accentBlue,
                        title: "Custom order",
                        subtitle: "Buy or sell when a target price is reached",
                        badge: nil
                    )
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationBackground(AppTheme.background)
        .presentationCornerRadius(32)
    }

    private func orderRow(
        type: OrderType,
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        badge: String?
    ) -> some View {
        let isSelected = selected == type
        return Button {
            selected = type
            dismiss()
        } label: {
            HStack(alignment: .top, spacing: 14) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(AppTheme.button)
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                // Text content
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textMuted)
                        .fixedSize(horizontal: false, vertical: true)
                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(AppTheme.accentOrange))
                            .padding(.top, 2)
                    }
                }

                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? AppTheme.card : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? AppTheme.accentBlue.opacity(0.45) : AppTheme.stroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
