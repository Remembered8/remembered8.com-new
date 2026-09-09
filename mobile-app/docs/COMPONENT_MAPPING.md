# Remembered - Web to Native SwiftUI Component Mapping

This document details the exact mapping from every React/TypeScript web component to its native Swift 6 / SwiftUI counterpart, including state management, data dependencies, and interaction paradigms.

---

## Complete Mapping Matrix

| Web Component (`src/components/`) | Native SwiftUI Target (`IOS_NATIVE_HANDOFF/SwiftUI/`) | Data Dependencies | Key Interactions & Gestures |
| :--- | :--- | :--- | :--- |
| `BroadsheetLandingHome.tsx` | `Views/BroadsheetHomeView.swift` | `[MemorialProfile]`, `searchQuery`, `categoryFilter` | Vertical scroll, filter chip taps, lead article card tap |
| `Navbar.tsx` | `Components/BroadsheetHeaderView.swift` + Native `.toolbar` | Active memorial, language state | Search button, Enshrine button, brand title tap |
| `HeroSection.tsx` | `Components/DigitalCandleView.swift` + `MemorialDetailView.heroSection` | `MemorialProfile.candleCount`, `heroImage` | Tap to light candle (haptic trigger), write tribute button |
| `TodaySection.tsx` | `MemorialDetailView.todayRemembranceSection` | `todayActivity`, `visitedTodayCount` | Flower tribute buttons (White Rose, Lily, Olive Branch) |
| `BiographySection.tsx` | `MemorialDetailView.biographySection` | `MemorialProfile.biography` | Read literary bio, trigger AI refresh via custodian action |
| `TimelineSection.tsx` | `Components/TimelineItemView.swift` | `[TimelineMilestone]` | Chronological vertical inspection, category badges |
| `GallerySection.tsx` | `MemorialDetailView.gallerySection` | `[ArchivalItem]` | Horizontal archival carousel, tap to zoom full-screen |
| `VoiceArchiveSection.tsx` | `Components/VoiceStoryRowView.swift` | `[AudioStory]`, `AudioPlayerService` | Play / pause toggle, playback progress bar |
| `MemoriesSection.tsx` | `Components/MemoryLetterRowView.swift` | `[MemoryLetter]` | Read parchment letters, tap to pin/highlight |
| `TimeCapsuleSection.tsx` | `MemorialDetailView.timeCapsulesSection` | `[TimeCapsule]` | View unlock countdowns, notary sealed indicators |
| `MemorialTreeDonationSection.tsx` | `MemorialDetailView.treeForestSection` | `[TreeDonation]` | Dedicate memorial tree, view certificate codes |
| `FamilyTreeSection.tsx` | `MemorialDetailView.familyTreeSection` | `[FamilyNode]` | Kinship nodes, tap related member to switch chronicle |
| `AnimalSanctuaryView.tsx` | `Views/BroadsheetHomeView.animalSanctuarySection` | `store.animalMemorials` | Horizontal swipe through companion memorials |
| `CreateMemorialModal.tsx` | `Views/CreateMemorialSheet.swift` | `GeminiAiServiceViewModel` | Form input, "Generate Biography with AI" async call |
| `SearchExploreModal.tsx` | `Views/SearchExploreSheet.swift` | `filteredMemorials` | Instant query typing, category selector |
| `AdminPanelModal.tsx` | `Views/AdminPanelSheet.swift` | `MemorialProfile.guardians`, `memories` | Approve/reject tribute letters, toggle privacy settings |
| `MonetizationStoreModal.tsx` | `Views/PhygitalStoreSheet.swift` | StoreKit 2 Products | In-App purchase or physical order redirect |
| `FooterManifesto.tsx` | `Views/BroadsheetHomeView.footerManifestoView` | None (Static) | Read perpetual archival manifesto & principles |
| Floating Action Pill (Mobile) | `Components/FloatingActionDockView.swift` | `hasLitCandle` | Quick action buttons: Candle, Tribute, Plaque, Store |
