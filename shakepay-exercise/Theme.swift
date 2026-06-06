import SwiftUI

enum AppTheme {
    static let background = Color(hex: 0x080809)
    static let card = Color(hex: 0x131315)
    static let cardAlt = Color(hex: 0x131315)
    static let tabBar = Color(hex: 0x0C0C0E)
    static let button = Color(hex: 0x272729)
    static let stroke = Color.white.opacity(0.10)
    static let textPrimary = Color(hex: 0xF2F5FA)
    static let textMuted = Color(hex: 0x8A8A92)
    static let accentBlue = Color(hex: 0x2196FF)
    static let accentOrange = Color(hex: 0xFF5C1A)
    static let up = Color(hex: 0x30D158)
    static let down = Color(hex: 0xFF3B6B)
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
