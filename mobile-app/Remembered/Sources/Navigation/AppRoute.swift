import SwiftUI

/// Type-safe Navigation Destinations for NavigationStack
public enum AppDestination: Hashable, Sendable {
    case memorialDetail(id: String)
    case animalSanctuary
    case livePulseBoard
    case institutionalHeritage
}

/// Modal Sheet Identifiers
public enum AppSheet: String, Identifiable, Sendable {
    case createMemorial
    case searchExplore
    case adminPanel
    case qrPlaque
    case monetizationStore
    case familyGuardians
    case liveEvent
    case digitalTributes
    case socialStudio
    case obituaryCard
    
    public var id: String { rawValue }
}
