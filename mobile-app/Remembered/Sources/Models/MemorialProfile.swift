import Foundation

public enum PrivacyLevel: String, Codable, CaseIterable, Sendable {
    case `public` = "public"
    case familyOnly = "family_only"
    case privateLink = "private_link"
    
    public var localizedLabel: String {
        switch self {
        case .public: return "Public Archive"
        case .familyOnly: return "Family & Custodians Only"
        case .privateLink: return "Direct Passcode Link"
        }
    }
}

public enum ArchiveCategory: String, Codable, CaseIterable, Sendable {
    case historical = "historical"
    case civilian = "civilian"
    case animalCompanion = "animal_companion"
}

public struct TodayActivityItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let actor: String
    public let action: String
    public let timeAgo: String
    public let type: String // candle, memory, photo, flower, milestone, voice, tree, capsule
    
    public init(id: String = UUID().uuidString, actor: String, action: String, timeAgo: String = "Just now", type: String) {
        self.id = id
        self.actor = actor
        self.action = action
        self.timeAgo = timeAgo
        self.type = type
    }
}

public struct ImportantDateItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let date: String
    public let type: String // birthday, anniversary, special
    public let formattedDate: String
}

public struct MemorialProfile: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var slug: String
    public var fullName: String
    public var birthDate: String
    public var deathDate: String
    public var birthPlace: String
    public var restingPlace: String
    public var profession: String
    public var lifeQuote: String
    public var heroImage: String
    public var coverAccentColor: String?
    public var biography: String
    public var candleCount: Int
    public var visitedTodayCount: Int
    public var privacy: PrivacyLevel
    public var adminEmail: String
    public var isVerifiedHistoric: Bool?
    public var category: ArchiveCategory?
    public var species: String?
    public var breed: String?
    public var honorTitle: String?
    public var tier: String?
    
    public var guardians: [FamilyGuardian]?
    public var timelineEvents: [TimelineMilestone]
    public var gallery: [ArchivalItem]
    public var audioRecordings: [AudioStory]
    public var videos: [VideoStory]
    public var memories: [MemoryLetter]
    public var familyTree: [FamilyNode]
    public var timeCapsules: [TimeCapsule]?
    public var treeDonations: [TreeDonation]?
    public var importantDates: [ImportantDateItem]
    public var todayActivity: [TodayActivityItem]
    
    public init(
        id: String,
        slug: String,
        fullName: String,
        birthDate: String,
        deathDate: String,
        birthPlace: String,
        restingPlace: String,
        profession: String,
        lifeQuote: String,
        heroImage: String,
        coverAccentColor: String? = nil,
        biography: String,
        candleCount: Int = 0,
        visitedTodayCount: Int = 0,
        privacy: PrivacyLevel = .public,
        adminEmail: String = "",
        isVerifiedHistoric: Bool? = false,
        category: ArchiveCategory? = .historical,
        species: String? = nil,
        breed: String? = nil,
        honorTitle: String? = nil,
        tier: String? = "free_perpetual",
        guardians: [FamilyGuardian]? = nil,
        timelineEvents: [TimelineMilestone] = [],
        gallery: [ArchivalItem] = [],
        audioRecordings: [AudioStory] = [],
        videos: [VideoStory] = [],
        memories: [MemoryLetter] = [],
        familyTree: [FamilyNode] = [],
        timeCapsules: [TimeCapsule]? = nil,
        treeDonations: [TreeDonation]? = nil,
        importantDates: [ImportantDateItem] = [],
        todayActivity: [TodayActivityItem] = []
    ) {
        self.id = id
        self.slug = slug
        self.fullName = fullName
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.birthPlace = birthPlace
        self.restingPlace = restingPlace
        self.profession = profession
        self.lifeQuote = lifeQuote
        self.heroImage = heroImage
        self.coverAccentColor = coverAccentColor
        self.biography = biography
        self.candleCount = candleCount
        self.visitedTodayCount = visitedTodayCount
        self.privacy = privacy
        self.adminEmail = adminEmail
        self.isVerifiedHistoric = isVerifiedHistoric
        self.category = category
        self.species = species
        self.breed = breed
        self.honorTitle = honorTitle
        self.tier = tier
        self.guardians = guardians
        self.timelineEvents = timelineEvents
        self.gallery = gallery
        self.audioRecordings = audioRecordings
        self.videos = videos
        self.memories = memories
        self.familyTree = familyTree
        self.timeCapsules = timeCapsules
        self.treeDonations = treeDonations
        self.importantDates = importantDates
        self.todayActivity = todayActivity
    }
}
