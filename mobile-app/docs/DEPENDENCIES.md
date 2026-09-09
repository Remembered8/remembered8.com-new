# Remembered - iOS Dependencies & SPM Recommendations

## 1. Native First-Party Apple Frameworks (No External Pods Required)

The Remembered native SwiftUI handoff package is intentionally engineered using **100% first-party Apple SDKs** to ensure zero build bloat, fast compilation, and seamless compatibility with modern Swift 6:

| Framework | Purpose | Deployment Target |
| :--- | :--- | :--- |
| `SwiftUI` | Declarative UI, newsprint layouts, navigation, responsive grids | iOS 17.0+ |
| `Observation` | Swift 6 `@Observable` macro for high-performance reactive store state | iOS 17.0+ |
| `AVFoundation` | Spoken audio playback for the Voice Chronicle archive (`AVPlayer`) | iOS 17.0+ |
| `UIKit` / `CoreHaptics` | Solemn tactile haptic feedback (`UIImpactFeedbackGenerator`) | iOS 17.0+ |
| `Foundation` | Concurrency (`async/await`), `Codable`, `URLSession` | iOS 17.0+ |

---

## 2. Optional Recommended Swift Packages (SPM)

While the provided codebase runs completely standalone, the following optional SPM packages can be added if your team requires specialized offline caching or analytics:

1. **Kingfisher** (Optional for advanced disk/memory image caching):
   * *Repository*: `https://github.com/onevcat/Kingfisher.git`
   * *Usage*: Drop-in replacement for `AsyncImage` if high-density offline photo caching is required.
   
2. **SwiftLint** (Optional for CI/CD styling enforcement):
   * *Repository*: `https://github.com/realm/SwiftLint`
