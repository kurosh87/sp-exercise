import SwiftUI

// MARK: - Full-screen Risk Profile placeholder (matches real Shakepay flow)

struct RiskProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: Int? = nil

    private struct Option: Identifiable {
        let id: Int
        let emoji: String
        let label: String
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
                navBar
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        questionHeader
                        optionsList
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 120)
                }
            }
            // Fixed Next button
            VStack {
                Spacer()
                nextButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.background.opacity(0), AppTheme.background],
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 120)
                        .allowsHitTesting(false)
                    )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: Nav

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            Spacer()
            Button { dismiss() } label: {
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

    // MARK: Question header

    private var questionHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What is your approximate net worth?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text("The total value of your assets minus your liabilities.")
                .font(.system(size: 16))
                .foregroundColor(AppTheme.textMuted)
        }
    }

    // MARK: Options list

    private var optionsList: some View {
        VStack(spacing: 10) {
            ForEach(options) { opt in
                optionRow(opt)
            }
        }
    }

    private func optionRow(_ opt: Option) -> some View {
        let isSelected = selected == opt.id
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) { selected = opt.id }
        } label: {
            HStack(spacing: 14) {
                Text(opt.emoji)
                    .font(.system(size: 22))
                    .frame(width: 32)
                Text(opt.label)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
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
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? AppTheme.accentBlue.opacity(0.10) : AppTheme.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? AppTheme.accentBlue.opacity(0.5) : AppTheme.stroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: Next button

    private var nextButton: some View {
        Button { dismiss() } label: {
            Text("Next")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(selected != nil ? .white : Color.white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(
                    Capsule().fill(selected != nil ? AppTheme.accentBlue : AppTheme.accentBlue.opacity(0.35))
                )
        }
        .buttonStyle(.plain)
        .disabled(selected == nil)
    }
}
