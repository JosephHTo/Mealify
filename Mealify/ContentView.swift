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
    @State private var selectedServingSize = 1

    var body: some View {
        ScrollView {
            VStack {
                Text("Recipe ID: \(recipe.id)")
                    .font(.headline)
                Text(recipe.title)
                    .font(.title)
                    .padding()
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
                HStack {
                    Text("Serving Sizes:")
                        .font(.headline)
                        .padding(.top, 10)

                    // Create buttons for 1x, 2x, 3x, 4x
                    ForEach(1...4, id: \.self) { size in
                        Button("\(size)x") {
                            // Update the selected serving size
                            selectedServingSize = size
                        }
                        .padding(8)
                        .background(selectedServingSize == size ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                if let ingredients = recipe.ingredients {
                    Text("Ingredients:")
                        .font(.headline)
                    ForEach(ingredients, id: \.self) { ingredient in
                        VStack(alignment: .leading) {
                            HStack {

                                let metricValue = ingredient.amount.metric.value
                                let metricUnit = ingredient.amount.metric.unit
                                let usValue = ingredient.amount.us.value
                                let usUnit = ingredient.amount.us.unit

                                Text("\(String(format: "%.1f", metricValue as CVarArg)) \(metricUnit) / \(String(format: "%.1f", usValue)) \(usUnit) \(ingredient.name)")
                            }
                            .padding(.vertical, 5)
                        }
                    }
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
