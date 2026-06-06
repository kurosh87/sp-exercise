import SwiftUI

struct AccountReadinessCard: View {
    let steps: [ReadinessStep]

    /// Convenience init that derives steps from live AccountState
    init(state: AccountState) {
        self.steps = [
            ReadinessStep(title: "Phone verified",        isComplete: true,                        actionLabel: nil),
            ReadinessStep(title: "Confirm email",         isComplete: state.emailConfirmed,         actionLabel: "Confirm"),
            ReadinessStep(title: "Verify identity",       isComplete: state.identityVerified,       actionLabel: "Verify"),
            ReadinessStep(title: "Complete risk profile", isComplete: state.riskProfileComplete,    actionLabel: "Start"),
            ReadinessStep(title: "Add cash",              isComplete: state.cashBalance > 0,        actionLabel: "Add cash")
        ]
    }

    private var completedCount: Int { steps.filter(\.isComplete).count }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            progressBar
                .padding(.top, 16)
            Divider()
                .background(AppTheme.stroke)
                .padding(.top, 16)
            stepList
                .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AppTheme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(AppTheme.stroke, lineWidth: 1)
        )
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Finish setting up Shakepay")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("\(completedCount) of \(steps.count) complete")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.textMuted)
            }
            Spacer()
            completionBadge
        }
    }

    private var completionBadge: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.stroke, lineWidth: 2)
                .frame(width: 44, height: 44)
            Circle()
                .trim(from: 0, to: CGFloat(completedCount) / CGFloat(steps.count))
                .stroke(AppTheme.accentBlue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(-90))
            Text("\(completedCount)/\(steps.count)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }

    // MARK: Progress bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 6)
                Capsule()
                    .fill(AppTheme.accentBlue)
                    .frame(width: geo.size.width * CGFloat(completedCount) / CGFloat(steps.count), height: 6)
                    .animation(.easeInOut(duration: 0.4), value: completedCount)
            }
        }
        .frame(height: 6)
    }

    // MARK: Step list

    private var stepList: some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                StepRow(step: step)
                if index < steps.count - 1 {
                    Divider()
                        .background(Color.white.opacity(0.06))
                        .padding(.leading, 36)
                }
            }
        }
    }
}

// MARK: - Step Row

private struct StepRow: View {
    let step: ReadinessStep

    var body: some View {
        HStack(spacing: 12) {
            statusIndicator
            Text(step.title)
                .font(.system(size: 15, weight: step.isComplete ? .semibold : .medium, design: .rounded))
                .foregroundColor(step.isComplete ? AppTheme.textMuted : .white)
                .strikethrough(step.isComplete, color: AppTheme.textMuted)
            Spacer()
            if let label = step.actionLabel, !step.isComplete {
                Text(label)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.accentBlue)
            }
        }
        .padding(.vertical, 13)
    }

    @ViewBuilder
    private var statusIndicator: some View {
        if step.isComplete {
            ZStack {
                Circle()
                    .fill(AppTheme.accentBlue.opacity(0.18))
                    .frame(width: 24, height: 24)
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(AppTheme.accentBlue)
            }
        } else {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                    .frame(width: 24, height: 24)
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 24, height: 24)
            }
        }
    }
}
