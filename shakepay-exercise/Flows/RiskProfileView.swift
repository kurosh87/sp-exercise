import SwiftUI

// MARK: - Two-step Risk Profile flow

struct RiskProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step = 1
    @State private var netWorthSelection: Int? = nil
    @State private var experienceSelection: Int? = nil

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            if step == 1 {
                NetWorthStep(selected: $netWorthSelection) {
                    withAnimation(.easeInOut(duration: 0.25)) { step = 2 }
                } onClose: { dismiss() }
            } else {
                ExperienceStep(selected: $experienceSelection) {
                    dismiss() // Done — in prod would mark riskProfileComplete = true
                } onBack: {
                    withAnimation(.easeInOut(duration: 0.25)) { step = 1 }
                } onClose: { dismiss() }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Step 1: Net worth

private struct NetWorthStep: View {
    @Binding var selected: Int?
    let onNext: () -> Void
    let onClose: () -> Void

    private struct Option: Identifiable {
        let id: Int; let emoji: String; let label: String
    }
    private let options: [Option] = [
        Option(id: 0, emoji: "🤑", label: "Less than $50k"),
        Option(id: 1, emoji: "💵", label: "$50k – $100k"),
        Option(id: 2, emoji: "💰", label: "$100k – $250k"),
        Option(id: 3, emoji: "🏛️", label: "$250k – $500k"),
        Option(id: 4, emoji: "🏦", label: "$500k – $750k"),
        Option(id: 5, emoji: "🤑", label: "$750k – $1M"),
        Option(id: 6, emoji: "🤑", label: "More than $1M"),
    ]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                stepNavBar(onBack: nil, onClose: onClose, step: 1, total: 2)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        questionHeader(
                            title: "What is your approximate net worth?",
                            subtitle: "The total value of your assets minus your liabilities."
                        )
                        VStack(spacing: 10) {
                            ForEach(options) { opt in
                                optionRow(id: opt.id, emoji: opt.emoji, label: opt.label,
                                          selected: $selected)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 120)
                }
            }
            bottomCTA(label: "Next", enabled: selected != nil, action: onNext)
        }
    }
}

// MARK: - Step 2: Investment experience

private struct ExperienceStep: View {
    @Binding var selected: Int?
    let onNext: () -> Void
    let onBack: () -> Void
    let onClose: () -> Void

    private struct Option: Identifiable {
        let id: Int; let emoji: String; let label: String; let subtitle: String
    }
    private let options: [Option] = [
        Option(id: 0, emoji: "🌱", label: "No experience",    subtitle: "I'm new to investing"),
        Option(id: 1, emoji: "📖", label: "Some experience",  subtitle: "I've made a few trades"),
        Option(id: 2, emoji: "📈", label: "Experienced",      subtitle: "I invest regularly"),
        Option(id: 3, emoji: "🧠", label: "Very experienced", subtitle: "I'm a seasoned investor"),
    ]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                stepNavBar(onBack: onBack, onClose: onClose, step: 2, total: 2)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        questionHeader(
                            title: "What is your investment experience?",
                            subtitle: "How familiar are you with buying and selling financial assets?"
                        )
                        VStack(spacing: 10) {
                            ForEach(options) { opt in
                                optionRowWithSubtitle(id: opt.id, emoji: opt.emoji,
                                                     label: opt.label, subtitle: opt.subtitle,
                                                     selected: $selected)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 120)
                }
            }
            bottomCTA(label: "Done", enabled: selected != nil, action: onNext)
        }
    }
}

// MARK: - Shared sub-views

private func stepNavBar(onBack: (() -> Void)?, onClose: @escaping () -> Void, step: Int, total: Int) -> some View {
    HStack {
        if let onBack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
        } else {
            Color.clear.frame(width: 44, height: 44)
        }
        Spacer()
        // Step indicator dots
        HStack(spacing: 6) {
            ForEach(1...total, id: \.self) { i in
                Capsule()
                    .fill(i == step ? AppTheme.accentBlue : Color.white.opacity(0.2))
                    .frame(width: i == step ? 20 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: step)
            }
        }
        Spacer()
        Button(action: onClose) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
        }
    }
    .padding(.horizontal, 12)
    .frame(height: 56)
    .padding(.top, 8)
}

private func questionHeader(title: String, subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text(title)
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
        Text(subtitle)
            .font(.system(size: 16))
            .foregroundColor(AppTheme.textMuted)
    }
}

private func optionRow(id: Int, emoji: String, label: String, selected: Binding<Int?>) -> some View {
    let isSelected = selected.wrappedValue == id
    return Button {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        withAnimation(.easeInOut(duration: 0.15)) { selected.wrappedValue = id }
    } label: {
        HStack(spacing: 14) {
            Text(emoji).font(.system(size: 22)).frame(width: 32)
            Text(label)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            checkBox(isSelected: isSelected)
        }
        .padding(.horizontal, 18).padding(.vertical, 18)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(isSelected ? AppTheme.accentBlue.opacity(0.10) : AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(isSelected ? AppTheme.accentBlue.opacity(0.5) : AppTheme.stroke, lineWidth: 1))
    }
    .buttonStyle(.plain)
}

private func optionRowWithSubtitle(id: Int, emoji: String, label: String, subtitle: String, selected: Binding<Int?>) -> some View {
    let isSelected = selected.wrappedValue == id
    return Button {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        withAnimation(.easeInOut(duration: 0.15)) { selected.wrappedValue = id }
    } label: {
        HStack(spacing: 14) {
            Text(emoji).font(.system(size: 22)).frame(width: 32)
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textMuted)
            }
            Spacer()
            checkBox(isSelected: isSelected)
        }
        .padding(.horizontal, 18).padding(.vertical, 18)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(isSelected ? AppTheme.accentBlue.opacity(0.10) : AppTheme.card))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(isSelected ? AppTheme.accentBlue.opacity(0.5) : AppTheme.stroke, lineWidth: 1))
    }
    .buttonStyle(.plain)
}

private func checkBox(isSelected: Bool) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .stroke(isSelected ? AppTheme.accentBlue : Color.white.opacity(0.25), lineWidth: 2)
            .frame(width: 26, height: 26)
        if isSelected {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(AppTheme.accentBlue)
                .frame(width: 14, height: 14)
        }
    }
}

private func bottomCTA(label: String, enabled: Bool, action: @escaping () -> Void) -> some View {
    VStack {
        Spacer()
        Button(action: action) {
            Text(label)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(enabled ? .white : Color.white.opacity(0.35))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Capsule().fill(enabled ? AppTheme.accentBlue : AppTheme.accentBlue.opacity(0.3)))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    .background(
        LinearGradient(colors: [AppTheme.background.opacity(0), AppTheme.background],
                       startPoint: .top, endPoint: .bottom)
        .frame(height: 130).allowsHitTesting(false),
        alignment: .bottom
    )
}
