import SwiftUI

struct BatchCardView: View {
    
    let batch: Batch
    @EnvironmentObject var batchManager: BatchManager
    @Binding var hideTabBar: Bool
    
    var body: some View {
        NavigationLink(
            destination: BatchDetailView(batch: batch)
                .environmentObject(batchManager)
                .onAppear {
                    hideTabBar = true
                }
        ) {
            HStack(spacing: 15) {
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 50, height: 50)
                        
                        Image(batch.status == "In production" ? "inProdImage" : "readyImage")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text(batch.status)
                        .font(.anton(.caption))
                        .foregroundColor(.brown)
                }

                Text(batch.name)
                    .font(.anton(.title2))
                    .foregroundColor(.brown)
                
                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.yellow)
                    .font(.anton(.title3))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) 
    }
}

#Preview {
    BatchCardView(batch: Batch(
        id: UUID(),
        name: "Alpine Brine",
        date: Date(),
        cheeseType: "Mold Cheese",
        milkType: "Cow",
        volume: "8 kg",
        status: "In production",
        notes: "Added a bit of sea salt"
    ), hideTabBar: .constant(false))
    .environmentObject(BatchManager())
}
