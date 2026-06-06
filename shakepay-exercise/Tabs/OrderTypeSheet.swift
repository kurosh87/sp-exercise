import SwiftUI

// MARK: - Order type sheet (top level)

struct OrderTypeSheet: View {
    @Binding var selected: OrderType
    @Environment(\.dismiss) private var dismiss
    @State private var showFrequency = false
    @State private var showCustom = false

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                handle
                Text("Order type")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                VStack(spacing: 12) {
                    orderRow(
                        icon: "arrow.left.arrow.right", iconColor: .white,
                        title: "One time action",
                        subtitle: "Buy or sell at current price",
                        badge: nil,
                        isSelected: selected == .oneTime
                    ) {
                        selected = .oneTime
                        dismiss()
                    }

                    orderRow(
                        icon: "calendar", iconColor: AppTheme.accentBlue,
                        title: "Recurring buy",
                        subtitle: "Buy automatically on a daily, weekly, bi-weekly, or monthly schedule",
                        badge: "No spread, no fees on BTC",
                        isSelected: selected == .recurring
                    ) {
                        showFrequency = true
                    }

                    orderRow(
                        icon: "chart.line.downtrend.xyaxis", iconColor: AppTheme.accentBlue,
                        title: "Custom order",
                        subtitle: "Buy or sell when a target price is reached",
                        badge: nil,
                        isSelected: selected == .custom
                    ) {
                        showCustom = true
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationBackground(AppTheme.background)
        .presentationCornerRadius(32)
        .sheet(isPresented: $showFrequency) {
            FrequencyPickerSheet(selected: $selected, dismiss: { dismiss() })
        }
        .sheet(isPresented: $showCustom) {
            CustomOrderSheet(selected: $selected, dismiss: { dismiss() })
        }
    }

    private var handle: some View {
        Capsule()
            .fill(Color.white.opacity(0.15))
            .frame(width: 36, height: 4)
            .padding(.top, 14)
            .padding(.bottom, 24)
    }

    private func orderRow(
        icon: String, iconColor: Color,
        title: String, subtitle: String,
        badge: String?,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle().fill(AppTheme.button).frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textMuted)
                        .fixedSize(horizontal: false, vertical: true)
                    if let badge {
                        Text(badge)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(Capsule().fill(AppTheme.accentOrange))
                            .padding(.top, 2)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(badge != nil || icon == "calendar" || icon == "chart.line.downtrend.xyaxis"
                                     ? AppTheme.textMuted : Color.clear)
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(isSelected ? AppTheme.card : Color.clear))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(isSelected ? AppTheme.accentBlue.opacity(0.45) : AppTheme.stroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Frequency picker (Recurring sub-sheet)

struct FrequencyPickerSheet: View {
    @Binding var selected: OrderType
    let dismiss: () -> Void
    @Environment(\.dismiss) private var sheetDismiss

    private struct Frequency: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
    }

    private let options: [Frequency] = [
        Frequency(title: "Daily",     subtitle: "Every day, starting today"),
        Frequency(title: "Weekly",    subtitle: "Every week, starting today"),
        Frequency(title: "Bi-weekly", subtitle: "Every two weeks, starting today"),
        Frequency(title: "Monthly",   subtitle: "Every month, starting today"),
    ]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 4)
                    .padding(.top, 14)
                    .padding(.bottom, 20)

                HStack {
                    Button { sheetDismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                    }
                    Spacer()
                    Text("Choose frequency")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                VStack(spacing: 0) {
                    ForEach(options) { opt in
                        Button {
                            selected = .recurring
                            sheetDismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { dismiss() }
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(AppTheme.accentBlue.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(AppTheme.accentBlue)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(opt.title)
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(opt.subtitle)
                                        .font(.system(size: 14))
                                        .foregroundColor(AppTheme.textMuted)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                        }
                        .buttonStyle(.plain)

                        if opt.id != options.last?.id {
                            Divider().background(AppTheme.stroke).padding(.leading, 78)
                        }
                    }
                }
                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationBackground(AppTheme.background)
        .presentationCornerRadius(32)
    }
}

// MARK: - Custom order sub-sheet

struct CustomOrderSheet: View {
    @Binding var selected: OrderType
    let dismiss: () -> Void
    @Environment(\.dismiss) private var sheetDismiss

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 4)
                    .padding(.top, 14)
                    .padding(.bottom, 20)

                HStack {
                    Button { sheetDismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                    }
                    Spacer()
                    Text("Custom order type")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                VStack(spacing: 0) {
                    customRow(
                        icon: "chart.line.downtrend.xyaxis",
                        title: "Custom buy",
                        subtitle: "Buy when a target price is reached"
                    )
                    Divider().background(AppTheme.stroke).padding(.leading, 78)
                    customRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Custom sell",
                        subtitle: "Sell when a target price is reached"
                    )
                }
                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationBackground(AppTheme.background)
        .presentationCornerRadius(32)
    }

    private func customRow(icon: String, title: String, subtitle: String) -> some View {
        Button {
            selected = .custom
            sheetDismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { dismiss() }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppTheme.accentBlue.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.accentBlue)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textMuted)
                }
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }
}
