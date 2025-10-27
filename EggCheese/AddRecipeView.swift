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

    private var isFormValid: Bool {
        !name.isEmpty && !ingredientsText.isEmpty && !preparationStepsText.isEmpty
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

                    Text(showingRecipeCard ? "" : "Add recipe")
                        .font(.anton(.title))
                        .foregroundColor(.white)
                    
                    Spacer()

                    if showingRecipeCard {
                        HStack(spacing: 15) {
                            Button(action: { showingRecipeCard = false }) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    .font(.anton(.headline))
                            }
                            Button(action: { showingDeleteAlert = true }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .font(.anton(.headline))
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

                if !showingRecipeCard {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            VStack(spacing: 15) {
                                
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
                            
                            Spacer(minLength: 100) 
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                } else {
                    
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            
                            Image("cheeseImage")

                            VStack(alignment: .leading, spacing: 15) {
                                Text(name)
                                    .font(.anton(.title))
                                    .foregroundColor(.black)
                                if !notes.isEmpty {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Notes")
                                            .font(.anton(.headline))
                                            .foregroundColor(.brown)
                                        Text(notes)
                                            .font(.anton(.body))
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Ingredients")
                                        .font(.anton(.headline))
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
                                        .font(.anton(.headline))
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
            
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            
            NotificationCenter.default.post(name: NSNotification.Name("HideTabBar"), object: nil)
        }
        .onDisappear {
            
            NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        }
        .alert("Delete", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                
                deleteCreatedRecipe()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
    }
    
    private func saveRecipe() {
        
        let newRecipe = Recipe(
            name: name,
            ingredients: ingredientsText.components(separatedBy: "\n").filter { !$0.isEmpty },
            preparationSteps: preparationStepsText.components(separatedBy: "\n").filter { !$0.isEmpty },
            notes: notes
        )

        recipeManager.addRecipe(newRecipe)

        NotificationCenter.default.post(name: NSNotification.Name("RecipeAdded"), object: nil)

        showingRecipeCard = true
    }
    
    private func deleteCreatedRecipe() {
        
        let userDefaults = UserDefaults.standard
        let recipesKey = "savedRecipes"
        
        if let data = userDefaults.data(forKey: recipesKey),
           var recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            
            if !recipes.isEmpty {
                recipes.removeLast()
            }

            if let encoded = try? JSONEncoder().encode(recipes) {
                userDefaults.set(encoded, forKey: recipesKey)
            }
        }

        NotificationCenter.default.post(name: NSNotification.Name("RecipeDeleted"), object: nil)
    }
}

#Preview {
    AddRecipeView()
}