# Remembered - Backend API Specification for iOS Integration

## 1. Architectural Overview & Security Mandates

> [!CAUTION]
> **CRITICAL SECURITY DIRECTIVE FOR IOS IMPLEMENTATION**:
> **Never embed private API keys (such as `GEMINI_API_KEY`) or cloud service account keys directly in the Swift client codebase or `.plist` files.**
> Compiling API keys into iOS binaries exposes them to extraction via decompilation, static analysis, or proxy interception (e.g. Charles / Proxyman).

All generative AI requests, database persistence, and external third-party services must flow through the **Backend / BFF (Backend-for-Frontend)** proxy layer (`server.ts` or cloud microservice). The iOS client speaks only to authenticated backend endpoints using standard Bearer tokens (`Authorization: Bearer <JWT>`).

---

## 2. API Endpoints Reference

### 2.1 Health & Service Verification
* **Endpoint**: `GET /api/health`
* **Authentication**: Optional / Public
* **Response**:
  ```json
  {
    "status": "ok",
    "service": "Remembered Memory Archive",
    "time": "2026-09-07T18:30:00.000Z"
  }
  ```

---

### 2.2 AI Biography & Motto Generation
* **Endpoint**: `POST /api/gemini/biography`
* **Authentication**: Bearer Token
* **Request Body**:
  ```json
  {
    "name": "Albert Einstein",
    "birthYear": "1879",
    "deathYear": "1955",
    "profession": "Theoretical Physicist",
    "hometown": "Ulm, Germany",
    "memories": "Formulated the general theory of relativity and loved playing the violin.",
    "tone": "reverent_literary"
  }
  ```
* **Response Body**:
  ```json
  {
    "lifeQuote": "Imagination is more important than knowledge.",
    "biography": "Albert Einstein was a visionary whose discoveries reshaped human understanding of the cosmos...",
    "suggestedMilestones": [
      {
        "year": "1905",
        "title": "Annus Mirabilis",
        "description": "Published four groundbreaking papers."
      }
    ]
  }
  ```

---

### 2.3 Chronological Timeline Extraction
* **Endpoint**: `POST /api/gemini/timeline`
* **Authentication**: Bearer Token
* **Request Body**:
  ```json
  {
    "personName": "Barış Manço",
    "rawStory": "Born in Istanbul in 1943. Founded Kurtalan Ekspres in 1972..."
  }
  ```
* **Response Body**:
  ```json
  {
    "milestones": [
      {
        "year": "1943",
        "title": "Birth in Istanbul",
        "category": "life",
        "description": "Born in Üsküdar."
      },
      {
        "year": "1972",
        "title": "Kurtalan Ekspres Founded",
        "category": "career",
        "description": "Formed legendary Anatolian rock group."
      }
    ]
  }
  ```

---

### 2.4 Tribute Memory Polisher
* **Endpoint**: `POST /api/gemini/enhance-memory`
* **Authentication**: Bearer Token
* **Request Body**:
  ```json
  {
    "personName": "Marie Curie",
    "relation": "Student",
    "rawMemory": "She worked very hard in laboratory without stopping."
  }
  ```
* **Response Body**:
  ```json
  {
    "enhancedText": "In the laboratory, her tireless devotion was an unwavering beacon of quiet determination...",
    "suggestedTitle": "A Memory of Quiet Devotion"
  }
  ```

---

### 2.5 Archival Photo Analysis & Context
* **Endpoint**: `POST /api/gemini/analyze-photo`
* **Authentication**: Bearer Token
* **Request Body**:
  ```json
  {
    "personName": "Albert Einstein",
    "approximateYear": "1921",
    "promptContext": "Formal portrait holding lecture notes."
  }
  ```
* **Response Body**:
  ```json
  {
    "caption": "Nobel Laureate Portrait, 1921",
    "historicalContext": "Captured during his global lecture tour celebrating the law of the photoelectric effect.",
    "suggestedTags": ["physics", "nobel", "1920s"]
  }
  ```
