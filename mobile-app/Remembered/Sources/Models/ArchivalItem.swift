import Foundation

public struct ArchivalItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var url: String
    public var caption: String
    public var year: String?
    public var location: String?
    public var isDocument: Bool?
    public var category: String?
    
    public init(
        id: String = UUID().uuidString,
        url: String,
        caption: String,
        year: String? = nil,
        location: String? = nil,
        isDocument: Bool? = false,
        category: String? = nil
    ) {
        self.id = id
        self.url = url
        self.caption = caption
        self.year = year
        self.location = location
        self.isDocument = isDocument
        self.category = category
    }
}

public struct AudioStory: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var year: String?
    public var duration: String
    public var description: String
    public var audioUrl: String?
    public var transcript: String?
    public var speakerRelation: String?
    public var isAiEnhanced: Bool?
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        year: String? = nil,
        duration: String,
        description: String,
        audioUrl: String? = nil,
        transcript: String? = nil,
        speakerRelation: String? = nil,
        isAiEnhanced: Bool? = false
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.description = description
        self.audioUrl = audioUrl
        self.transcript = transcript
        self.speakerRelation = speakerRelation
        self.isAiEnhanced = isAiEnhanced
    }
}

public struct VideoStory: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var duration: String
    public var thumbnail: String
    public var year: String?
    public var description: String?
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        duration: String,
        thumbnail: String,
        year: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.title = title
        self.duration = duration
        self.thumbnail = thumbnail
        self.year = year
        self.description = description
    }
}
