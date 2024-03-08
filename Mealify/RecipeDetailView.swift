import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe
    @State private var selectedServingSize: Int
    @State private var isSaved: Bool = false
    @EnvironmentObject var userData: UserData

    init(recipe: Recipe) {
        self.recipe = recipe
        // Initialize selectedServingSize with the value of recipe.servings
        self._selectedServingSize = State(initialValue: recipe.servings)

        // Check if the recipe is saved in UserDefaults
        if let savedRecipes = UserDefaults.standard.data(forKey: "savedRecipes") {
            let decoder = JSONDecoder()
            if let decodedRecipes = try? decoder.decode([Recipe].self, from: savedRecipes) {
                isSaved = decodedRecipes.contains { $0.id == recipe.id }
            }
        }
    }

    @State private var isMetricSelected = false

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Text(recipe.title)
                            .font(.title)
                            .padding()
                    }
                    .layoutPriority(1)

                    Spacer()

                    Button(action: {
                        // Handle save/delete button tap
                        isSaved.toggle()
                        saveRecipe()
                    }) {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .foregroundColor(isSaved ? .red : .gray)
                            .padding()
                            .font(.title)
                    }
                }
                .padding()

                AsyncImage(url: URL(string: recipe.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(5)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(5)
                    } else {
                        ProgressView()
                            .frame(height: 200)
                            .cornerRadius(5)
                    }
                }
                .aspectRatio(contentMode: .fit)

                Text("\(recipe.summary?.removingHTMLTags() ?? "No summary available")")
                    .font(.subheadline)
                    .padding()

                Text("Total time: \(recipe.readyInMinutes)")
                    .multilineTextAlignment(.leading)
                    .padding()

                // TODO: Display all diets/allergens given from API list

                if let analyzedInstructions = recipe.analyzedInstructions {
                    Text("Instructions:")
                        .font(.headline)
                    ForEach(analyzedInstructions, id: \.self) { analyzedInstruction in
                        ForEach(analyzedInstruction.steps, id: \.self) { step in
                            Text("Step \(step.number): \(step.step.trimmingCharacters(in: .whitespacesAndNewlines))")
                                .padding()
                        }
                    }
                }
                if let ingredients = recipe.ingredients {
                    Text("Ingredients:")
                        .font(.headline)
                    HStack {

                        VStack {
                            // Serving size text display
                            Text("Serving Size: \(selectedServingSize)")
                                .font(.headline)
                                .offset(y:20)
                            // Serving size slider
                            HStack {
                                Slider(
                                    value: Binding(
                                        get: { Double(selectedServingSize) },
                                        set: { selectedServingSize = Int($0) }
                                    ),
                                    in: 1...20,
                                    step: 1
                                ) {
                                    Text("Serving Size")
                                } minimumValueLabel: {
                                    Text("1")
                                } maximumValueLabel: {
                                    Text("20")
                                } onEditingChanged: { _ in
                                    // Handle the selected serving size change if needed
                                }
                                .padding()
                                .accentColor(.blue)
                            }
                        }

                        HStack {
                            Button("US") {
                                // Toggle to US measurements
                                isMetricSelected = false
                            }
                            .padding(8)
                            .background(!isMetricSelected ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)

                            Button("Metric") {
                                // Toggle to metric measurements
                                isMetricSelected = true
                            }
                            .padding(8)
                            .background(isMetricSelected ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            let baseValue = isMetricSelected ? ingredient.amount.metric.value : ingredient.amount.us.value
                            let unit = isMetricSelected ? ingredient.amount.metric.unit : ingredient.amount.us.unit

                            // Calculate the adjusted value based on selectedServingSize
                            let adjustedValue = (baseValue / Double(recipe.servings)) * Double(selectedServingSize)

                            Text("\(String(format: "%.1f", adjustedValue)) \(unit) \(ingredient.name)")
                                .multilineTextAlignment(.leading) // Left-align the text
                                .padding(.trailing, 5)
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.vertical, 1)
                }
                Spacer()
            }
            .onAppear {
                // Save the recipe to recentRecipes when it appears
                userData.saveRecentRecipe(recipe)
            }
        }
    }

    private func saveRecipe() {
        var savedRecipes: [Recipe]

        // Fetch the saved recipes from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "savedRecipes") {
            let decoder = JSONDecoder()
            if let decodedRecipes = try? decoder.decode([Recipe].self, from: data) {
                savedRecipes = decodedRecipes
            } else {
                savedRecipes = []
            }
        } else {
            savedRecipes = []
        }

        // Check if the recipe is already saved
        if let index = savedRecipes.firstIndex(where: { $0.id == recipe.id }) {
            // Recipe is already saved, remove it
            savedRecipes.remove(at: index)
        } else {
            // Recipe is not saved, add it
            savedRecipes.append(recipe)
        }

        // Print the current list of saved recipes for debugging
        print("Current saved recipes:")
        for savedRecipe in savedRecipes {
            print(savedRecipe.title)
        }

        // Save the updated list of saved recipes to UserDefaults
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(savedRecipes) {
            UserDefaults.standard.set(encodedData, forKey: "savedRecipes")
        }
    }
}
