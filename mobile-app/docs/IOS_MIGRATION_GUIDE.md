# Remembered - iOS Xcode Migration & Integration Guide

This guide describes how to integrate the files in `IOS_NATIVE_HANDOFF/` into your existing native Xcode project for **Remembered**.

---

## 1. Prerequisites & Xcode Configuration

* **Xcode Version**: Xcode 15.3 or Xcode 16+ (Swift 6 language mode supported)
* **Minimum Deployment Target**: **iOS 17.0+** (Required for the modern `@Observable` macro and Swift concurrency async/await patterns)
* **Frameworks Used**:
  * `SwiftUI` (Declarative user interface)
  * `Observation` (Swift 6 modern reactive state management)
  * `AVFoundation` (Spoken audio playback for the Voice Archive)
  * `UIKit` (Haptics via `UIImpactFeedbackGenerator`)

---

## 2. Step-by-Step Integration into Existing Xcode Project

### Step 1: Add Swift Source Files
1. Open your existing `Remembered.xcodeproj` in Xcode.
2. In Finder, locate the `IOS_NATIVE_HANDOFF/SwiftUI/` directory.
3. Drag the following folders into your Xcode Project Navigator:
   * `Models/`
   * `ViewModels/`
   * `Views/`
   * `Components/`
   * `Services/`
   * `Navigation/`
   * `Utilities/`
   * `DesignTokens/`
4. In the Xcode dialog:
   * Check **"Copy items if needed"**
   * Select **"Create groups"**
   * Ensure your main app target (e.g. `Remembered`) is checked under **"Add to targets"**.

---

### Step 2: Import Color Tokens & Assets
1. Open your existing `Assets.xcassets` catalog inside Xcode.
2. Drag the color sets from `IOS_NATIVE_HANDOFF/Assets/Assets.xcassets/Colors.xcassets/` into your asset catalog:
   * `ParchmentBackground.colorset`
   * `InkPrimary.colorset`
   * `FlameGold.colorset`

---

### Step 3: Configure Network Permissions (Info.plist)
Because the archive loads historical photographs from verified Wikimedia Commons and public archive URLs:
1. Open your project's `Info.plist` (or Target Build Settings → Info).
2. Ensure App Transport Security allows secure HTTPS media loading (standard iOS behavior permits HTTPS by default).

---

### Step 4: Configure Backend API Base URL
In `RememberedAPIService.swift`, configure your production API gateway URL:
```swift
public final class RememberedAPIService: RememberedAPIServiceProtocol {
    public init(
        baseURL: URL = URL(string: "https://your-api-domain.com")!, // Set to your live server
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
}
```

---

### Step 5: Root View Entry Point
In your existing `@main` App file (e.g. `RememberedApp.swift`):
```swift
import SwiftUI

@main
struct RememberedApp: App {
    @State private var store = MemorialStoreViewModel()
    @State private var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                BroadsheetHomeView(store: store) { selectedMemorial in
                    navigationPath.append(AppDestination.memorialDetail(id: selectedMemorial.id))
                }
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case .memorialDetail(let id):
                        if let memorial = store.memorials.first(where: { $0.id == id }) {
                            MemorialDetailView(store: store, memorial: memorial)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}
```
