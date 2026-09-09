import UIKit

/// Haptic feedback provider for solemn, tactile interactions
public enum HapticsService {
    @MainActor
    public static func candleLit() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred(intensity: 0.85)
    }
    
    @MainActor
    public static func flowerPlaced() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred(intensity: 0.6)
    }
    
    @MainActor
    public static func successConfirmation() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    @MainActor
    public static func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
