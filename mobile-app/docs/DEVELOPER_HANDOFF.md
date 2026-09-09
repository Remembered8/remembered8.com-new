# Remembered - Native iOS Developer Handoff

## 1. Executive Summary & Design Vision

Welcome to the **Remembered iOS Native Developer Handoff Package**.

This package translates the finalized, production-grade **Remembered Memory & Chronicle Platform** into a clean, modular, and idiomatic **Swift 6 + SwiftUI** codebase tailored for integration into your existing Xcode project.

The visual and functional philosophy is preserved with precision:
* **Editorial Broadsheet Aesthetics**: Typographic dignity inspired by classic newspaper mastheads, Oxford dual-rule border dividers, warm parchment neutrals (`#F8F8F5`), and dark ink (`#111111`).
* **Tactile Interactions**: Mechanical split-flap desk calendar, gentle glowing digital memorial candles with CoreHaptics feedback, and letterhead tribute registers.
* **10-Section Memorial Profile**: Complete coverage of Vital Records, Today's Vigil Activity, Literary Biography, Chronological Timeline, Archival Photo Registry, Oral Voice History, Tribute Letters, Sealed Time Capsules, Living Forest Tree Dedications, and Family Lineage Trees.

---

## 2. Directory Structure of the Handoff Package

```
IOS_NATIVE_HANDOFF/
├── SwiftUI/
│   ├── Models/               # Swift 6 Codable & Sendable data models (Profile, Timeline, etc.)
│   ├── ViewModels/           # Swift 6 @Observable stores (MemorialStoreViewModel, AI service)
│   ├── Views/                # Full screen views (BroadsheetHomeView, MemorialDetailView, etc.)
│   ├── Components/           # Modular widgets (Candle, Card, Header, Calendar, Dock, etc.)
│   ├── Services/             # Networking (async/await), AVPlayer audio, CoreHaptics
│   ├── Navigation/           # NavigationStack destination & sheet enums
│   └── Utilities/            # View modifiers and Oxford rule helpers
├── DesignTokens/             # Swift Color, Typography, and Spacing constants
├── Assets/                   # Assets.xcassets catalogs (Parchment, Ink, Gold color sets)
├── API_SPEC.md               # Complete backend REST and Gemini AI endpoints spec
├── DATA_MODELS.md            # TypeScript-to-Swift 6 model dictionary
├── NAVIGATION_MAP.md         # Full hierarchy of screens, push routes, and modal sheets
├── SCREEN_INVENTORY.md       # Exhaustive screen-by-screen inventory with states
├── COMPONENT_MAPPING.md      # Exact 1:1 mapping from React components to SwiftUI views
├── IOS_MIGRATION_GUIDE.md    # Integration instructions for your existing Xcode project
├── DEPENDENCIES.md           # Zero third-party dependency architecture breakdown
├── ENVIRONMENT_VARIABLES.example # Backend secrets configuration
└── IOS_MIGRATION_COMPLETENESS_REPORT.md # Audit verification report
```

---

## 3. Engineering & Architecture Principles

1. **Pure Swift 6 & Modern SwiftUI**:
   * Uses `@Observable` from Apple's `Observation` framework (no legacy `ObservableObject` / `@Published` needed for stores).
   * Fully thread-safe with `@MainActor` isolation and `Sendable` model structs.
2. **Zero CocoaPods / SPM Dependency Overhead**:
   * Built 100% on native Apple SDKs (`SwiftUI`, `Observation`, `AVFoundation`, `UIKit`).
3. **Offline & Test-Ready Out of the Box**:
   * Bundles `SeedMemorialData.swift` with verified historic luminaries (Albert Einstein, Barış Manço, Mustafa Kemal Atatürk, and Hachikō) so you can build and run tests immediately without waiting for server deployment.
4. **Strict Security Separation**:
   * Private Gemini API keys and cloud secrets remain securely on the backend server. The iOS client communicates with your authenticated API gateway via clean async/await service protocols.
