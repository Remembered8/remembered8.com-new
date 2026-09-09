import SwiftUI

/// Ergonomic Bottom Floating Action Dock
public struct FloatingActionDockView: View {
    let hasLitCandle: Bool
    let onLightCandle: () -> Void
    let onWriteMemory: () -> Void
    let onOpenQr: () -> Void
    let onOpenStore: () -> Void
    
    public init(
        hasLitCandle: Bool,
        onLightCandle: @escaping () -> Void,
        onWriteMemory: @escaping () -> Void,
        onOpenQr: @escaping () -> Void,
        onOpenStore: @escaping () -> Void
    ) {
        self.hasLitCandle = hasLitCandle
        self.onLightCandle = onLightCandle
        self.onWriteMemory = onWriteMemory
        self.onOpenQr = onOpenQr
        self.onOpenStore = onOpenStore
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Candle
            Button(action: onLightCandle) {
                VStack(spacing: 2) {
                    Image(systemName: hasLitCandle ? "flame.fill" : "flame")
                        .foregroundColor(hasLitCandle ? RememberedColors.flameGold : RememberedColors.inkPrimary)
                    Text("Candle")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(RememberedColors.inkPrimary)
                }
                .frame(minWidth: 54, minHeight: 44)
            }
            
            // Tribute Letter
            Button(action: onWriteMemory) {
                VStack(spacing: 2) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(RememberedColors.inkPrimary)
                    Text("Tribute")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(RememberedColors.inkPrimary)
                }
                .frame(minWidth: 54, minHeight: 44)
            }
            
            // QR Stone Plaque
            Button(action: onOpenQr) {
                VStack(spacing: 2) {
                    Image(systemName: "qrcode")
                        .foregroundColor(RememberedColors.inkPrimary)
                    Text("Plaque")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(RememberedColors.inkPrimary)
                }
                .frame(minWidth: 54, minHeight: 44)
            }
            
            // Phygital Store
            Button(action: onOpenStore) {
                VStack(spacing: 2) {
                    Image(systemName: "shippingbox")
                        .foregroundColor(RememberedColors.inkPrimary)
                    Text("Store")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(RememberedColors.inkPrimary)
                }
                .frame(minWidth: 54, minHeight: 44)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(hex: 0xFAF8F5).opacity(0.96))
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
                .overlay(
                    Capsule()
                        .stroke(RememberedColors.parchmentBorder, lineWidth: 1)
                )
        )
    }
}
