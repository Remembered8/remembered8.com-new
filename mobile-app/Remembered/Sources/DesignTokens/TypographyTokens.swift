import SwiftUI

/// Design Tokens: Typography for Remembered (Swift 6 / SwiftUI)
/// Matches New York Times broadsheet serif display pairing with SF Pro & SF Mono.
public enum RememberedTypography {
    // Broadsheet Display Titles (Serif - New York or system serif)
    public static func broadsheetTitle(size: CGFloat = 34) -> Font {
        .system(size: size, weight: .black, design: .serif)
    }
    
    public static func mastheadHero(size: CGFloat = 48) -> Font {
        .system(size: size, weight: .heavy, design: .serif)
    }
    
    public static func sectionHeading(size: CGFloat = 22) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }
    
    public static func cardHeadline(size: CGFloat = 18) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }
    
    // Body & Literary Storytelling (Serif)
    public static func editorialBody(size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .serif)
    }
    
    public static func lifeQuote(size: CGFloat = 17) -> Font {
        .system(size: size, weight: .medium, design: .serif).italic()
    }
    
    // Archival Metadata, Datelines, Split-Flap Clock (Monospaced - SF Mono)
    public static func datelineMono(size: CGFloat = 11) -> Font {
        .system(size: size, weight: .bold, design: .monospaced)
    }
    
    public static func splitFlapNumber(size: CGFloat = 14) -> Font {
        .system(size: size, weight: .heavy, design: .monospaced)
    }
    
    public static func badgeTag(size: CGFloat = 10) -> Font {
        .system(size: size, weight: .bold, design: .monospaced)
    }
}
