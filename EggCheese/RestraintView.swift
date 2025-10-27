//
//  RestraintView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct RestraintView: View {
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
                    Text("Restraint & readiness")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    if restraintManager.restraintData.isEmpty {
                        // Пустое состояние
                        VStack(spacing: 20) {
                            Image("cheeseImage")
                            
                            Text("No retention data")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("There are currently no batches to track ripening times")
                                .font(.body)
                                .foregroundColor(.brown)
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: AddRestraintView()) {
                                Text("Add data")
                                    .font(.headline)
                                    .foregroundColor(.brown)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.yellow)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    } else {
                        // Список restraint данных
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(restraintManager.restraintData) { data in
                                    RestraintCardView(data: data)
                                }
                                
                                // Кнопка добавления
                                NavigationLink(destination: AddRestraintView()) {
                                    Text("Add data")
                                        .font(.headline)
                                        .foregroundColor(.brown)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.yellow)
                                        .cornerRadius(20)
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                        .padding(.bottom, 180)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            // Обновляем список при появлении экрана
            restraintManager.loadRestraintData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RestraintDataAdded"))) { _ in
            // Обновляем список при добавлении новых данных
            restraintManager.loadRestraintData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RestraintDataDeleted"))) { _ in
            // Обновляем список при удалении данных
            restraintManager.loadRestraintData()
        }
    }
}

#Preview {
    RestraintView()
}
