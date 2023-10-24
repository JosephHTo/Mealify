import Foundation

struct EdamamResponse: Codable {
    let hits: [RecipeWrapper]
}

struct RecipeWrapper: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let ingredients: [Ingredient]
    let instructions: String? // Make the 'instructions' property optional
}

struct Ingredient: Codable {
    let text: String
    // Add any other properties that may exist in the ingredient dictionaries
}


func fetchRecipes(query: String, completion: @escaping (EdamamResponse?) -> Void) {
    let apiKey = "e3e7cb077906ce5122cbe9ef7b33f887" // Replace with your Edamam API key
    let appID = "c4239607" // Replace with your Edamam app ID
    let apiURL = "https://api.edamam.com/search?q=\(query)&app_id=\(appID)&app_key=\(apiKey)"

    if let url = URL(string: apiURL) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(EdamamResponse.self, from: data)
                    // Print the parsed response
                    print("Parsed Response: \(response)")
                    completion(response)
                } catch let decodingError as DecodingError {
                    print("Decoding Error: \(decodingError)")
                    completion(nil)
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(nil)
                }
            } else {
                print("No data received from the API")
                completion(nil)
            }
        }
        task.resume()
    }
}

