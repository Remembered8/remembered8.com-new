import SwiftUI

/// Enshrine New Memorial Profile Sheet with AI Assistant
public struct CreateMemorialSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: MemorialStoreViewModel
    @State private var aiViewModel = GeminiAiServiceViewModel()
    
    @State private var fullName: String = ""
    @State private var birthDate: String = ""
    @State private var deathDate: String = ""
    @State private var birthPlace: String = ""
    @State private var restingPlace: String = ""
    @State private var profession: String = ""
    @State private var lifeQuote: String = ""
    @State private var biography: String = ""
    @State private var heroImage: String = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&auto=format&fit=crop&q=80"
    @State private var category: ArchiveCategory = .civilian
    @State private var privacy: PrivacyLevel = .public
    @State private var notesForAi: String = ""
    
    public init(store: MemorialStoreViewModel) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("ARCHIVE CATEGORY & DIGNITY").font(.system(size: 11, design: .monospaced))) {
                    Picker("Category", selection: $category) {
                        Text("Civilian Archive").tag(ArchiveCategory.civilian)
                        Text("Historical Luminary").tag(ArchiveCategory.historical)
                        Text("Animal Companion Sanctuary").tag(ArchiveCategory.animalCompanion)
                    }
                    
                    Picker("Privacy Level", selection: $privacy) {
                        Text("Public Archive").tag(PrivacyLevel.public)
                        Text("Family Custodians Only").tag(PrivacyLevel.familyOnly)
                        Text("Private Link").tag(PrivacyLevel.privateLink)
                    }
                }
                
                Section(header: Text("VITAL RECORDS & DATES").font(.system(size: 11, design: .monospaced))) {
                    TextField("Full Name (e.g. Eleanor Vance)", text: $fullName)
                    TextField("Birth Year / Date (e.g. 1934)", text: $birthDate)
                    TextField("Passing Year / Date (e.g. 2021)", text: $deathDate)
                    TextField("Birthplace (e.g. Boston, MA)", text: $birthPlace)
                    TextField("Final Resting Place (e.g. Mount Auburn)", text: $restingPlace)
                    TextField("Life Calling / Profession (e.g. Botanist)", text: $profession)
                }
                
                Section(header: Text("AI BIOGRAPHY COMPANION").font(.system(size: 11, design: .monospaced))) {
                    TextField("Key memories, passions, family stories...", text: $notesForAi, axis: .vertical)
                        .lineLimit(3...5)
                    
                    Button(action: {
                        Task {
                            if let result = await aiViewModel.generateBiography(
                                name: fullName,
                                birthYear: birthDate,
                                deathYear: deathDate,
                                profession: profession,
                                hometown: birthPlace,
                                notes: notesForAi
                            ) {
                                self.lifeQuote = result.lifeQuote
                                self.biography = result.biography
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text(aiViewModel.isGenerating ? "Consulting AI Archive..." : "Generate Literary Biography")
                        }
                        .font(.system(size: 13, weight: .bold, design: .serif))
                    }
                    .disabled(fullName.isEmpty || aiViewModel.isGenerating)
                }
                
                Section(header: Text("LIFE MOTTO & BIOGRAPHY").font(.system(size: 11, design: .monospaced))) {
                    TextField("Life Quote / Motto", text: $lifeQuote)
                    TextEditor(text: $biography)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Enshrine in Chronicle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enshrine") {
                        let newProfile = MemorialProfile(
                            id: UUID().uuidString.lowercased(),
                            slug: fullName.lowercased().replacingOccurrences(of: " ", with: "-"),
                            fullName: fullName,
                            birthDate: birthDate,
                            deathDate: deathDate,
                            birthPlace: birthPlace,
                            restingPlace: restingPlace,
                            profession: profession,
                            lifeQuote: lifeQuote,
                            heroImage: heroImage,
                            biography: biography.isEmpty ? "A life remembered with timeless affection." : biography,
                            privacy: privacy,
                            category: category
                        )
                        store.addMemorial(profile: newProfile)
                        dismiss()
                    }
                    .disabled(fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
