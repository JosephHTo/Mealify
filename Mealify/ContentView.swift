import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = []
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for recipes", text: $searchQuery, onCommit: {
                    fetchRecipes()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                List(recipes, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                        HStack {
                            AsyncImage(url: URL(string: recipe.image)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                } else if phase.error != nil {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                } else {
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .aspectRatio(contentMode: .fit)
                            Text(recipe.title)
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
        }
        .onAppear {
            fetchRecipes()
        }
    }

    func fetchRecipes() {
        fetchSpoonacularRecipes(query: searchQuery) { fetchedRecipes in
            if let recipes = fetchedRecipes {
                self.recipes = recipes
            } else {
                self.recipes = []
            }
        }
    }
}

struct RecipeDetail: View {
    var recipe: Recipe
    @State private var selectedServingSize: Int
    
    init(recipe: Recipe) {
        self.recipe = recipe
        // Initialize selectedServingSize with the value of recipe.servings
        self._selectedServingSize = State(initialValue: recipe.servings)
    }
    
    @State private var isMetricSelected = false

    var body: some View {
        ScrollView {
            VStack {
                Text(recipe.title)
                    .font(.title)
                    .padding()
                
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200) // Adjust the height as needed
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        ProgressView()
                            .frame(height: 200)
                    }
                }
                .aspectRatio(contentMode: .fit)
                
                Text("Summary: \(recipe.summary?.removingHTMLTags() ?? "No summary available")")
                    .font(.subheadline)
                    .padding()

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
            .navigationBarTitle(recipe.title, displayMode: .inline)
        }
    }
}

extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
