import Foundation

struct SpoonacularResponse: Decodable {
    let results: [Recipe]?
    let offset: Int?
    let number: Int?
    let totalResults: Int?
    // Add other properties as needed
}

struct Recipe: Decodable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let summary: String?
    let analyzedInstructions: [AnalyzedInstruction]? // Add the analyzedInstructions field
    // Add other properties as needed
}

struct AnalyzedInstruction: Decodable, Hashable {
    let steps: [Step]
}

struct Step: Decodable, Hashable {
    let number: Int
    let step: String
}

let headers = [
    "X-RapidAPI-Key": "a5b4aa7fb8msh071f57fee4ea659p10de72jsn2b47be3588c8",
    "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
]

func fetchSpoonacularRecipes(query: String, completion: @escaping ([Recipe]?) -> Void) {
    let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=\(query)&instructionsRequired=true&fillIngredients=false&addRecipeInformation=true&ignorePantry=true&limitLicense=false"

    if let url = URL(string: urlString) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SpoonacularResponse.self, from: data)

                    if let recipes = response.results {
                        completion(recipes)
                    } else {
                        print("No recipes found in the response")
                        completion(nil)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(nil)
                }
            } else {
                print("No data received from the API")
                completion(nil)
            }
        }
        dataTask.resume()
    }
}
