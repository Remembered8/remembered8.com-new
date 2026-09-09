import SwiftUI

/// Memory Letter Row View - Parchment letterhead tribute
public struct MemoryLetterRowView: View {
    let letter: MemoryLetter
    
    public init(letter: MemoryLetter) {
        self.letter = letter
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(letter.authorName)
                        .font(.system(size: 15, weight: .bold, design: .serif))
                        .foregroundColor(RememberedColors.inkPrimary)
                    Text(letter.relation)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(RememberedColors.inkMuted)
                }
                Spacer()
                Text(letter.date)
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundColor(RememberedColors.inkMuted)
            }
            
            Text(letter.content)
                .font(.system(size: 14, weight: .regular, design: .serif))
                .lineSpacing(4)
                .foregroundColor(RememberedColors.inkSecondary)
        }
        .padding(14)
        .background(RememberedColors.parchmentCard)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(RememberedColors.parchmentBorder, lineWidth: 1)
        )
    }
}

/// Timeline Item View
public struct TimelineItemView: View {
    let milestone: TimelineMilestone
    
    public init(milestone: TimelineMilestone) {
        self.milestone = milestone
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Year Tag
            Text(milestone.year)
                .font(.system(size: 13, weight: .heavy, design: .monospaced))
                .foregroundColor(RememberedColors.flameGoldDark)
                .frame(width: 50, alignment: .trailing)
            
            // Vertical bullet line
            VStack {
                Circle()
                    .fill(RememberedColors.inkPrimary)
                    .frame(width: 8, height: 8)
                Rectangle()
                    .fill(RememberedColors.parchmentBorder)
                    .frame(width: 1)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.system(size: 15, weight: .bold, design: .serif))
                    .foregroundColor(RememberedColors.inkPrimary)
                
                Text(milestone.description)
                    .font(.system(size: 13, weight: .regular, design: .serif))
                    .foregroundColor(RememberedColors.inkSecondary)
                    .lineSpacing(2)
            }
            .padding(.bottom, 16)
        }
    }
}

/// Voice Archive Row View
public struct VoiceStoryRowView: View {
    let story: AudioStory
    @ObservedObject var player = AudioPlayerService.shared
    
    public init(story: AudioStory) {
        self.story = story
    }
    
    private var isPlayingThis: Bool {
        player.currentStoryId == story.id && player.isPlaying
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                if let urlString = story.audioUrl, let url = URL(string: urlString) {
                    player.play(storyId: story.id, url: url)
                }
            }) {
                Circle()
                    .fill(RememberedColors.inkPrimary)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: isPlayingThis ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    )
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(story.title)
                    .font(.system(size: 14, weight: .bold, design: .serif))
                    .foregroundColor(RememberedColors.inkPrimary)
                
                Text("\(story.duration) • \(story.description)")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(RememberedColors.inkMuted)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(10)
        .background(RememberedColors.parchmentCard)
        .border(RememberedColors.parchmentBorder, width: 1)
    }
}
