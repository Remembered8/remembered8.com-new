import SwiftUI

/// Search and Exploration Sheet View
public struct SearchExploreSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: MemorialStoreViewModel
    let onSelect: (MemorialProfile) -> Void
    
    public init(store: MemorialStoreViewModel, onSelect: @escaping (MemorialProfile) -> Void) {
        self.store = store
        self.onSelect = onSelect
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Search Input Field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(RememberedColors.inkMuted)
                    TextField("Search by name, profession, city, or era...", text: $store.searchQuery)
                        .font(.system(size: 15, design: .serif))
                    if !store.searchQuery.isEmpty {
                        Button(action: { store.searchQuery = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(RememberedColors.inkMuted)
                        }
                    }
                }
                .padding(12)
                .background(RememberedColors.parchmentCard)
                .border(RememberedColors.parchmentBorder, width: 1)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                // Results List
                List {
                    ForEach(store.filteredMemorials) { memorial in
                        Button(action: {
                            onSelect(memorial)
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: memorial.heroImage)) { phase in
                                    switch phase {
                                    case .success(let img):
                                        img.resizable().aspectRatio(contentMode: .fill)
                                    default:
                                        Rectangle().fill(RememberedColors.parchmentMuted)
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .clipped()
                                .border(RememberedColors.parchmentBorder, width: 1)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(memorial.fullName)
                                        .font(.system(size: 15, weight: .bold, design: .serif))
                                        .foregroundColor(RememberedColors.inkPrimary)
                                    Text(memorial.profession)
                                        .font(.system(size: 12, design: .serif))
                                        .foregroundColor(RememberedColors.inkSecondary)
                                    Text("\(memorial.birthDate) — \(memorial.deathDate)")
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundColor(RememberedColors.inkMuted)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(RememberedColors.inkMuted)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .background(RememberedColors.parchmentBackground)
            .navigationTitle("Archive Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

/// Admin Custodian Moderation Panel Sheet
public struct AdminPanelSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: MemorialStoreViewModel
    
    public init(store: MemorialStoreViewModel) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section(header: Text("FAMILY CUSTODIANSHIP & ROLES").font(.system(size: 11, design: .monospaced))) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Archive Custodian")
                                .font(.system(size: 14, weight: .bold, design: .serif))
                            Text(store.currentMemorial.adminEmail.isEmpty ? "custodian@remembered.io" : store.currentMemorial.adminEmail)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(RememberedColors.inkMuted)
                        }
                        Spacer()
                        Text("Verified Trustee")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(RememberedColors.approvedGreen)
                    }
                }
                
                Section(header: Text("TRIBUTE LETTERS TO MODERATE").font(.system(size: 11, design: .monospaced))) {
                    if store.currentMemorial.memories.isEmpty {
                        Text("No pending tributes. All archive entries in good standing.")
                            .font(.system(size: 13, design: .serif).italic())
                            .foregroundColor(RememberedColors.inkMuted)
                    } else {
                        ForEach(store.currentMemorial.memories) { letter in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(letter.authorName) (\(letter.relation))")
                                    .font(.system(size: 13, weight: .bold, design: .serif))
                                Text(letter.content)
                                    .font(.system(size: 12, design: .serif))
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Section(header: Text("PRIVACY ENFORCEMENT").font(.system(size: 11, design: .monospaced))) {
                    HStack {
                        Text("Current Privacy Level")
                        Spacer()
                        Text(store.currentMemorial.privacy.localizedLabel)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(RememberedColors.inkMuted)
                    }
                }
            }
            .navigationTitle("Custodian Administration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

/// Phygital Store & Subscriptions Sheet
public struct PhygitalStoreSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Bronze / Porcelain Plaque
                    plaqueOptionCard(
                        title: "Laser-Engraved Titanium Porcelain Plaque",
                        subtitle: "Weatherproof QR code embedded in heritage granite or marble",
                        price: "€149 One-Time",
                        icon: "qrcode"
                    )
                    
                    // Linen Printed Book
                    plaqueOptionCard(
                        title: "Archival Hardcover Heritage Volume",
                        subtitle: "Deluxe Dutch linen binding of complete biography, voice transcripts, and high-res gallery",
                        price: "€89 / Book",
                        icon: "book.closed.fill"
                    )
                    
                    // Dynasty Archive Plan
                    plaqueOptionCard(
                        title: "Dynasty Archive Perpetual Trust",
                        subtitle: "100-year immutable cryptographic hosting, unlimited audio testaments, and up to 10 family custodian seats",
                        price: "€290 Perpetual",
                        icon: "crown.fill"
                    )
                }
                .padding(16)
            }
            .background(RememberedColors.parchmentBackground)
            .navigationTitle("Perpetual Store & Keepsakes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func plaqueOptionCard(title: String, subtitle: String, price: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(RememberedColors.flameGoldDark)
                Spacer()
                Text(price)
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(RememberedColors.inkPrimary)
            }
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(RememberedColors.inkPrimary)
            Text(subtitle)
                .font(.system(size: 13, design: .serif))
                .foregroundColor(RememberedColors.inkSecondary)
        }
        .padding(16)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
    }
}
