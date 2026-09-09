import SwiftUI
import Observation

/// ViewModel bridging AI features from the backend to SwiftUI views
@Observable
@MainActor
public final class GeminiAiServiceViewModel {
    public var isGenerating: Bool = false
    public var errorMessage: String? = nil
    
    private let apiService: RememberedAPIServiceProtocol
    
    public init(apiService: RememberedAPIServiceProtocol = RememberedAPIService.shared) {
        self.apiService = apiService
    }
    
    public func generateBiography(
        name: String,
        birthYear: String?,
        deathYear: String?,
        profession: String?,
        hometown: String?,
        notes: String?
    ) async -> (lifeQuote: String, biography: String)? {
        isGenerating = true
        errorMessage = nil
        defer { isGenerating = false }
        
        let req = BiographyGenerationRequest(
            name: name,
            birthYear: birthYear,
            deathYear: deathYear,
            profession: profession,
            hometown: hometown,
            memories: notes
        )
        
        do {
            let res = try await apiService.generateBiography(request: req)
            return (res.lifeQuote, res.biography)
        } catch {
            self.errorMessage = "Unable to connect to AI archive assistant. Please verify network or try again."
            return nil
        }
    }
    
    public func polishMemoryLetter(
        personName: String,
        relation: String,
        rawText: String
    ) async -> String? {
        isGenerating = true
        errorMessage = nil
        defer { isGenerating = false }
        
        let req = EnhanceMemoryRequest(
            personName: personName,
            relation: relation,
            rawMemory: rawText
        )
        
        do {
            let res = try await apiService.enhanceMemory(request: req)
            return res.enhancedText
        } catch {
            self.errorMessage = "Failed to enhance memory."
            return nil
        }
    }
}
