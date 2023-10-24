import SwiftUI

struct ContentView: View {
    @State private var recipeData: EdamamResponse?

    var body: some View {
        VStack {
            if let recipeData = recipeData {
                List(recipeData.hits, id: \.recipe.label) { recipeWrapper in
                    let recipe = recipeWrapper.recipe
                    VStack(alignment: .leading) {
                        Text(recipe.label)
                            .font(.headline)
                        
                        // Extract and join the 'text' property from each Ingredient object
                        Text("Ingredients: \(recipe.ingredients.map { $0.text }.joined(separator: ", "))")
                            .font(.subheadline)
                        
                        Text("Instructions: \(recipe.instructions ?? "No instructions available")")
                            .font(.body)
                    }
                }
            } else {
                Text("Loading...")
                    .font(.title)
            }
        }
        .onAppear {
            fetchRecipes(query: "chicken") { response in
                if let response = response {
                    recipeData = response
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
