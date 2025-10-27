//
//  SettingsView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var showingClearHistoryAlert = false
    @StateObject private var batchManager = BatchManager()
    @StateObject private var recipeManager = RecipeManager()
    @StateObject private var restraintManager = RestraintManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фоновое изображение background из assets
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
//                    Spacer()
                    
                    // Основной контент - карточки настроек
                    VStack(spacing: 15) {
                            // About the app
                            NavigationLink(destination: AboutView()) {
                                HStack {
                                    Text("About the app")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.yellow)
                                        .font(.title3)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                            .buttonStyle(PlainButtonStyle())
                        
                        // Notification
                        HStack {
                            Text("Notification")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Toggle("", isOn: $notificationsEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        // History
                        HStack {
                            Text("History")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: { showingClearHistoryAlert = true }) {
                                Text("Clear")
                                    .foregroundColor(.red)
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
                .alert("Clear history", isPresented: $showingClearHistoryAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        clearAllData()
                    }
                } message: {
                    Text("Are you sure you want to delete the entire history? This action cannot be undone.")
                }
    }
    
    private func clearAllData() {
        // Очищаем все данные из UserDefaults с правильными ключами
        UserDefaults.standard.removeObject(forKey: "savedBatches")
        UserDefaults.standard.removeObject(forKey: "savedRecipes")
        UserDefaults.standard.removeObject(forKey: "savedRestraintData")
        
        // Очищаем массивы в менеджерах
        batchManager.batches.removeAll()
        recipeManager.recipes.removeAll()
        restraintManager.restraintData.removeAll()
        
        // Отправляем уведомления об обновлении всех экранов
        NotificationCenter.default.post(name: NSNotification.Name("BatchDeleted"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("RecipeDeleted"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("RestraintDataDeleted"), object: nil)
    }
}

#Preview {
    SettingsView()
}
