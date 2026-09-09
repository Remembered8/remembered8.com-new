import SwiftUI

public extension View {
    /// Applies broadsheet card styling with fine hairline borders
    func broadsheetCardStyle() -> some View {
        self
            .background(RememberedColors.parchmentCard)
            .border(RememberedColors.parchmentBorder, width: RememberedSpacing.hairline)
    }
    
    /// Applies the Oxford dual-rule border header
    func oxfordRuleHeader() -> some View {
        VStack(spacing: 2) {
            self
            Rectangle()
                .fill(RememberedColors.inkPrimary)
                .frame(height: 2)
            Rectangle()
                .fill(RememberedColors.inkPrimary.opacity(0.3))
                .frame(height: 0.5)
        }
    }
}
