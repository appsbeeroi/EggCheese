//
//  BathView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct BathView: View {
    @StateObject private var batchManager = BatchManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фоновое изображение background из assets
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Batch Counting")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    if batchManager.batches.isEmpty {
                        // Пустое состояние
                        VStack(spacing: 20) {
                            Image("bathImage")
                            
                            Text("No parties yet")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("You have not added a single batch of cheese yet")
                                .font(.body)
                                .foregroundColor(.brown)
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: AddBatchView()) {
                                Text("Add batch")
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
                        // Список batches
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(Array(batchManager.batches.enumerated()), id: \.element.id) { index, batch in
                                    BatchCardView(batch: batch, index: index)
                                }
                                
                                // Кнопка добавления
                                NavigationLink(destination: AddBatchView()) {
                                    Text("Add batch")
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
            batchManager.loadBatches()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BatchAdded"))) { _ in
            // Обновляем список при добавлении нового batch
            batchManager.loadBatches()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BatchDeleted"))) { _ in
            // Обновляем список при удалении batch
            batchManager.loadBatches()
        }
    }
}

#Preview {
    BathView()
}
