//
//  RecipesView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct RecipesView: View {
    @StateObject private var recipeManager = RecipeManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фоновое изображение background из assets
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    if recipeManager.recipes.isEmpty {
                        // Пустое состояние
                        VStack(spacing: 20) {
                            Image("cheeseImage")
                            
                            Text("Recipes not yet available")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("Here will be your own cheese recipes")
                                .font(.body)
                                .foregroundColor(.brown)
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: AddRecipeView()) {
                                Text("Add recipe")
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
                        // Список рецептов
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(recipeManager.recipes) { recipe in
                                    RecipeCardView(recipe: recipe)
                                }
                                
                                // Кнопка добавления
                                NavigationLink(destination: AddRecipeView()) {
                                    Text("Add recipe")
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
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            // Обновляем список при появлении экрана
            recipeManager.loadRecipes()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RecipeAdded"))) { _ in
            // Обновляем список при добавлении нового рецепта
            recipeManager.loadRecipes()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RecipeDeleted"))) { _ in
            // Обновляем список при удалении рецепта
            recipeManager.loadRecipes()
        }
    }
}

#Preview {
    RecipesView()
}
