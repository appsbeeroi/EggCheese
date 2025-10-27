//
//  AddRecipeView.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var recipeManager = RecipeManager()
    @State private var name = ""
    @State private var ingredientsText = ""
    @State private var preparationStepsText = ""
    @State private var notes = ""
    @State private var showingRecipeCard = false
    @State private var showingDeleteAlert = false
    
    // Проверяем, заполнены ли все обязательные поля
    private var isFormValid: Bool {
        !name.isEmpty && !ingredientsText.isEmpty && !preparationStepsText.isEmpty
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
                    Text(showingRecipeCard ? "" : "Add recipe")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Кнопки "Edit" и "Delete" или "Done"
                    if showingRecipeCard {
                        HStack(spacing: 15) {
                            Button(action: { showingRecipeCard = false }) {
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
                        Button(action: { saveRecipe() }) {
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
                if !showingRecipeCard {
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
                                
                                // Ingredients
                                HStack {
                                    TextField("Ingredients", text: $ingredientsText, axis: .vertical)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !ingredientsText.isEmpty {
                                        Button(action: { ingredientsText = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .frame(minHeight: 80)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Preparation Steps
                                HStack {
                                    TextField("Preparation Steps", text: $preparationStepsText, axis: .vertical)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !preparationStepsText.isEmpty {
                                        Button(action: { preparationStepsText = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .frame(minHeight: 80)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Notes
                                HStack {
                                    TextField("Notes", text: $notes, axis: .vertical)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    if !notes.isEmpty {
                                        Button(action: { notes = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .frame(minHeight: 80)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            
                            Spacer(minLength: 100) // Отступ для таббара
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                } else {
                    // Карточка рецепта
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            // Иконка рецепта
                            Image("cheeseImage")
                            
                            // Название рецепта
                            
                            // Детали
                            VStack(alignment: .leading, spacing: 15) {
                                Text(name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                if !notes.isEmpty {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Notes")
                                            .font(.headline)
                                            .foregroundColor(.brown)
                                        Text(notes)
                                            .font(.body)
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Ingredients")
                                        .font(.headline)
                                        .foregroundColor(.brown)
                                    ForEach(ingredientsText.components(separatedBy: "\n").filter { !$0.isEmpty }, id: \.self) { ingredient in
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
                                        .font(.headline)
                                        .foregroundColor(.brown)
                                    ForEach(Array(preparationStepsText.components(separatedBy: "\n").filter { !$0.isEmpty }.enumerated()), id: \.offset) { index, step in
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
        }
        .navigationBarHidden(true)
        .onTapGesture {
            // Скрываем клавиатуру при нажатии на экран
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
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
                // Удаляем только что созданный рецепт
                deleteCreatedRecipe()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
    }
    
    private func saveRecipe() {
        // Создаем новый рецепт
        let newRecipe = Recipe(
            name: name,
            ingredients: ingredientsText.components(separatedBy: "\n").filter { !$0.isEmpty },
            preparationSteps: preparationStepsText.components(separatedBy: "\n").filter { !$0.isEmpty },
            notes: notes
        )
        
        // Сохраняем в UserDefaults
        recipeManager.addRecipe(newRecipe)
        
        // Отправляем уведомление об добавлении рецепта
        NotificationCenter.default.post(name: NSNotification.Name("RecipeAdded"), object: nil)
        
        // Показываем карточку рецепта
        showingRecipeCard = true
    }
    
    private func deleteCreatedRecipe() {
        // Удаляем последний добавленный рецепт (только что созданный)
        let userDefaults = UserDefaults.standard
        let recipesKey = "savedRecipes"
        
        if let data = userDefaults.data(forKey: recipesKey),
           var recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            // Удаляем последний элемент (только что созданный)
            if !recipes.isEmpty {
                recipes.removeLast()
            }
            
            // Сохраняем обновленный массив
            if let encoded = try? JSONEncoder().encode(recipes) {
                userDefaults.set(encoded, forKey: recipesKey)
            }
        }
        
        // Отправляем уведомление об удалении
        NotificationCenter.default.post(name: NSNotification.Name("RecipeDeleted"), object: nil)
    }
}

#Preview {
    AddRecipeView()
}
