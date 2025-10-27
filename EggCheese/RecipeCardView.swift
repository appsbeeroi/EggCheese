//
//  RecipeCardView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            HStack(spacing: 0) {
                // Левая часть - желтый акцент с иконкой сыра
                ZStack {

                    
                    Image("cheeseImage")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading, 15)
                }
                
                // Центральная часть - название рецепта
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.brown)
                    .padding(.leading, 15)
                
                Spacer()
                
                // Правая часть - стрелка
                Image(systemName: "chevron.right")
                    .foregroundColor(.yellow)
                    .font(.title3)
                    .padding(.trailing, 15)
            }
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Убираем стиль кнопки NavigationLink
    }
}

#Preview {
    RecipeCardView(recipe: Recipe(
        name: "Golden Soft",
        ingredients: ["Goat milk 8 L", "Rennet 0.5 tsp", "Salt 30 g"],
        preparationSteps: ["Heat milk", "Add rennet", "Mold", "Age"],
        notes: "Very delicate texture"
    ))
}
