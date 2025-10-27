//
//  BatchDetailView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct BatchDetailView: View {
    let batch: Batch
    let index: Int
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
                    Text("Edit batch")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Кнопка удаления
                    Button(action: { showingDeleteAlert = true }) {
                        Text("Delete")
                            .foregroundColor(.red)
                            .font(.anton(.headline))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 90)
                
                // Основной контент - карточка batch
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        // Статус
                        VStack(spacing: 10) {
                            Image(batch.status == "In production" ? "inProdImage" : "readyImage")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text(batch.status)
                                .font(.anton(.headline))
                                .foregroundColor(.brown)
                        }
                        
                        // Название batch
                        Text(batch.name)
                            .font(.anton(.title))
                            .foregroundColor(.brown)
                        
                        // Детали
                        VStack(alignment: .leading, spacing: 10) {
                            DetailRow(title: "Date", value: dateFormatter.string(from: batch.date))
                            DetailRow(title: "Cheese Type", value: batch.cheeseType)
                            DetailRow(title: "Milk Type", value: batch.milkType)
                            DetailRow(title: "Volume", value: batch.volume)
                            if !batch.notes.isEmpty {
                                DetailRow(title: "Notes", value: batch.notes)
                            }
                        }
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
                // Удаляем по индексу из UserDefaults
                deleteBatchByIndex(index)
                // Отправляем уведомление об удалении batch
                NotificationCenter.default.post(name: NSNotification.Name("BatchDeleted"), object: nil)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this batch?")
        }
    }
    
    private func deleteBatchByIndex(_ index: Int) {
        let userDefaults = UserDefaults.standard
        let batchesKey = "savedBatches"
        
        if let data = userDefaults.data(forKey: batchesKey),
           var batches = try? JSONDecoder().decode([Batch].self, from: data) {
            // Удаляем batch по индексу
            if index < batches.count {
                batches.remove(at: index)
            }
            
            // Сохраняем обновленный массив
            if let encoded = try? JSONEncoder().encode(batches) {
                userDefaults.set(encoded, forKey: batchesKey)
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
    BatchDetailView(batch: Batch(
        name: "Alpine Brine",
        date: Date(),
        cheeseType: "Mold Cheese",
        milkType: "Cow",
        volume: "8 kg",
        status: "In production",
        notes: "Added a bit of sea salt"
    ), index: 1)
}
