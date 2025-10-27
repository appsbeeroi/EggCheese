//
//  RestraintCardView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct RestraintCardView: View {
    let data: RestraintData
    
    var body: some View {
        NavigationLink(destination: RestraintDetailView(data: data)) {
            HStack(spacing: 15) {
                // Левая часть - желтый круг с иконкой
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 50, height: 50)
                        
                        Image(data.status == "In production" ? "inProdImage" : "readyImage")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text(data.status)
                        .font(.caption)
                        .foregroundColor(.brown)
                }
                
                // Центральная часть - название и даты
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.brown)
                    
                    HStack(spacing: 8) {
                        Text(dateFormatter.string(from: data.date))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(dateFormatter.string(from: data.readinessDate))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Правая часть - стрелка
                Image(systemName: "chevron.right")
                    .foregroundColor(.yellow)
                    .font(.title3)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Убираем стиль кнопки NavigationLink
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

#Preview {
    RestraintCardView(data: RestraintData(
        name: "Alpine Brine",
        date: Date(),
        restraintPeriod: "30 days",
        readinessDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        notes: "Track ripening progress",
        status: "In production"
    ))
}
