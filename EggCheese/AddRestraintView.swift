//
//  AddRestraintView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct AddRestraintView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var restraintManager = RestraintManager()
    @State private var name = ""
    @State private var date = Date()
    @State private var restraintPeriod = ""
    @State private var readinessDate = Date()
    @State private var notes = ""
    @State private var selectedStatus = "In production"
    @State private var showingCalendar = false
    @State private var showingDataCard = false
    @State private var showingDeleteAlert = false
    
    // Проверяем, заполнены ли все обязательные поля
    private var isFormValid: Bool {
        !name.isEmpty && !restraintPeriod.isEmpty
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
                    Text(showingDataCard ? "" : "Add data")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Кнопки "Edit" и "Delete" или "Done"
                    if showingDataCard {
                        HStack(spacing: 15) {
                            Button(action: { showingDataCard = false }) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                            }
                            Button(action: { showingDeleteAlert = true }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .font(.headline)
                            }
                        }
                    } else {
                        Button(action: { saveRestraintData() }) {
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
                if !showingDataCard {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Поля ввода
                            VStack(spacing: 15) {
                                // Batch Name
                                HStack {
                                    TextField("Batch Name", text: $name)
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
                                
                                // Start Date
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
                                
                                // Aging Period
                                HStack {
                                    TextField("Aging Period", text: $restraintPeriod)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !restraintPeriod.isEmpty {
                                        Button(action: { restraintPeriod = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Ready Date
                                Button(action: { showingCalendar = true }) {
                                    HStack {
                                        Text(dateFormatter.string(from: readinessDate))
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
                            }
                            
                            // Status Section
                            HStack(spacing: 15) {
                                // In production button
                                Button(action: { selectedStatus = "In production" }) {
                                    VStack(spacing: 12) {
                                        Image("inProdImage")
                                        Text("In production")
                                            .font(.headline)
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
                                        Text("Ready")
                                            .font(.headline)
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
                    // Карточка restraint data
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            // Статус
                            VStack(spacing: 10) {
                                Image("bathImage")
                                
                                Text("Restraint")
                                    .font(.headline)
                                    .foregroundColor(.brown)
                            }
                            
                            // Название
                            Text(name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.brown)
                            
                            // Детали
                            VStack(alignment: .leading, spacing: 10) {
                                DetailRow(title: "Date", value: dateFormatter.string(from: date))
                                DetailRow(title: "Restraint Period", value: restraintPeriod)
                                DetailRow(title: "Readiness Date", value: dateFormatter.string(from: readinessDate))
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
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("Select Date")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.brown)
                                
                                Spacer()
                                
                                Button(action: { showingCalendar = false }) {
                                    Text("Done")
                                        .font(.headline)
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
                // Удаляем только что созданные данные
                deleteCreatedRestraintData()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this restraint data?")
        }
    }
    
    private func saveRestraintData() {
        // Создаем новые restraint данные
        let newData = RestraintData(
            name: name,
            date: date,
            restraintPeriod: restraintPeriod,
            readinessDate: readinessDate,
            notes: notes,
            status: selectedStatus
        )
        
        // Сохраняем в UserDefaults
        restraintManager.addRestraintData(newData)
        
        // Отправляем уведомление об добавлении данных
        NotificationCenter.default.post(name: NSNotification.Name("RestraintDataAdded"), object: nil)
        
        // Показываем карточку данных
        showingDataCard = true
    }
    
    private func deleteCreatedRestraintData() {
        // Удаляем последние добавленные данные (только что созданные)
        let userDefaults = UserDefaults.standard
        let restraintKey = "savedRestraintData"
        
        if let data = userDefaults.data(forKey: restraintKey),
           var restraintData = try? JSONDecoder().decode([RestraintData].self, from: data) {
            // Удаляем последний элемент (только что созданный)
            if !restraintData.isEmpty {
                restraintData.removeLast()
            }
            
            // Сохраняем обновленный массив
            if let encoded = try? JSONEncoder().encode(restraintData) {
                userDefaults.set(encoded, forKey: restraintKey)
            }
        }
        
        // Отправляем уведомление об удалении
        NotificationCenter.default.post(name: NSNotification.Name("RestraintDataDeleted"), object: nil)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

#Preview {
    AddRestraintView()
}
