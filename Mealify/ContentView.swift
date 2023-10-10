import SwiftUI

struct Recipe: Codable {
    let ingredients: [String]
    let instructions: String
    let name: String
}

struct RecipeData: Codable {
    let recipes: [Recipe]
}

struct ContentView: View {
    @State private var recipeData: RecipeData?

    var body: some View {
        VStack {
            if let recipeData = recipeData {
                List(recipeData.recipes, id: \.name) { recipe in
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text("Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                            .font(.subheadline)
                        Text("Instructions: \(recipe.instructions)")
                            .font(.body)
                    }
                }
            } else {
                Text("Loading...")
                    .font(.title)
            }
        }
        .onAppear {
            // Make an HTTP GET request to your Flask server
            guard let url = URL(string: "http://127.0.0.1:5000/api/recipes") else {
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    // Handle the error (e.g., show an error message to the user)
                    return
                }

                if let data = data {
                    // Print the entire response data as a string (for debugging)
                    if let responseDataString = String(data: data, encoding: .utf8) {
                        print("Response Data: \(responseDataString)")
                    }

                    do {
                        let decoder = JSONDecoder()
                        recipeData = try decoder.decode(RecipeData.self, from: data)
                    } catch {
                        print("Error parsing JSON: \(error)")
                        // Handle JSON parsing error
                    }
                }
            }.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
