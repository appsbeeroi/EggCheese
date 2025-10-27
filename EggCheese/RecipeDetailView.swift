//
//  RecipeDetailView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let recipe: Recipe
    
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
                    Text("Edit recipe")
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
                
                // Основной контент - карточка рецепта
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        // Иконка рецепта
                        Image("bathImage")
                            .resizable()
                            .frame(width: 60, height: 60)
                        
                        // Название рецепта
                        Text(recipe.name)
                            .font(.anton(.title))
                            .foregroundColor(.brown)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Детали
                        VStack(alignment: .leading, spacing: 15) {
                            if !recipe.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Notes")
                                        .font(.anton(.headline))
                                        .foregroundColor(.brown)
                                    Text(recipe.notes)
                                        .font(.anton(.body))
                                        .foregroundColor(.black)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Ingredients")
                                    .font(.anton(.headline))
                                    .foregroundColor(.brown)
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    HStack {
                                        Text("•")
                                            .foregroundColor(.brown)
                                        Text(ingredient)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Preparation Steps")
                                    .font(.anton(.headline))
                                    .foregroundColor(.brown)
                                ForEach(Array(recipe.preparationSteps.enumerated()), id: \.offset) { index, step in
                                    HStack {
                                        Text("\(index + 1).")
                                            .foregroundColor(.brown)
                                        Text(step)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
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
                // Удаляем напрямую из UserDefaults
                deleteRecipeFromUserDefaults(recipe)
                NotificationCenter.default.post(name: NSNotification.Name("RecipeDeleted"), object: nil)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
    }
    
    private func deleteRecipeFromUserDefaults(_ recipe: Recipe) {
        let userDefaults = UserDefaults.standard
        let recipesKey = "savedRecipes"
        
        if let data = userDefaults.data(forKey: recipesKey),
           var recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            // Удаляем рецепт из массива
            recipes.removeAll { $0.id == recipe.id }
            
            // Сохраняем обновленный массив
            if let encoded = try? JSONEncoder().encode(recipes) {
                userDefaults.set(encoded, forKey: recipesKey)
            }
        }
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe(
        name: "Golden Soft",
        ingredients: ["Goat milk 8 L", "Rennet 0.5 tsp", "Salt 30 g"],
        preparationSteps: ["Heat milk", "Add rennet", "Mold", "Age"],
        notes: "Very delicate texture"
    ))
}
