import SwiftUI

/// Design Tokens: Color Palette for Remembered
/// Directly translated from Tailwind CSS variables and broadsheet newsprint design.
public enum RememberedColors {
    // Canvas & Parchment
    public static let parchmentBackground = Color(hex: 0xF8F8F5)
    public static let parchmentCard = Color(hex: 0xFAF7F2)
    public static let parchmentBorder = Color(hex: 0xD6CBB8)
    public static let parchmentMuted = Color(hex: 0xEDE5D6)
    
    // Inks & Typography
    public static let inkPrimary = Color(hex: 0x111111)
    public static let inkSecondary = Color(hex: 0x2B2724)
    public static let inkMuted = Color(hex: 0x6E6457)
    public static let inkSubtle = Color(hex: 0x8C8275)
    public static let inkDivider = Color(hex: 0x111111, opacity: 0.15)
    
    // Accents & Solemn Highlights
    public static let flameGold = Color(hex: 0xF3BE38)
    public static let flameGoldDark = Color(hex: 0xC5A059)
    public static let historicBurgundy = Color(hex: 0x800020)
    public static let forestGreen = Color(hex: 0x2D5A27)
    public static let sanctuaryTeal = Color(hex: 0x1E3A5F)
    public static let oceanBlue = Color(hex: 0x38BDF8)
    
    // Status
    public static let approvedGreen = Color(hex: 0x166534)
    public static let pendingAmber = Color(hex: 0x9A3412)
    public static let lockedGrey = Color(hex: 0x57534E)
}

public extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
