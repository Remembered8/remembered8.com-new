import Foundation

public struct MemoryLetter: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var authorName: String
    public var relation: String
    public var date: String
    public var content: String
    public var photoUrl: String?
    public var audioNote: String?
    public var isApproved: Bool
    public var isHighlighted: Bool?
    public var pinned: Bool?
    
    public init(
        id: String = UUID().uuidString,
        authorName: String,
        relation: String,
        date: String = "Today",
        content: String,
        photoUrl: String? = nil,
        audioNote: String? = nil,
        isApproved: Bool = true,
        isHighlighted: Bool? = false,
        pinned: Bool? = false
    ) {
        self.id = id
        self.authorName = authorName
        self.relation = relation
        self.date = date
        self.content = content
        self.photoUrl = photoUrl
        self.audioNote = audioNote
        self.isApproved = isApproved
        self.isHighlighted = isHighlighted
        self.pinned = pinned
    }
}

public enum FamilyRelationType: String, Codable, CaseIterable, Sendable {
    case father = "father"
    case mother = "mother"
    case spouse = "spouse"
    case sibling = "sibling"
    case child = "child"
    case grandchild = "grandchild"
    case grandparent = "grandparent"
    case ancestor = "ancestor"
}

public struct FamilyNode: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var name: String
    public var relationType: FamilyRelationType
    public var relationLabel: String
    public var years: String?
    public var photo: String?
    public var linkedMemorialId: String?
    public var notes: String?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        relationType: FamilyRelationType,
        relationLabel: String,
        years: String? = nil,
        photo: String? = nil,
        linkedMemorialId: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.relationType = relationType
        self.relationLabel = relationLabel
        self.years = years
        self.photo = photo
        self.linkedMemorialId = linkedMemorialId
        self.notes = notes
    }
}

public struct TimeCapsule: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var author: String
    public var recipient: String
    public var unlockDate: String
    public var isLocked: Bool
    public var type: String // letter, audio_testament, video_confession, document
    public var contentPreview: String
    public var fullContent: String?
    public var sealedAt: String
    public var notaryVerificationCode: String?
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        author: String,
        recipient: String,
        unlockDate: String,
        isLocked: Bool = true,
        type: String = "letter",
        contentPreview: String,
        fullContent: String? = nil,
        sealedAt: String = "2026",
        notaryVerificationCode: String? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.recipient = recipient
        self.unlockDate = unlockDate
        self.isLocked = isLocked
        self.type = type
        self.contentPreview = contentPreview
        self.fullContent = fullContent
        self.sealedAt = sealedAt
        self.notaryVerificationCode = notaryVerificationCode
    }
}

public struct TreeDonation: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var donorName: String
    public var treesCount: Int
    public var organization: String
    public var message: String
    public var donatedAt: String
    public var certificateCode: String
    
    public init(
        id: String = UUID().uuidString,
        donorName: String,
        treesCount: Int = 1,
        organization: String = "World Heritage Forest Project",
        message: String,
        donatedAt: String = "Today",
        certificateCode: String = "TREE-" + String(Int.random(in: 10000...99999))
    ) {
        self.id = id
        self.donorName = donorName
        self.treesCount = treesCount
        self.organization = organization
        self.message = message
        self.donatedAt = donatedAt
        self.certificateCode = certificateCode
    }
}

public struct FamilyGuardian: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var name: String
    public var email: String
    public var role: String
    public var permissions: [String]
    public var addedDate: String
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        email: String,
        role: String = "Family Custodian",
        permissions: [String] = ["approve_memories", "edit_bio", "upload_media"],
        addedDate: String = "2026"
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.permissions = permissions
        self.addedDate = addedDate
    }
}
