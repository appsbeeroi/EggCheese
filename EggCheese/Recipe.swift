import Foundation

struct Recipe: Codable, Identifiable {
    let id = UUID()
    let name: String
    let ingredients: [String]
    let preparationSteps: [String]
    let notes: String
    
    init(name: String, ingredients: [String], preparationSteps: [String], notes: String) {
        self.name = name
        self.ingredients = ingredients
        self.preparationSteps = preparationSteps
        self.notes = notes
    }
}

class RecipeManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    private let userDefaults = UserDefaults.standard
    private let recipesKey = "savedRecipes"
    
    init() {
        loadRecipes()
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes()
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        saveRecipes()
    }
    
    func loadRecipes() {
        if let data = userDefaults.data(forKey: recipesKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decoded
            
            objectWillChange.send()
        }
    }
    
    private func saveRecipes() {
        if let encoded = try? JSONEncoder().encode(recipes) {
            userDefaults.set(encoded, forKey: recipesKey)
        }
    }
}