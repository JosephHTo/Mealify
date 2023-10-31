import SwiftUI

struct SpoonacularRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var recipes: [Recipe]?

    var body: some View {
        NavigationView {
            if let recipes = recipes {
                List(recipes, id: \.title) { recipe in
                    NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                        Text(recipe.title)
                    }
                }
                .navigationTitle("Spoonacular Recipes")
            } else {
                Text("Loading...") // You can show a loading message while fetching data
            }
        }
        .onAppear {
            // Fetch recipes when the view appears
            fetchSpoonacularRecipes(query: "pasta") { recipes in
                self.recipes = recipes
            }
        }
    }
}

struct RecipeDetail: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.title)
                Text("Instructions:")
                    .font(.headline)
                Text(recipe.instructions ?? "No instructions available")
                // You may also display ingredients here
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
    }
}
