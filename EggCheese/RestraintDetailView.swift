//
//  RestraintDetailView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct RestraintDetailView: View {
    let data: RestraintData
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            // Фоновое изображение background из assets
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Кастомная навигационная панель
                HStack {
                    // Кнопка назад (кастомная иконка)
                    Button(action: { dismiss() }) {
                        Image("backButton")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                    
                    // Заголовок
                    Text("Edit restraint data")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Кнопка удаления
                    Button(action: { showingDeleteAlert = true }) {
                        Text("Delete")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 90)
                
                // Основной контент - карточка restraint data
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        // Статус с иконкой
                        VStack(spacing: 10) {
                            Image(data.status == "In production" ? "inProdImage" : "readyImage")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text(data.status)
                                .font(.headline)
                                .foregroundColor(.yellow)
                        }
                        
                        // Название
                        Text(data.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.brown)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Детали в две колонки
                        HStack(alignment: .top, spacing: 20) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start Date")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(dateFormatter.string(from: data.date))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.brown)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start Date")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(dateFormatter.string(from: data.readinessDate))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.brown)
                            }
                            
                            Spacer()
                        }
                        
                        // Aging Period внизу
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Aging Period")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(data.restraintPeriod)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.brown)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Скрываем таббар при появлении экрана
            NotificationCenter.default.post(name: NSNotification.Name("HideTabBar"), object: nil)
        }
        .onDisappear {
            // Показываем таббар при исчезновении экрана
            NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        }
        .alert("Delete", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Удаляем напрямую из UserDefaults
                deleteRestraintDataFromUserDefaults(data)
                // Отправляем уведомление об удалении данных
                NotificationCenter.default.post(name: NSNotification.Name("RestraintDataDeleted"), object: nil)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this restraint data?")
        }
    }
    
    private func deleteRestraintDataFromUserDefaults(_ data: RestraintData) {
        let userDefaults = UserDefaults.standard
        let restraintKey = "savedRestraintData"
        
        if let userData = userDefaults.data(forKey: restraintKey),
           var restraintData = try? JSONDecoder().decode([RestraintData].self, from: userData) {
            // Удаляем данные из массива
            restraintData.removeAll { $0.id == data.id }
            
            // Сохраняем обновленный массив
            if let encoded = try? JSONEncoder().encode(restraintData) {
                userDefaults.set(encoded, forKey: restraintKey)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

#Preview {
    RestraintDetailView(data: RestraintData(
        name: "Alpine Brine",
        date: Date(),
        restraintPeriod: "30 days",
        readinessDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        notes: "Track ripening progress",
        status: "In production"
    ))
}
