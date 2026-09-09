import SwiftUI

/// Mechanical Retro Split-Flap Desk Calendar
public struct RetroFlipCalendarView: View {
    @State private var currentDate = Date()
    
    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: currentDate).uppercased()
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: currentDate)
    }
    
    private var yearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: currentDate)
    }
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 4) {
            // Month Plate
            CalendarPlate(text: monthString, isGold: false)
            // Day Plate
            CalendarPlate(text: dayString, isGold: true)
            // Year Plate
            CalendarPlate(text: yearString, isGold: false)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: 0x18181B))
                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
        )
    }
}

private struct CalendarPlate: View {
    let text: String
    let isGold: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: 0x27272A))
                .frame(width: 38, height: 32)
            
            // Middle mechanical split line
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(width: 38, height: 1)
            
            Text(text)
                .font(.system(size: 13, weight: .heavy, design: .monospaced))
                .foregroundColor(isGold ? RememberedColors.flameGold : .white)
        }
    }
}

/// Broadsheet Masthead Header
public struct BroadsheetHeaderView: View {
    let onOpenSearch: () -> Void
    let onOpenCreate: () -> Void
    
    public init(onOpenSearch: @escaping () -> Void, onOpenCreate: @escaping () -> Void) {
        self.onOpenSearch = onOpenSearch
        self.onOpenCreate = onOpenCreate
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            // Mechanical Desk Calendar
            RetroFlipCalendarView()
                .padding(.top, 4)
            
            // Main Broadsheet Title
            Text("THE REMEMBERED CHRONICLE")
                .font(.system(size: 26, weight: .black, design: .serif))
                .tracking(2.0)
                .foregroundColor(RememberedColors.inkPrimary)
                .multilineTextAlignment(.center)
            
            // Subtitle Dateline
            HStack(spacing: 8) {
                Text("THE SOLEMN ARCHIVE OF HUMAN & ANIMAL MEMORY")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .tracking(1.0)
                    .foregroundColor(RememberedColors.inkMuted)
            }
            
            // Oxford Double Rule
            VStack(spacing: 2) {
                Rectangle()
                    .fill(RememberedColors.inkPrimary)
                    .frame(height: 2)
                Rectangle()
                    .fill(RememberedColors.inkPrimary.opacity(0.4))
                    .frame(height: 0.5)
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
        .background(RememberedColors.parchmentBackground)
    }
}
