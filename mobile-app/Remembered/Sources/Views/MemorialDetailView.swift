import SwiftUI

/// Complete Memorial Profile View (SwiftUI)
public struct MemorialDetailView: View {
    @Bindable var store: MemorialStoreViewModel
    let memorial: MemorialProfile
    
    @State private var newTributeAuthor: String = ""
    @State private var newTributeRelation: String = ""
    @State private var newTributeContent: String = ""
    @State private var isWritingTribute: Bool = false
    
    public init(store: MemorialStoreViewModel, memorial: MemorialProfile) {
        self.store = store
        self.memorial = memorial
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24) {
                    // 1. Hero Section & Candle
                    heroSection
                    
                    // 2. Today's Remembrance & Flower Laying
                    todayRemembranceSection
                    
                    // 3. Biography
                    biographySection
                    
                    // 4. Chronological Timeline
                    timelineSection
                    
                    // 5. Archival Gallery
                    gallerySection
                    
                    // 6. Oral Voice Archive
                    voiceArchiveSection
                    
                    // 7. Tribute Letters Register
                    tributeLettersSection
                    
                    // 8. Sealed Time Capsules
                    timeCapsulesSection
                    
                    // 9. Memorial Forest & Trees
                    treeForestSection
                    
                    // 10. Family Lineage Tree
                    familyTreeSection
                }
                .padding(.bottom, 96)
            }
            .background(RememberedColors.parchmentBackground)
            
            // Floating Ergonomic Action Dock
            FloatingActionDockView(
                hasLitCandle: store.hasLitCandleToday,
                onLightCandle: { store.lightCandle() },
                onWriteMemory: { isWritingTribute = true },
                onOpenQr: { store.isQrSheetPresented = true },
                onOpenStore: { store.isStoreSheetPresented = true }
            )
            .padding(.bottom, 16)
        }
        .navigationTitle(memorial.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isWritingTribute) {
            writeTributeSheet
        }
    }
    
    // MARK: - 1. Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: memorial.heroImage)) { phase in
                switch phase {
                case .success(let img):
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipped()
                default:
                    Rectangle()
                        .fill(RememberedColors.parchmentMuted)
                        .frame(height: 280)
                }
            }
            .border(RememberedColors.parchmentBorder, width: 1)
            
            VStack(spacing: 8) {
                Text("\(memorial.birthDate) — \(memorial.deathDate)")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(RememberedColors.inkMuted)
                
                Text(memorial.fullName)
                    .font(.system(size: 32, weight: .black, design: .serif))
                    .foregroundColor(RememberedColors.inkPrimary)
                    .multilineTextAlignment(.center)
                
                Text(memorial.profession)
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .foregroundColor(RememberedColors.inkSecondary)
                
                if !memorial.lifeQuote.isEmpty {
                    Text("“\(memorial.lifeQuote)”")
                        .font(.system(size: 14, weight: .medium, design: .serif).italic())
                        .foregroundColor(RememberedColors.inkMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                }
                
                // Candle Vigils Action
                DigitalCandleView(
                    candleCount: memorial.candleCount,
                    hasLit: store.hasLitCandleToday,
                    onLight: { store.lightCandle() }
                )
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - 2. Today's Remembrance
    private var todayRemembranceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TODAY'S REVERENCE & FLOWERS")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(RememberedColors.inkPrimary)
                Spacer()
                Text("\(memorial.visitedTodayCount) visitors today")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(RememberedColors.inkMuted)
            }
            
            HStack(spacing: 12) {
                flowerButton(title: "White Rose", icon: "suit.heart.fill") {
                    store.addFlowerTribute(flowerName: "White Rose")
                }
                flowerButton(title: "Lily", icon: "sparkles") {
                    store.addFlowerTribute(flowerName: "Pure White Lily")
                }
                flowerButton(title: "Olive Branch", icon: "leaf.fill") {
                    store.addFlowerTribute(flowerName: "Olive Branch of Peace")
                }
            }
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    private func flowerButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(RememberedColors.parchmentBackground)
            .border(RememberedColors.parchmentBorder, width: 1)
            .foregroundColor(RememberedColors.inkPrimary)
        }
    }
    
    // MARK: - 3. Biography
    private var biographySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("BIOGRAPHICAL CHRONICLE")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            
            Text(memorial.biography)
                .font(.system(size: 15, weight: .regular, design: .serif))
                .lineSpacing(6)
                .foregroundColor(RememberedColors.inkSecondary)
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - 4. Timeline
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CHRONOLOGICAL MILESTONES")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            
            VStack(spacing: 8) {
                ForEach(memorial.timelineEvents) { milestone in
                    TimelineItemView(milestone: milestone)
                }
            }
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - 5. Archival Gallery
    private var gallerySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PHOTOGRAPHIC & DOCUMENT REGISTRY")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(memorial.gallery) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            AsyncImage(url: URL(string: item.url)) { phase in
                                switch phase {
                                case .success(let img):
                                    img
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 160, height: 160)
                                        .clipped()
                                default:
                                    Rectangle()
                                        .fill(RememberedColors.parchmentMuted)
                                        .frame(width: 160, height: 160)
                                }
                            }
                            .border(RememberedColors.parchmentBorder, width: 1)
                            
                            Text(item.caption)
                                .font(.system(size: 11, design: .serif))
                                .foregroundColor(RememberedColors.inkSecondary)
                                .lineLimit(2)
                                .frame(width: 160, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - 6. Voice Archive
    private var voiceArchiveSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ORAL HISTORY & VOICE TESTAMENTS")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            
            if memorial.audioRecordings.isEmpty {
                Text("No voice recordings yet deposited in this registry.")
                    .font(.system(size: 13, design: .serif).italic())
                    .foregroundColor(RememberedColors.inkMuted)
            } else {
                VStack(spacing: 8) {
                    ForEach(memorial.audioRecordings) { story in
                        VoiceStoryRowView(story: story)
                    }
                }
            }
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - 7. Tribute Letters
    private var tributeLettersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TRIBUTE LETTERS & MEMORIES")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(RememberedColors.inkPrimary)
                Spacer()
                Button("Leave Tribute") {
                    isWritingTribute = true
                }
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            }
            
            VStack(spacing: 12) {
                ForEach(memorial.memories) { letter in
                    MemoryLetterRowView(letter: letter)
                }
            }
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - 8. Time Capsules
    private var timeCapsulesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SEALED TIME CAPSULES & WILLS")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            
            if let capsules = memorial.timeCapsules, !capsules.isEmpty {
                ForEach(capsules) { capsule in
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(RememberedColors.flameGoldDark)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(capsule.title)
                                .font(.system(size: 13, weight: .bold, design: .serif))
                            Text("Unlocks on \(capsule.unlockDate) for \(capsule.recipient)")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(RememberedColors.inkMuted)
                        }
                    }
                    .padding(10)
                    .background(RememberedColors.parchmentBackground)
                    .border(RememberedColors.parchmentBorder, width: 1)
                }
            } else {
                Text("All family testaments sealed until specified jubilee years.")
                    .font(.system(size: 12, design: .serif).italic())
                    .foregroundColor(RememberedColors.inkMuted)
            }
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - 9. Trees Forest
    private var treeForestSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("LIVING MEMORIAL FOREST")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(RememberedColors.inkPrimary)
                Spacer()
                Image(systemName: "tree.fill")
                    .foregroundColor(Color(hex: 0x2D5A27))
            }
            Text("Trees planted in perpetuity in honor of \(memorial.fullName). Each sapling breathes life across generations.")
                .font(.system(size: 13, design: .serif))
                .foregroundColor(RememberedColors.inkSecondary)
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - 10. Family Tree
    private var familyTreeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FAMILY LINEAGE & KINSHIP")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(RememberedColors.inkPrimary)
            
            if memorial.familyTree.isEmpty {
                Text("Lineage custodian records available to verified family descendants.")
                    .font(.system(size: 12, design: .serif).italic())
                    .foregroundColor(RememberedColors.inkMuted)
            } else {
                VStack(spacing: 8) {
                    ForEach(memorial.familyTree) { node in
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(RememberedColors.inkMuted)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(node.name)
                                    .font(.system(size: 13, weight: .bold, design: .serif))
                                Text(node.relationLabel)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(RememberedColors.inkMuted)
                            }
                            Spacer()
                        }
                        .padding(8)
                        .background(RememberedColors.parchmentBackground)
                        .border(RememberedColors.parchmentBorder, width: 1)
                    }
                }
            }
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Write Tribute Sheet
    private var writeTributeSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Your Name & Kinship").font(.system(size: 11, design: .monospaced))) {
                    TextField("Full Name (e.g., Granddaughter Maria)", text: $newTributeAuthor)
                    TextField("Relationship (e.g., Lifelong Student)", text: $newTributeRelation)
                }
                
                Section(header: Text("Your Written Memory").font(.system(size: 11, design: .monospaced))) {
                    TextEditor(text: $newTributeContent)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Leave Memory Letter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isWritingTribute = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Deposit") {
                        if !newTributeContent.isEmpty {
                            store.addMemoryLetter(
                                author: newTributeAuthor.isEmpty ? "A Loving Relative" : newTributeAuthor,
                                relation: newTributeRelation.isEmpty ? "Friend" : newTributeRelation,
                                content: newTributeContent
                            )
                            isWritingTribute = false
                        }
                    }
                    .disabled(newTributeContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
