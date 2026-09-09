# Remembered - Exhaustive Screen Inventory & State Matrix

This document provides a comprehensive inventory of every view and modal in the Remembered application, detailing their source web components, target SwiftUI views, child components, data dependencies, and failure states.

---

## 1. Broadsheet Landing Screen

* **Screen Name**: Broadsheet Chronicle Home
* **Purpose**: Primary entrance displaying the newspaper-style broadsheet masthead, retro split-flap desk calendar, headline luminary, secondary editorial columns, animal sanctuary carousel, and live memorial pulse board.
* **Source Web Component**: `BroadsheetLandingHome.tsx` + `Navbar.tsx`
* **Target SwiftUI View**: `BroadsheetHomeView.swift`
* **Sub-components**: `BroadsheetHeaderView.swift`, `RetroFlipCalendarView.swift`, `MemorialCardView.swift`, `FloatingActionDockView.swift`
* **Navigation Targets**: `MemorialDetailView` (on card tap), `SearchExploreSheet` (on search), `CreateMemorialSheet` (on plus button), `PhygitalStoreSheet` (on store link).
* **API / Data Dependencies**: `MemorialStoreViewModel.memorials`, `MemorialStoreViewModel.todayActivity`.
* **Loading State**: Shimmer placeholder skeleton matching the broadsheet card aspect ratio.
* **Empty State**: Editorial message: "No chronicles match your search query." with a "Reset Filters" action.
* **Error State**: Banner notification with an offline fallback indicator (offline cache preserves seed profiles).

---

## 2. Memorial Profile Screen (10 Core Sections)

* **Screen Name**: Full Memorial Profile Chronicle
* **Purpose**: In-depth memorial honoring a human luminary, ancestor, or animal companion across 10 structured sections.
* **Source Web Components**:
  - `HeroSection.tsx`
  - `TodaySection.tsx`
  - `BiographySection.tsx`
  - `TimelineSection.tsx`
  - `GallerySection.tsx`
  - `VoiceArchiveSection.tsx`
  - `MemoriesSection.tsx`
  - `TimeCapsuleSection.tsx`
  - `MemorialTreeDonationSection.tsx`
  - `FamilyTreeSection.tsx`
* **Target SwiftUI View**: `MemorialDetailView.swift`
* **Sub-components**: `DigitalCandleView.swift`, `MemoryLetterRowView.swift`, `TimelineItemView.swift`, `VoiceStoryRowView.swift`, `FloatingActionDockView.swift`
* **Navigation Targets**: In-page anchor scroll, `WriteTributeSheet`, `QrStonePlaqueSheet`, `PhygitalStoreSheet`.
* **API / Data Dependencies**: Active `MemorialProfile`, `AudioPlayerService` for voice clips, `RememberedAPIService` for dynamic AI enhancements.
* **Loading State**: Native `ProgressView()` while high-resolution archival imagery loads asynchronously.
* **Empty State**: Respectful empty notices for empty sections (e.g. "No voice recordings deposited yet").
* **Error State**: Failed image loads display an elegant sepia monogram placeholder.

---

## 3. Animal Companion Sanctuary Screen

* **Screen Name**: Animal Companion Sanctuary
* **Purpose**: Dedicated memorial space honoring loyal service dogs, companion cats, and national animal heroes (e.g. Hachikō).
* **Source Web Component**: `AnimalSanctuaryView.tsx`
* **Target SwiftUI View**: `AnimalSanctuaryView.swift`
* **Sub-components**: `MemorialCardView.swift`, `DigitalCandleView.swift`
* **Navigation Targets**: Push to `MemorialDetailView` for the selected animal.
* **API / Data Dependencies**: `store.animalMemorials`
* **Loading State**: Horizontal carousel skeleton placeholders.
* **Empty State**: "The sanctuary awaits your first companion dedication."
* **Error State**: Fallback to local animal seed archive.

---

## 4. Enshrine Memorial Modal (Creation Flow)

* **Screen Name**: Enshrine in Archive
* **Purpose**: Form wizard allowing family members to create a permanent memorial profile, assisted by Gemini AI for biography drafting.
* **Source Web Component**: `CreateMemorialModal.tsx`
* **Target SwiftUI View**: `CreateMemorialSheet.swift`
* **Sub-components**: Form controls, Picker, TextEditor, AI generate button with spinning indicator.
* **Navigation Targets**: Dismisses on creation and navigates to the newly minted profile.
* **API / Data Dependencies**: `RememberedAPIService.generateBiography`
* **Loading State**: Inline activity indicator ("Consulting AI Archive Assistant...").
* **Empty State**: Required field highlights for name and dates.
* **Error State**: Non-blocking toast alert if the AI service fails, allowing manual biography typing.

---

## 5. Search & Exploration Modal

* **Screen Name**: Archive Registry Search
* **Purpose**: Instant keyword searching by name, era, profession, or resting place, with category filtering.
* **Source Web Component**: `SearchExploreModal.tsx`
* **Target SwiftUI View**: `SearchExploreSheet.swift`
* **Sub-components**: Search bar, List, Row thumbnails.
* **Navigation Targets**: Tapping any result closes the sheet and navigates to `MemorialDetailView`.
* **API / Data Dependencies**: Local in-memory filter across `store.memorials`.
* **Loading State**: Immediate instant search.
* **Empty State**: "No records found matching '[query]'. Try searching by surname or century."
* **Error State**: N/A (local filter).

---

## 6. Custodian Administration Modal

* **Screen Name**: Family Custodian Administration
* **Purpose**: Allows verified family trustees to approve or delete public tribute letters, update privacy levels, and view access permissions.
* **Source Web Component**: `AdminPanelModal.tsx`
* **Target SwiftUI View**: `AdminPanelSheet.swift`
* **Sub-components**: Role verification badge, moderation list rows, privacy toggle.
* **Navigation Targets**: Dismiss sheet.
* **API / Data Dependencies**: `MemorialProfile.guardians`, `MemorialProfile.memories`.
* **Loading State**: Native list loading.
* **Empty State**: "All tribute entries have been reviewed and approved."
* **Error State**: Alert if permission validation fails.

---

## 7. Phygital Keepsakes & Store Modal

* **Screen Name**: Phygital Keepsakes & Perpetual Subscriptions
* **Purpose**: Showcase physical laser-engraved porcelain plaques, hardcover Dutch linen printed volumes, and perpetual trust subscriptions.
* **Source Web Component**: `MonetizationStoreModal.tsx`
* **Target SwiftUI View**: `PhygitalStoreSheet.swift`
* **Sub-components**: Product cards with price tags, StoreKit integration hooks.
* **Navigation Targets**: Dismiss sheet.
* **API / Data Dependencies**: In-App Purchase product catalog (StoreKit 2).
* **Loading State**: StoreKit product request loading spinner.
* **Empty State**: Fallback product catalog displaying standard pricing.
* **Error State**: StoreKit purchase cancellation or failure alert.
