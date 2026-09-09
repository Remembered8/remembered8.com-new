import Foundation

public enum MilestoneCategory: String, Codable, CaseIterable, Sendable {
    case life = "life"
    case career = "career"
    case family = "family"
    case travel = "travel"
    case creation = "creation"
    case milestone = "milestone"
    
    public var iconName: String {
        switch self {
        case .life: return "sparkles"
        case .career: return "briefcase"
        case .family: return "heart.fill"
        case .travel: return "globe"
        case .creation: return "paintbrush.fill"
        case .milestone: return "flag.fill"
        }
    }
}

public struct TimelineMilestone: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var year: String
    public var date: String?
    public var title: String
    public var category: MilestoneCategory
    public var description: String
    public var image: String?
    public var location: String?
    
    public init(
        id: String = UUID().uuidString,
        year: String,
        date: String? = nil,
        title: String,
        category: MilestoneCategory = .life,
        description: String,
        image: String? = nil,
        location: String? = nil
    ) {
        self.id = id
        self.year = year
        self.date = date
        self.title = title
        self.category = category
        self.description = description
        self.image = image
        self.location = location
    }
}
