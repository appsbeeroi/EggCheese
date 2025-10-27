import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var recipeManager: RecipeManager
    let recipe: Recipe
    
    @State private var showingDeleteAlert = false
    
    private var recipeIndex: Int? {
        recipeManager.recipes.firstIndex { $0.name == recipe.name && $0.ingredients == recipe.ingredients }
    }
    
    var body: some View {
        ZStack {
            
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Button(action: { dismiss() }) {
                        Image("backButton")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()

                    Text("Recipe Details")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()

                    HStack(spacing: 15) {
                        if let index = recipeIndex {
                            NavigationLink(destination: AddRecipeView(editingRecipe: recipe, editingIndex: index).environmentObject(recipeManager)) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    .font(.anton(.headline))
                            }
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            Text("Delete")
                                .foregroundColor(.red)
                                .font(.anton(.headline))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 90)

                VStack {
                    Spacer()
                        .frame(height: 20)
                    
                    VStack(spacing: 20) {
                        
                        Image("bathImage")
                            .resizable()
                            .frame(width: 60, height: 60)

                        Text(recipe.name)
                            .font(.anton(.title))
                            .foregroundColor(.brown)
                            .frame(maxWidth: .infinity, alignment: .leading)

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
            
            NotificationCenter.default.post(name: NSNotification.Name("HideTabBar"), object: nil)
        }
        .onDisappear {
            
            NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        }
        .alert("Delete", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                
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
            
            recipes.removeAll { $0.id == recipe.id }

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
    .environmentObject(RecipeManager())
}
