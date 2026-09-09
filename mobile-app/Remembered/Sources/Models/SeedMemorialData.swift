import Foundation

/// Seed data matching the production Remembered dataset
public enum SeedMemorialData {
    public static let initialMemorials: [MemorialProfile] = [
        // 1. Albert Einstein
        MemorialProfile(
            id: "albert-einstein",
            slug: "albert-einstein",
            fullName: "Albert Einstein",
            birthDate: "March 14, 1879",
            deathDate: "April 18, 1955",
            birthPlace: "Ulm, Kingdom of Württemberg, German Empire",
            restingPlace: "Ashes scattered near Delaware River, Princeton, NJ",
            profession: "Theoretical Physicist & Nobel Laureate in Physics",
            lifeQuote: "Imagination is more important than knowledge. For knowledge is limited, whereas imagination embraces the entire world.",
            heroImage: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Einstein_1921_by_F_Schmutzer_-_restoration.jpg",
            coverAccentColor: "#2B3A42",
            biography: """
            Albert Einstein was a German-born theoretical physicist who is widely held to be one of the greatest and most influential scientists of all time. Best known for developing the theory of relativity, he also made important contributions to quantum mechanics.
            
            His mass–energy equivalence formula E = mc², which arises from relativity, has been called 'the world's most famous equation'. He received the 1921 Nobel Prize in Physics for his services to theoretical physics, and especially for his discovery of the law of the photoelectric effect.
            """,
            candleCount: 14208,
            visitedTodayCount: 412,
            privacy: .public,
            adminEmail: "princeton.archives@ias.edu",
            isVerifiedHistoric: true,
            category: .historical,
            timelineEvents: [
                TimelineMilestone(year: "1879", title: "Birth in Ulm", category: .life, description: "Born to Hermann Einstein and Pauline Koch."),
                TimelineMilestone(year: "1905", title: "Annus Mirabilis Papers", category: .creation, description: "Published four groundbreaking papers including special relativity."),
                TimelineMilestone(year: "1915", title: "General Theory of Relativity", category: .career, description: "Completed the field equations formulating gravity as spacetime curvature."),
                TimelineMilestone(year: "1921", title: "Nobel Prize in Physics", category: .milestone, description: "Awarded for his discovery of the photoelectric effect law.")
            ],
            gallery: [
                ArchivalItem(url: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Einstein_1921_by_F_Schmutzer_-_restoration.jpg", caption: "Official Nobel portrait, 1921"),
                ArchivalItem(url: "https://upload.wikimedia.org/wikipedia/commons/d/d3/Albert_Einstein_Head.jpg", caption: "Einstein at Princeton, 1947")
            ],
            memories: [
                MemoryLetter(authorName: "Dr. J. Robert Oppenheimer", relation: "Colleague, Institute for Advanced Study", date: "April 1955", content: "He was almost wholly without sophistication and wholly without worldliness... There was always in him a powerful purity at once childlike and profoundly stubborn.")
            ]
        ),
        
        // 2. Barış Manço
        MemorialProfile(
            id: "baris-manco",
            slug: "baris-manco",
            fullName: "Barış Manço",
            birthDate: "January 2, 1943",
            deathDate: "February 1, 1999",
            birthPlace: "Üsküdar, Istanbul, Turkey",
            restingPlace: "Kanlıca Cemetery, Beykoz, Istanbul",
            profession: "Pioneering Musician, Composer, Traveler & Cultural Ambassador",
            lifeQuote: "A person dies not when their heart stops beating, but when their name is spoken for the very last time.",
            heroImage: "https://upload.wikimedia.org/wikipedia/commons/8/87/Baris_Manco.jpg",
            coverAccentColor: "#1E3A5F",
            biography: """
            Mehmet Barış Manço was an iconic Turkish rock musician, singer, composer, actor, television producer, and world traveler. He composed over 200 songs, many of which were translated into various languages.
            
            Through his legendary world travel program '7'den 77'ye' (From 7 to 77), he united millions of households across generations with wisdom, kindness, and international goodwill.
            """,
            candleCount: 28940,
            visitedTodayCount: 890,
            privacy: .public,
            adminEmail: "kurtalan.ekspres@barismanco.org",
            isVerifiedHistoric: true,
            category: .historical,
            timelineEvents: [
                TimelineMilestone(year: "1943", title: "Birth in Istanbul", category: .life, description: "Born in Üsküdar during the wartime era."),
                TimelineMilestone(year: "1972", title: "Kurtalan Ekspres Founded", category: .career, description: "Formed the legendary Anatolian Rock ensemble."),
                TimelineMilestone(year: "1988", title: "7'den 77'ye Television Premiere", category: .creation, description: "Began the decade-long educational world journey program.")
            ]
        ),
        
        // 3. Mustafa Kemal Atatürk
        MemorialProfile(
            id: "mustafa-kemal-ataturk",
            slug: "mustafa-kemal-ataturk",
            fullName: "Mustafa Kemal Atatürk",
            birthDate: "1881",
            deathDate: "November 10, 1938",
            birthPlace: "Thessaloniki",
            restingPlace: "Anıtkabir, Ankara",
            profession: "Founder of the Republic of Turkey, Statesman & Visionary Educator",
            lifeQuote: "Peace at home, peace in the world.",
            heroImage: "https://upload.wikimedia.org/wikipedia/commons/a/a8/Ataturk1930s.jpg",
            coverAccentColor: "#800020",
            biography: """
            Mustafa Kemal Atatürk was a field marshal, revolutionary statesman, author, and the founding father of the Republic of Turkey, serving as its first president from 1923 until his death in 1938.
            """,
            candleCount: 95400,
            visitedTodayCount: 3240,
            privacy: .public,
            adminEmail: "archives@anitkabir.tsk.tr",
            isVerifiedHistoric: true,
            category: .historical
        ),
        
        // 4. Hachiko (Animal Sanctuary Luminary)
        MemorialProfile(
            id: "hachiko-the-loyal-akita",
            slug: "hachiko-the-loyal-akita",
            fullName: "Hachikō (八公)",
            birthDate: "November 10, 1923",
            deathDate: "March 8, 1935",
            birthPlace: "Ōdate, Akita Prefecture, Japan",
            restingPlace: "Aoyama Cemetery, Minato, Tokyo",
            profession: "Emblem of Unconditional Loyalty & National Treasure of Devotion",
            lifeQuote: "True loyalty is not measured in years, but in every silent moment waiting for the footsteps of love.",
            heroImage: "https://upload.wikimedia.org/wikipedia/commons/7/7b/Hachiko_rare_photo.jpg",
            coverAccentColor: "#92400E",
            biography: """
            Hachikō was a golden brown Akita remembered for his remarkable loyalty to his owner, Professor Hidesaburō Ueno, for whom he continued to wait daily at Shibuya Station for over nine years following Ueno's sudden passing.
            """,
            candleCount: 43200,
            visitedTodayCount: 1180,
            privacy: .public,
            adminEmail: "shibuya.heritage@tokyo.jp",
            isVerifiedHistoric: true,
            category: .animalCompanion,
            species: "Dog",
            breed: "Akita Inu",
            honorTitle: "Eternal Symbol of Fidelity"
        )
    ]
}
