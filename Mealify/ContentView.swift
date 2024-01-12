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
    @State private var isMetricSelected = false

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
                    HStack {
                        Text("Ingredients:")
                            .font(.headline)
                        
                        Spacer()

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
                    ForEach(ingredients, id: \.self) { ingredient in
                        HStack(alignment: .top) { // Still need to figure out alignment
                            let value = isMetricSelected ? ingredient.amount.metric.value : ingredient.amount.us.value
                            let unit = isMetricSelected ? ingredient.amount.metric.unit : ingredient.amount.us.unit

                            Text("\(String(format: "%.1f", value)) \(unit)")
                                .padding(.trailing, 5)
                            Text(ingredient.name)
                        }
                        .padding(.vertical, 5)
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
