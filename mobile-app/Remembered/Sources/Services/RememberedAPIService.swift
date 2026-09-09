import Foundation

/// Protocol defining backend communication for Remembered iOS
public protocol RememberedAPIServiceProtocol: Sendable {
    func checkHealth() async throws -> HealthCheckResponse
    func generateBiography(request: BiographyGenerationRequest) async throws -> BiographyGenerationResponse
    func extractTimeline(request: TimelineExtractionRequest) async throws -> TimelineExtractionResponse
    func enhanceMemory(request: EnhanceMemoryRequest) async throws -> EnhanceMemoryResponse
    func analyzePhoto(request: PhotoAnalysisRequest) async throws -> PhotoAnalysisResponse
}

// MARK: - DTO Requests & Responses

public struct HealthCheckResponse: Codable, Sendable {
    public let status: String
    public let service: String
    public let time: String
}

public struct BiographyGenerationRequest: Codable, Sendable {
    public let name: String
    public let birthYear: String?
    public let deathYear: String?
    public let profession: String?
    public let hometown: String?
    public let memories: String?
    public let tone: String?
    
    public init(name: String, birthYear: String? = nil, deathYear: String? = nil, profession: String? = nil, hometown: String? = nil, memories: String? = nil, tone: String? = nil) {
        self.name = name
        self.birthYear = birthYear
        self.deathYear = deathYear
        self.profession = profession
        self.hometown = hometown
        self.memories = memories
        self.tone = tone
    }
}

public struct BiographyGenerationResponse: Codable, Sendable {
    public let lifeQuote: String
    public let biography: String
    public let suggestedMilestones: [SuggestedMilestone]?
    
    public struct SuggestedMilestone: Codable, Sendable {
        public let year: String
        public let title: String
        public let description: String
    }
}

public struct TimelineExtractionRequest: Codable, Sendable {
    public let personName: String
    public let rawStory: String
    
    public init(personName: String, rawStory: String) {
        self.personName = personName
        self.rawStory = rawStory
    }
}

public struct TimelineExtractionResponse: Codable, Sendable {
    public let milestones: [TimelineMilestone]
}

public struct EnhanceMemoryRequest: Codable, Sendable {
    public let personName: String
    public let relation: String
    public let rawMemory: String
    
    public init(personName: String, relation: String, rawMemory: String) {
        self.personName = personName
        self.relation = relation
        self.rawMemory = rawMemory
    }
}

public struct EnhanceMemoryResponse: Codable, Sendable {
    public let enhancedText: String
    public let suggestedTitle: String?
}

public struct PhotoAnalysisRequest: Codable, Sendable {
    public let personName: String
    public let approximateYear: String?
    public let promptContext: String?
    
    public init(personName: String, approximateYear: String? = nil, promptContext: String? = nil) {
        self.personName = personName
        self.approximateYear = approximateYear
        self.promptContext = promptContext
    }
}

public struct PhotoAnalysisResponse: Codable, Sendable {
    public let caption: String
    public let historicalContext: String
    public let suggestedTags: [String]?
}

// MARK: - Live Service Implementation

public final class RememberedAPIService: RememberedAPIServiceProtocol, @unchecked Sendable {
    public static let shared = RememberedAPIService()
    
    private let baseURL: URL
    private let session: URLSession
    private var authToken: String?
    
    public init(
        baseURL: URL = URL(string: "https://your-backend-domain.com")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    public func setAuthToken(_ token: String?) {
        self.authToken = token
    }
    
    private func makeRequest<T: Encodable>(endpoint: String, method: String = "POST", body: T?) throws -> URLRequest {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Remembered-iOS/1.0", forHTTPHeaderField: "User-Agent")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return request
    }
    
    public func checkHealth() async throws -> HealthCheckResponse {
        guard let url = URL(string: "/api/health", relativeTo: baseURL) else { throw URLError(.badURL) }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(HealthCheckResponse.self, from: data)
    }
    
    public func generateBiography(request: BiographyGenerationRequest) async throws -> BiographyGenerationResponse {
        let req = try makeRequest(endpoint: "/api/gemini/biography", body: request)
        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(BiographyGenerationResponse.self, from: data)
    }
    
    public func extractTimeline(request: TimelineExtractionRequest) async throws -> TimelineExtractionResponse {
        let req = try makeRequest(endpoint: "/api/gemini/timeline", body: request)
        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(TimelineExtractionResponse.self, from: data)
    }
    
    public func enhanceMemory(request: EnhanceMemoryRequest) async throws -> EnhanceMemoryResponse {
        let req = try makeRequest(endpoint: "/api/gemini/enhance-memory", body: request)
        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(EnhanceMemoryResponse.self, from: data)
    }
    
    public func analyzePhoto(request: PhotoAnalysisRequest) async throws -> PhotoAnalysisResponse {
        let req = try makeRequest(endpoint: "/api/gemini/analyze-photo", body: request)
        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(PhotoAnalysisResponse.self, from: data)
    }
}
