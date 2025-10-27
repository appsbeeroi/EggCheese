import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    @EnvironmentObject var recipeManager: RecipeManager
    
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe).environmentObject(recipeManager)) {
            HStack(spacing: 0) {
                
                ZStack {

                    Image("cheeseImage")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading, 15)
                }

                Text(recipe.name)
                    .font(.anton(.title2))
                    .foregroundColor(.brown)
                    .padding(.leading, 15)
                
                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.yellow)
                    .font(.anton(.title3))
                    .padding(.trailing, 15)
            }
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) 
    }
}

#Preview {
    RecipeCardView(recipe: Recipe(
        name: "Golden Soft",
        ingredients: ["Goat milk 8 L", "Rennet 0.5 tsp", "Salt 30 g"],
        preparationSteps: ["Heat milk", "Add rennet", "Mold", "Age"],
        notes: "Very delicate texture"
    ))
    .environmentObject(RecipeManager())
}