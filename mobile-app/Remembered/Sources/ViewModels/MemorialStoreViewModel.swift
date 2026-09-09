import SwiftUI
import Observation

/// Main State Store for Remembered (Swift 6 Observation)
@Observable
@MainActor
public final class MemorialStoreViewModel {
    public var memorials: [MemorialProfile] = []
    public var currentMemorialId: String = "albert-einstein"
    public var searchQuery: String = ""
    public var selectedCategoryFilter: ArchiveCategory? = nil
    public var hasLitCandleToday: Bool = false
    
    // UI presentation states
    public var isCreateSheetPresented: Bool = false
    public var isSearchSheetPresented: Bool = false
    public var isAdminSheetPresented: Bool = false
    public var isQrSheetPresented: Bool = false
    public var isStoreSheetPresented: Bool = false
    public var isLiveEventSheetPresented: Bool = false
    public var isTributesSheetPresented: Bool = false
    public var isHeritageSheetPresented: Bool = false
    public var isSocialStudioSheetPresented: Bool = false
    public var isObituarySheetPresented: Bool = false
    
    public init() {
        loadPersistedOrSeedData()
    }
    
    public var currentMemorial: MemorialProfile {
        if let found = memorials.first(where: { $0.id == currentMemorialId }) {
            return found
        }
        return memorials.first ?? SeedMemorialData.initialMemorials[0]
    }
    
    public var filteredMemorials: [MemorialProfile] {
        var results = memorials
        if let cat = selectedCategoryFilter {
            results = results.filter { $0.category == cat }
        }
        if !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let q = searchQuery.lowercased()
            results = results.filter {
                $0.fullName.lowercased().contains(q) ||
                $0.profession.lowercased().contains(q) ||
                $0.restingPlace.lowercased().contains(q)
            }
        }
        return results
    }
    
    public var animalMemorials: [MemorialProfile] {
        memorials.filter { $0.category == .animalCompanion }
    }
    
    public var historicalMemorials: [MemorialProfile] {
        memorials.filter { $0.category == .historical }
    }
    
    // MARK: - Core Interactions
    
    public func selectMemorial(id: String) {
        currentMemorialId = id
        HapticsService.selectionChanged()
    }
    
    public func lightCandle() {
        guard let index = memorials.firstIndex(where: { $0.id == currentMemorialId }) else { return }
        hasLitCandleToday = true
        memorials[index].candleCount += 1
        memorials[index].visitedTodayCount += 1
        
        let newAct = TodayActivityItem(
            actor: "A Reverent Visitor",
            action: "silently lit a perpetual memorial candle.",
            type: "candle"
        )
        memorials[index].todayActivity.insert(newAct, at: 0)
        HapticsService.candleLit()
        persistData()
    }
    
    public func addFlowerTribute(flowerName: String) {
        guard let index = memorials.firstIndex(where: { $0.id == currentMemorialId }) else { return }
        memorials[index].visitedTodayCount += 1
        
        let newAct = TodayActivityItem(
            actor: "A Visitor",
            action: "placed a \(flowerName) in solemn tribute.",
            type: "candle"
        )
        memorials[index].todayActivity.insert(newAct, at: 0)
        HapticsService.flowerPlaced()
        persistData()
    }
    
    public func addMemoryLetter(author: String, relation: String, content: String) {
        guard let index = memorials.firstIndex(where: { $0.id == currentMemorialId }) else { return }
        let letter = MemoryLetter(
            authorName: author,
            relation: relation,
            date: "Today",
            content: content,
            isApproved: true
        )
        memorials[index].memories.insert(letter, at: 0)
        
        let newAct = TodayActivityItem(
            actor: author,
            action: "contributed a memory letter to the registry.",
            type: "memory"
        )
        memorials[index].todayActivity.insert(newAct, at: 0)
        HapticsService.successConfirmation()
        persistData()
    }
    
    public func addMemorial(profile: MemorialProfile) {
        memorials.insert(profile, at: 0)
        currentMemorialId = profile.id
        HapticsService.successConfirmation()
        persistData()
    }
    
    // MARK: - Persistence
    
    private let storageKey = "remembered_ios_memorials_v1"
    
    private func persistData() {
        do {
            let data = try JSONEncoder().encode(memorials)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to persist memorials: \(error)")
        }
    }
    
    private func loadPersistedOrSeedData() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([MemorialProfile].self, from: data),
           !saved.isEmpty {
            self.memorials = saved
        } else {
            self.memorials = SeedMemorialData.initialMemorials
        }
    }
}
