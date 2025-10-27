//
//  BatchCardView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct BatchCardView: View {
    let batch: Batch
    let index: Int
    
    var body: some View {
        NavigationLink(destination: BatchDetailView(batch: batch, index: index)) {
            HStack(spacing: 15) {
                // Левая часть - желтый круг с иконкой и статусом
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
                
                // Центральная часть - только название
                Text(batch.name)
                    .font(.anton(.title2))
                    .foregroundColor(.brown)
                
                Spacer()
                
                // Правая часть - стрелка
                Image(systemName: "chevron.right")
                    .foregroundColor(.yellow)
                    .font(.anton(.title3))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Убираем стиль кнопки NavigationLink
    }
}

#Preview {
    BatchCardView(batch: Batch(
        name: "Alpine Brine",
        date: Date(),
        cheeseType: "Mold Cheese",
        milkType: "Cow",
        volume: "8 kg",
        status: "In production",
        notes: "Added a bit of sea salt"
    ), index: 0)
}
