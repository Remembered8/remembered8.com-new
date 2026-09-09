import SwiftUI

/// Main Landing Broadsheet Newsprint Screen (SwiftUI)
public struct BroadsheetHomeView: View {
    @Bindable var store: MemorialStoreViewModel
    let onSelectMemorial: (MemorialProfile) -> Void
    
    public init(store: MemorialStoreViewModel, onSelectMemorial: @escaping (MemorialProfile) -> Void) {
        self.store = store
        self.onSelectMemorial = onSelectMemorial
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Masthead & Split-Flap Clock
                BroadsheetHeaderView(
                    onOpenSearch: { store.isSearchSheetPresented = true },
                    onOpenCreate: { store.isCreateSheetPresented = true }
                )
                
                // Search Quick Bar & Filter Chips
                searchAndFilterBar
                
                // Lead Chronicle Article (Headline Luminary)
                if let lead = store.memorials.first {
                    leadArticleView(lead)
                        .padding(.horizontal, 16)
                }
                
                // Secondary Broadsheet Columns
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("CHRONICLES & NOTABLE LUMINARIES")
                            .font(.system(size: 13, weight: .black, design: .monospaced))
                            .foregroundColor(RememberedColors.inkPrimary)
                        Spacer()
                        Text("\(store.filteredMemorials.count) ARCHIVED")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(RememberedColors.inkMuted)
                    }
                    .padding(.horizontal, 16)
                    
                    LazyVStack(spacing: 16) {
                        ForEach(store.filteredMemorials.dropFirst()) { memorial in
                            MemorialCardView(memorial: memorial) {
                                onSelectMemorial(memorial)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                
                // Animal Companion Sanctuary Carousel
                animalSanctuarySection
                
                // Live Pulse Board Preview
                livePulseBoardSection
                
                // Footer Manifesto
                footerManifestoView
            }
            .padding(.bottom, 80)
        }
        .background(RememberedColors.parchmentBackground)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { store.isSearchSheetPresented = true }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(RememberedColors.inkPrimary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { store.isCreateSheetPresented = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Enshrine")
                    }
                    .font(.system(size: 13, weight: .bold, design: .serif))
                    .foregroundColor(RememberedColors.inkPrimary)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var searchAndFilterBar: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(RememberedColors.inkMuted)
                TextField("Search luminary, era, resting place...", text: $store.searchQuery)
                    .font(.system(size: 14, design: .serif))
            }
            .padding(10)
            .background(RememberedColors.parchmentCard)
            .border(RememberedColors.parchmentBorder, width: 1)
            .padding(.horizontal, 16)
            
            // Category Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryChip(title: "All Chronicles", isSelected: store.selectedCategoryFilter == nil) {
                        store.selectedCategoryFilter = nil
                    }
                    categoryChip(title: "Historical", isSelected: store.selectedCategoryFilter == .historical) {
                        store.selectedCategoryFilter = .historical
                    }
                    categoryChip(title: "Civilian", isSelected: store.selectedCategoryFilter == .civilian) {
                        store.selectedCategoryFilter = .civilian
                    }
                    categoryChip(title: "Animal Sanctuary", isSelected: store.selectedCategoryFilter == .animalCompanion) {
                        store.selectedCategoryFilter = .animalCompanion
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func categoryChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(isSelected ? .white : RememberedColors.inkPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? RememberedColors.inkPrimary : RememberedColors.parchmentCard)
                .border(RememberedColors.parchmentBorder, width: 1)
        }
    }
    
    private func leadArticleView(_ memorial: MemorialProfile) -> some View {
        MemorialCardView(memorial: memorial) {
            onSelectMemorial(memorial)
        }
    }
    
    private var animalSanctuarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("THE ANIMAL COMPANION SANCTUARY")
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundColor(RememberedColors.inkPrimary)
                    Text("Devoted friends, heroic canines and beloved companions")
                        .font(.system(size: 11, weight: .regular, design: .serif))
                        .foregroundColor(RememberedColors.inkMuted)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(store.animalMemorials) { animal in
                        MemorialCardView(memorial: animal) {
                            onSelectMemorial(animal)
                        }
                        .frame(width: 280)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 16)
        .background(Color(hex: 0xF4EFE6))
    }
    
    private var livePulseBoardSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("LIVE MEMORIAL PULSE • REVERENCE IN MOTION")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(RememberedColors.inkPrimary)
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 8) {
                ForEach(store.currentMemorial.todayActivity.prefix(4)) { activity in
                    HStack {
                        Image(systemName: activity.type == "candle" ? "flame.fill" : "heart.fill")
                            .font(.system(size: 11))
                            .foregroundColor(RememberedColors.flameGoldDark)
                        Text("**\(activity.actor)** \(activity.action)")
                            .font(.system(size: 12, design: .serif))
                            .foregroundColor(RememberedColors.inkSecondary)
                        Spacer()
                        Text(activity.timeAgo)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(RememberedColors.inkMuted)
                    }
                    .padding(8)
                    .background(RememberedColors.parchmentCard)
                    .border(RememberedColors.parchmentBorder, width: 0.5)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var footerManifestoView: some View {
        VStack(spacing: 12) {
            Divider()
            Text("REMEMBERED PERPETUAL ARCHIVE")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            Text("A sacred, enduring digital chronicle for extraordinary lives and beloved companions. Designed with reverence, literary dignity, and Swiss-editorial precision.")
                .font(.system(size: 12, weight: .regular, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundColor(RememberedColors.inkMuted)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 24)
    }
}
