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
    let analyzedInstructions: [AnalyzedInstruction]?
    var ingredients: [Ingredient]?
    // Add other properties as needed
}

struct AnalyzedInstruction: Decodable, Hashable {
    let steps: [Step]
}

struct Step: Decodable, Hashable {
    let number: Int
    let step: String
}

struct Ingredient: Decodable, Hashable {
    let name: String
    let image: String
    let amount: Amount
}

struct Amount: Decodable, Hashable {
    let metric: Metric
    let us: US
}

struct Metric: Decodable, Hashable {
    let value: Double
    let unit: String
}

struct US: Decodable, Hashable {
    let value: Double
    let unit: String
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
                    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "Infinity", negativeInfinity: "-Infinity", nan: "NaN")
                    let response = try decoder.decode(SpoonacularResponse.self, from: data)

                    if let recipes = response.results {
                        var recipesWithIngredients: [Recipe] = []
                        let group = DispatchGroup()

                        for recipe in recipes {
                            group.enter()

                            fetchIngredients(for: recipe.id) { ingredients in
                                var recipeWithIngredients = recipe
                                recipeWithIngredients.ingredients = ingredients
                                recipesWithIngredients.append(recipeWithIngredients)

                                group.leave()
                            }
                        }

                        group.notify(queue: .main) {
                            completion(recipesWithIngredients)
                        }
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

func fetchIngredients(for recipeID: Int, completion: @escaping ([Ingredient]?) -> Void) {
    let ingredientsURLString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(recipeID)/ingredientWidget.json"

    guard let ingredientsURL = URL(string: ingredientsURLString) else {
        print("Invalid ingredients URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: ingredientsURL)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let ingredientsTask = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error fetching ingredients: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("No data received for ingredients")
            completion(nil)
            return
        }

        do {
            let ingredients = try decodeIngredients(from: data)
            completion(ingredients)
        } catch {
            print("Error parsing ingredients JSON: \(error)")
            completion(nil)
        }
    }

    ingredientsTask.resume()
}

func decodeIngredients(from data: Data) throws -> [Ingredient] {
    let decoder = JSONDecoder()

    if let jsonArray = try? decoder.decode([Ingredient].self, from: data) {
        return jsonArray
    } else if let jsonDictionary = try? decoder.decode([String: [Ingredient]].self, from: data),
              let ingredientsArray = jsonDictionary["ingredients"] {
        return ingredientsArray
    } else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Unexpected JSON format"))
    }
}
