# Remembered - Data Models Specification (TypeScript → Swift 6)

This document provides the complete, field-by-field mapping between the web TypeScript data models (`/src/types.ts`) and the native Swift 6 data models (`IOS_NATIVE_HANDOFF/SwiftUI/Models/`).

---

## 1. Core Profile: `MemorialProfile`

| TypeScript Field (`types.ts`) | Swift 6 Field (`MemorialProfile.swift`) | Swift Type | Nullability / Default | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `id: string` | `id: String` | `String` | Non-optional | Unique memorial identifier |
| `slug: string` | `slug: String` | `String` | Non-optional | URL & deep-link slug |
| `fullName: string` | `fullName: String` | `String` | Non-optional | Complete name of the deceased |
| `birthDate: string` | `birthDate: String` | `String` | Non-optional | Date or year of birth |
| `deathDate: string` | `deathDate: String` | `String` | Non-optional | Date or year of passing |
| `birthPlace: string` | `birthPlace: String` | `String` | Non-optional | City, region, or country of birth |
| `restingPlace: string` | `restingPlace: String` | `String` | Non-optional | Cemetery or memorial location |
| `profession: string` | `profession: String` | `String` | Non-optional | Calling, title, or honorific |
| `lifeQuote: string` | `lifeQuote: String` | `String` | Non-optional | Guiding motto or testament |
| `heroImage: string` | `heroImage: String` | `String` | Non-optional | Primary portrait URL |
| `biography: string` | `biography: String` | `String` | Non-optional | Literary life narrative |
| `candleCount: number` | `candleCount: Int` | `Int` | Default `0` | Total vigils lit in tribute |
| `visitedTodayCount: number` | `visitedTodayCount: Int` | `Int` | Default `0` | Daily visitor tally |
| `privacy: PrivacyLevel` | `privacy: PrivacyLevel` | `Enum` | Default `.public` | Access permissions |
| `category?: string` | `category: ArchiveCategory?` | `Enum?` | Optional | `.historical`, `.civilian`, `.animalCompanion` |
| `species?: string` | `species: String?` | `String?` | Optional | Animal species (Dog, Cat, etc.) |
| `breed?: string` | `breed: String?` | `String?` | Optional | Companion breed |
| `honorTitle?: string` | `honorTitle: String?` | `String?` | Optional | Honorific emblem |
| `timelineEvents: TimelineMilestone[]` | `timelineEvents: [TimelineMilestone]` | `[Struct]` | Default `[]` | Chronological life events |
| `gallery: ArchivalItem[]` | `gallery: [ArchivalItem]` | `[Struct]` | Default `[]` | Historical documents & photos |
| `audioRecordings: AudioStory[]` | `audioRecordings: [AudioStory]` | `[Struct]` | Default `[]` | Oral history recordings |
| `memories: MemoryLetter[]` | `memories: [MemoryLetter]` | `[Struct]` | Default `[]` | Tribute letters left by visitors |
| `familyTree: FamilyNode[]` | `familyTree: [FamilyNode]` | `[Struct]` | Default `[]` | Kinship and lineage graph |
| `timeCapsules?: TimeCapsule[]` | `timeCapsules: [TimeCapsule]?` | `[Struct]?` | Optional | Sealed digital wills & jubilee letters |
| `treeDonations?: TreeDonation[]` | `treeDonations: [TreeDonation]?` | `[Struct]?` | Optional | Memorial forest living dedications |

---

## 2. Milestone: `TimelineMilestone`

```swift
public struct TimelineMilestone: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var year: String
    public var date: String?
    public var title: String
    public var category: MilestoneCategory // .life, .career, .family, .travel, .creation, .milestone
    public var description: String
    public var image: String?
    public var location: String?
}
```

---

## 3. Tribute Letter: `MemoryLetter`

```swift
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
}
```

---

## 4. Oral Voice History: `AudioStory`

```swift
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
}
```

---

## 5. Living Forest: `TreeDonation`

```swift
public struct TreeDonation: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var donorName: String
    public var treesCount: Int
    public var organization: String
    public var message: String
    public var donatedAt: String
    public var certificateCode: String
}
```

---

## 6. Sealed Legacy: `TimeCapsule`

```swift
public struct TimeCapsule: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var author: String
    public var recipient: String
    public var unlockDate: String
    public var isLocked: Bool
    public var type: String
    public var contentPreview: String
    public var fullContent: String?
    public var sealedAt: String
    public var notaryVerificationCode: String?
}
```
