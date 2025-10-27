import SwiftUI

struct RecipesView: View {
    @StateObject private var recipeManager = RecipeManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Recipes")
                        .font(.anton(.largeTitle))
                        .foregroundColor(.white)
                        .padding(.top, 80)
                    
                    if recipeManager.recipes.isEmpty {
                        
                        VStack(spacing: 20) {
                            Image("cheeseImage")
                            
                            Text("Recipes not yet available")
                                .font(.anton(.title))
                                .foregroundColor(.black)
                            
                            Text("Here will be your own cheese recipes")
                                .font(.anton(.body))
                                .foregroundColor(.brown)
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: AddRecipeView()) {
                                Text("Add recipe")
                                    .font(.anton(.headline))
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
                        
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(recipeManager.recipes) { recipe in
                                    RecipeCardView(recipe: recipe)
                                }

                                NavigationLink(destination: AddRecipeView()) {
                                    Text("Add recipe")
                                        .font(.anton(.headline))
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
            
            recipeManager.loadRecipes()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RecipeAdded"))) { _ in
            
            recipeManager.loadRecipes()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RecipeDeleted"))) { _ in
            
            recipeManager.loadRecipes()
        }
    }
}

#Preview {
    RecipesView()
}