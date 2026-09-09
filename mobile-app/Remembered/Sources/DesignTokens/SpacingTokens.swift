import SwiftUI

/// Design Tokens: Spacing, Insets, Borders and Corner Radii
public enum RememberedSpacing {
    public static let xxxSmall: CGFloat = 2
    public static let xxSmall: CGFloat = 4
    public static let xSmall: CGFloat = 8
    public static let small: CGFloat = 12
    public static let medium: CGFloat = 16
    public static let large: CGFloat = 24
    public static let xLarge: CGFloat = 32
    public static let xxLarge: CGFloat = 48
    
    // Corner Radius
    public static let radiusNone: CGFloat = 0
    public static let radiusSubtle: CGFloat = 3
    public static let radiusCard: CGFloat = 8
    public static let radiusPill: CGFloat = 999
    
    // Oxford Dual Border Lines
    public static let hairline: CGFloat = 1
    public static let oxfordThick: CGFloat = 2.5
}
