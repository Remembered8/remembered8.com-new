# Remembered - Navigation Map & Hierarchy (iOS SwiftUI)

This document maps all user journeys, modal sheets, and transitions within the native iOS app.

---

## 1. Primary Navigation Architecture

```
Root: NavigationStack
 └── BroadsheetHomeView (New York Times Broadsheet Landing)
      │
      ├── [Tap Memorial Card] ──────> MemorialDetailView (10-Section Profile)
      │                                    │
      │                                    ├── [Tap Section / Anchor] ──> In-page Scroll
      │                                    ├── [Tap Bottom Dock "Candle"] ──> Triggers Haptic Vigil
      │                                    ├── [Tap Bottom Dock "Tribute"] ──> Sheet: WriteTributeSheet
      │                                    ├── [Tap Bottom Dock "Plaque"] ──> Sheet: QrStonePlaqueSheet
      │                                    └── [Tap Bottom Dock "Store"] ──> Sheet: PhygitalStoreSheet
      │
      ├── [Tap Sanctuary Banner] ───> AnimalSanctuaryView (Dedicated Pet Memorials)
      │
      ├── [Tap Search Icon] ────────> Sheet: SearchExploreSheet
      │                                    └── [Select Result] ──> Push to MemorialDetailView
      │
      ├── [Tap Enshrine / Plus] ────> Sheet: CreateMemorialSheet (AI-assisted creator)
      │
      ├── [Tap Custodian Admin] ────> Sheet: AdminPanelSheet
      │
      ├── [Tap Phygital Store] ─────> Sheet: PhygitalStoreSheet
      │
      ├── [Tap Live Vigil Event] ───> Sheet: LiveEventSheet
      │
      └── [Tap Social Studio] ──────> Sheet: SocialMediaStudioSheet
```

---

## 2. Modal Presentation Sheets Catalog

| Sheet Identifier | Trigger Location | Purpose | Dismiss Behavior |
| :--- | :--- | :--- | :--- |
| `createMemorial` | Broadsheet Nav Bar (+) / Floating Dock | Enshrine new civilian, historical, or pet memorial with AI assistance | Cancel / Enshrine button |
| `searchExplore` | Broadsheet Top Bar (Search) / Bottom Dock | Search by luminary, era, resting place, or tags | Close / Tap on profile |
| `adminPanel` | Navbar Shield / Profile Actions | Family custodian moderation, approving tribute letters, privacy controls | Close / Save |
| `phygitalStore` | Bottom Dock / Footer Store Link | Physical laser-engraved porcelain plaques, hardcover linen heritage volumes | Close |
| `liveEvent` | Home Pulse Board / Profile Hero | Commemorative virtual service livestream & group vigils | Dismiss |
| `digitalTributes` | Profile Today Section / Tributes Link | Sympathy floral arrangements (white roses, lilies, olive branches) | Select & Lay |
| `socialStudio` | Profile Share Button | Generate printable broadsheet obituary cards & Instagram tribute cards | Export Image / ShareSheet |

---

## 3. Deep Linking & Universal Links

* **Custom Scheme**: `remembered://memorial/{id}`
* **Universal Link**: `https://remembered.io/memorial/{id}`
* **Handling in SwiftUI**:
  ```swift
  .onOpenURL { url in
      if url.scheme == "remembered", let id = url.pathComponents.last {
          store.selectMemorial(id: id)
          navigationPath.append(AppDestination.memorialDetail(id: id))
      }
  }
  ```
