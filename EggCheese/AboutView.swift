//
//  AboutView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                    Text("About the app")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Пустое место для баланса
                    Color.clear
                        .frame(width: 30, height: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 90)
                
                // Основной контент
                ScrollView {
                    VStack(spacing: 30) {
                        // Логотип приложения
                        VStack(spacing: 20) {
                            Image("cheeseImage")
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Text("EggCheese")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.brown)
                            
                            Text("Your Cheese Making Companion")
                                .font(.title3)
                                .foregroundColor(.brown)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        // Описание приложения
                        VStack(alignment: .leading, spacing: 15) {
                            Text("About EggCheese")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.brown)
                            
                            Text("EggCheese is your ultimate companion for cheese making. Track your batches, manage recipes, and monitor the aging process of your artisanal cheeses.")
                                .font(.body)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                            
                            Text("Features:")
                                .font(.headline)
                                .foregroundColor(.brown)
                                .padding(.top, 10)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                FeatureRow(icon: "cheeseImage", text: "Batch Tracking - Monitor your cheese production")
                                FeatureRow(icon: "cheeseImage", text: "Recipe Management - Store and organize your recipes")
                                FeatureRow(icon: "cheeseImage", text: "Aging Control - Track ripening times and readiness")
                                FeatureRow(icon: "cheeseImage", text: "Progress Monitoring - Never miss the perfect moment")
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        // Информация о версии
                        VStack(spacing: 10) {
                            Text("Version 1.0.0")
                                .font(.headline)
                                .foregroundColor(.brown)
                            
                            Text("Made with ❤️ for cheese lovers")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        Spacer(minLength: 100) // Отступ для таббара
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
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
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

#Preview {
    AboutView()
}
