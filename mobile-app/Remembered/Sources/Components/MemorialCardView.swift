import SwiftUI

/// Interactive Digital Memorial Candle with gentle flickering glow
public struct DigitalCandleView: View {
    let candleCount: Int
    let hasLit: Bool
    let onLight: () -> Void
    
    @State private var flameScale: CGFloat = 1.0
    @State private var flameOpacity: Double = 0.85
    
    public init(candleCount: Int, hasLit: Bool, onLight: @escaping () -> Void) {
        self.candleCount = candleCount
        self.hasLit = hasLit
        self.onLight = onLight
    }
    
    public var body: some View {
        Button(action: onLight) {
            HStack(spacing: 12) {
                // Flame visual
                ZStack {
                    Circle()
                        .fill(RememberedColors.flameGold.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .scaleEffect(flameScale)
                    
                    Circle()
                        .fill(RememberedColors.inkPrimary)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 18))
                        .foregroundColor(RememberedColors.flameGold)
                        .opacity(flameOpacity)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(hasLit ? "Candle Lit in Reverence" : "Light a Memorial Candle")
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .foregroundColor(RememberedColors.inkPrimary)
                    
                    Text("\(candleCount.formatted()) vigils burning perpetually")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(RememberedColors.inkMuted)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(RememberedColors.parchmentCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(hasLit ? RememberedColors.flameGold : RememberedColors.parchmentBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
            ) {
                flameScale = 1.15
                flameOpacity = 1.0
            }
        }
    }
}

/// Broadsheet Editorial Memorial Card
public struct MemorialCardView: View {
    let memorial: MemorialProfile
    let onSelect: () -> Void
    
    public init(memorial: MemorialProfile, onSelect: @escaping () -> Void) {
        self.memorial = memorial
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 12) {
                // Photo Frame
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: memorial.heroImage)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(RememberedColors.parchmentMuted)
                                .frame(height: 200)
                                .overlay(ProgressView())
                        case .success(let img):
                            img
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(RememberedColors.parchmentMuted)
                                .frame(height: 200)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(RememberedColors.inkMuted)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    if memorial.isVerifiedHistoric == true {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(RememberedColors.flameGold)
                            Text("ARCHIVED")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.8))
                        .padding(8)
                    }
                }
                .border(RememberedColors.parchmentBorder, width: 1)
                
                // Dates & Location
                HStack {
                    Text("\(memorial.birthDate) — \(memorial.deathDate)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(RememberedColors.inkMuted)
                    Spacer()
                    if let species = memorial.species {
                        Text(species.uppercased())
                            .font(.system(size: 10, weight: .heavy, design: .monospaced))
                            .foregroundColor(RememberedColors.flameGoldDark)
                    }
                }
                
                // Name
                Text(memorial.fullName)
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(RememberedColors.inkPrimary)
                
                // Profession / Title
                Text(memorial.profession)
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundColor(RememberedColors.inkSecondary)
                    .lineLimit(2)
                
                // Quote
                if !memorial.lifeQuote.isEmpty {
                    Text("“\(memorial.lifeQuote)”")
                        .font(.system(size: 12, weight: .regular, design: .serif).italic())
                        .foregroundColor(RememberedColors.inkMuted)
                        .lineLimit(2)
                        .padding(.top, 2)
                }
                
                Divider()
                    .overlay(RememberedColors.parchmentBorder)
                
                // Footer Vigil Stats
                HStack {
                    Label("\(memorial.candleCount.formatted()) vigils", systemImage: "flame")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundColor(RememberedColors.flameGoldDark)
                    Spacer()
                    Text("READ CHRONICLE →")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(RememberedColors.inkPrimary)
                }
            }
            .padding(16)
            .background(RememberedColors.parchmentCard)
            .border(RememberedColors.parchmentBorder, width: 1)
        }
        .buttonStyle(.plain)
    }
}
