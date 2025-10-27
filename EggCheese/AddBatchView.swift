//
//  AddBatchView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct AddBatchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var batchManager = BatchManager()
    @State private var name = ""
    @State private var date = Date()
    @State private var cheeseType = ""
    @State private var milkType = ""
    @State private var volume = ""
    @State private var selectedStatus = "In production"
    @State private var notes = ""
    @State private var showingCalendar = false
    @State private var showingBatchCard = false
    @State private var showingDeleteAlert = false
    
    // Проверяем, заполнены ли все обязательные поля
    private var isFormValid: Bool {
        !name.isEmpty && !cheeseType.isEmpty && !milkType.isEmpty && !volume.isEmpty
    }
    
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
                    
                    // Заголовок (пустой, если показывается карточка)
                    Text(showingBatchCard ? "" : "Add batch")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Кнопки "Edit" и "Delete" или "Done"
                    if showingBatchCard {
                        HStack(spacing: 15) {
                            Button(action: { showingBatchCard = false }) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    .font(.anton(.headline))
                            }
                            Button(action: { showingDeleteAlert = true }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .font(.anton(.headline))
                            }
                        }
                    } else {
                        Button(action: { saveBatch() }) {
                            Image("doneButton")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .opacity(isFormValid ? 1.0 : 0.5)
                        }
                        .disabled(!isFormValid)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 90)
                
                // Основной контент
                if !showingBatchCard {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Поля ввода
                            VStack(spacing: 15) {
                                // Name
                                HStack {
                                    TextField("Name", text: $name)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !name.isEmpty {
                                        Button(action: { name = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Date
                                Button(action: { showingCalendar = true }) {
                                    HStack {
                                        Text(dateFormatter.string(from: date))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image("calendarIcon")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }
                                
                                // Cheese Type
                                HStack {
                                    TextField("Cheese Type", text: $cheeseType)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !cheeseType.isEmpty {
                                        Button(action: { cheeseType = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Milk Type
                                HStack {
                                    TextField("Milk Type", text: $milkType)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !milkType.isEmpty {
                                        Button(action: { milkType = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Volume
                                HStack {
                                    TextField("Volume", text: $volume)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !volume.isEmpty {
                                        Button(action: { volume = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                        
                            // Status Section
                            HStack(spacing: 15) {
                                // In production button
                                Button(action: { selectedStatus = "In production" }) {
                                    VStack(spacing: 12) {
                                        Image("inProdImage")
//                                            .resizable()
//                                            .frame(width: 30, height: 30)
                                        
                                        Text("In production")
                                            .font(.anton(.headline))
                                            .foregroundColor(.brown)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedStatus == "In production" ? Color.yellow : Color.clear, lineWidth: 2)
                                    )
                                }
                                
                                // Ready button
                                Button(action: { selectedStatus = "Ready" }) {
                                    VStack(spacing: 12) {
                                        Image("readyImage")
//                                            .resizable()
//                                            .frame(width: 30, height: 30)
                                        
                                        Text("Ready")
                                            .font(.anton(.headline))
                                            .foregroundColor(.brown)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedStatus == "Ready" ? Color.yellow : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                            
                            // Notes Section
                            TextField("Notes", text: $notes, axis: .vertical)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(minHeight: 80)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        
                            Spacer(minLength: 100) // Отступ для таббара
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .onTapGesture {
                                // Скрываем клавиатуру при нажатии на область с полями
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                    }
                } else {
                    // Карточка batch
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            // Статус
                            VStack(spacing: 10) {
                                Image(selectedStatus == "In production" ? "inProdImage" : "readyImage")
//                                    .resizable()
//                                    .frame(width: 40, height: 40)
                                
                                Text(selectedStatus)
                                    .font(.anton(.headline))
                                    .foregroundColor(.brown)
                            }
                            
                            // Название batch
                            Text(name)
                                .font(.anton(.title))
                                .foregroundColor(.brown)
                            
                            // Детали
                            VStack(alignment: .leading, spacing: 10) {
                                DetailRow(title: "Date", value: dateFormatter.string(from: date))
                                DetailRow(title: "Cheese Type", value: cheeseType)
                                DetailRow(title: "Milk Type", value: milkType)
                                DetailRow(title: "Volume", value: volume)
                                if !notes.isEmpty {
                                    DetailRow(title: "Notes", value: notes)
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
                
                // Календарь-оверлей
                if showingCalendar {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 0) {
                            // Заголовок календаря
                            HStack {
                                Button(action: { showingCalendar = false }) {
                                    Image(systemName: "xmark")
                                        .font(.anton(.title2))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("Select Date")
                                    .font(.anton(.title2))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.brown)
                                
                                Spacer()
                                
                                Button(action: { showingCalendar = false }) {
                                    Text("Done")
                                        .font(.anton(.headline))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            
                            // Календарь
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .background(Color.white)
                        }
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
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
                        // Удаляем только что созданный batch
                        deleteCreatedBatch()
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this batch?")
                }
    }
    
    private func saveBatch() {
        // Создаем новый batch
        let newBatch = Batch(
            name: name,
            date: date,
            cheeseType: cheeseType,
            milkType: milkType,
            volume: volume,
            status: selectedStatus,
            notes: notes
        )
        
        // Сохраняем в UserDefaults
        batchManager.addBatch(newBatch)
        
        // Отправляем уведомление об добавлении batch
        NotificationCenter.default.post(name: NSNotification.Name("BatchAdded"), object: nil)
        
        // Показываем карточку batch
        showingBatchCard = true
    }
    
    private func deleteCreatedBatch() {
        // Удаляем последний добавленный batch (только что созданный)
        let userDefaults = UserDefaults.standard
        let batchesKey = "savedBatches"
        
        if let data = userDefaults.data(forKey: batchesKey),
           var batches = try? JSONDecoder().decode([Batch].self, from: data) {
            // Удаляем последний элемент (только что созданный)
            if !batches.isEmpty {
                batches.removeLast()
            }
            
            // Сохраняем обновленный массив
            if let encoded = try? JSONEncoder().encode(batches) {
                userDefaults.set(encoded, forKey: batchesKey)
            }
        }
        
        // Отправляем уведомление об удалении
        NotificationCenter.default.post(name: NSNotification.Name("BatchDeleted"), object: nil)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

// Кастомный стиль для текстовых полей
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}

// Компонент для отображения деталей batch
struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.anton(.subheadline))
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            Spacer()

            Text(value)
                .font(.anton(.subheadline))
                .foregroundColor(.brown)
            
        }
    }
}

#Preview {
    AddBatchView()
}
