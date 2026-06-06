import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack {
                avatar
                Spacer()
                streakCapsule
                settingsButton
            }
            earnButton
        }
    }

    private var avatar: some View {
        Circle()
            .fill(Color(hex: 0xF1F1F4))
            .frame(width: 44, height: 44)
            .overlay(Text("K").font(.system(size: 20, weight: .bold)).foregroundColor(.black))
    }

    private var streakCapsule: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill").font(.system(size: 14)).foregroundColor(AppTheme.textMuted)
            Text("0").font(.system(size: 16, weight: .bold)).foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .frame(height: 38)
        .background(Capsule().fill(AppTheme.button))
        .overlay(alignment: .topTrailing) {
            Circle().fill(AppTheme.accentOrange).frame(width: 9, height: 9).offset(x: 1, y: -1)
        }
    }

    private var settingsButton: some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: 17))
            .foregroundColor(.white)
            .frame(width: 38, height: 38)
            .background(Circle().fill(AppTheme.button))
    }

    private var earnButton: some View {
        Text("Earn bitcoin")
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 9)
            .background(Capsule().fill(AppTheme.accentOrange))
    }
}
