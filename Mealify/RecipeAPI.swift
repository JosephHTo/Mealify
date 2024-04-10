import Foundation

struct SpoonacularResponse: Decodable {
    let results: [Recipe]?
    let offset: Int?
    let number: Int?
    let totalResults: Int?
}

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let summary: String?
    let analyzedInstructions: [AnalyzedInstruction]?
    var ingredients: [Ingredient]?
    let servings: Int
    let readyInMinutes: Int
    let pricePerServing: Double
    let diets: [String]?
}

struct AnalyzedInstruction: Codable, Hashable {
    let steps: [Step]
}

struct Step: Codable, Hashable {
    let number: Int
    let step: String
}

struct Ingredient: Codable, Hashable {
    let name: String
    let image: String
    let amount: Amount
}

struct Amount: Codable, Hashable {
    let metric: Metric
    let us: US
}

struct Metric: Codable, Hashable {
    let value: Double
    let unit: String
}

struct US: Codable, Hashable {
    let value: Double
    let unit: String
}

struct NutrientsContainer: Codable {
    let nutrients: [Nutrient]?
}

struct Nutrient: Codable, Hashable {
    let name: String
    let amount: Double
    let unit: String
}

let headers = [
    "X-RapidAPI-Key": "a5b4aa7fb8msh071f57fee4ea659p10de72jsn2b47be3588c8",
    "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
]

func fetchSpoonacularRecipes(query: String,
                              maxReadyTime: Int? = nil,
                              diet: String? = nil,
                              intolerances: String? = nil,
                              includeIngredients: String? = nil,
                              excludeIngredients: String? = nil,
                              minCarbs: Int? = nil,
                              maxCarbs: Int? = nil,
                              minProtein: Int? = nil,
                              maxProtein: Int? = nil,
                              minCalories: Int? = nil,
                              maxCalories: Int? = nil,
                              minFat: Int? = nil,
                              maxFat: Int? = nil,
                              minAlcohol: Int? = nil,
                              maxAlcohol: Int? = nil,
                              minCaffeine: Int? = nil,
                              maxCaffeine: Int? = nil,
                              minCopper: Int? = nil,
                              maxCopper: Int? = nil,
                              minCalcium: Int? = nil,
                              maxCalcium: Int? = nil,
                              minCholine: Int? = nil,
                              maxCholine: Int? = nil,
                              minCholesterol: Int? = nil,
                              maxCholesterol: Int? = nil,
                              minFluoride: Int? = nil,
                              maxFluoride: Int? = nil,
                              minSaturatedFat: Int? = nil,
                              maxSaturatedFat: Int? = nil,
                              minVitaminA: Int? = nil,
                              maxVitaminA: Int? = nil,
                              minVitaminC: Int? = nil,
                              maxVitaminC: Int? = nil,
                              minVitaminD: Int? = nil,
                              maxVitaminD: Int? = nil,
                              minVitaminE: Int? = nil,
                              maxVitaminE: Int? = nil,
                              minVitaminK: Int? = nil,
                              maxVitaminK: Int? = nil,
                              minVitaminB1: Int? = nil,
                              maxVitaminB1: Int? = nil,
                              minVitaminB2: Int? = nil,
                              maxVitaminB2: Int? = nil,
                              minVitaminB5: Int? = nil,
                              maxVitaminB5: Int? = nil,
                              minVitaminB3: Int? = nil,
                              maxVitaminB3: Int? = nil,
                              minVitaminB6: Int? = nil,
                              maxVitaminB6: Int? = nil,
                              minVitaminB12: Int? = nil,
                              maxVitaminB12: Int? = nil,
                              minFiber: Int? = nil,
                              maxFiber: Int? = nil,
                              minFolate: Int? = nil,
                              maxFolate: Int? = nil,
                              minFolicAcid: Int? = nil,
                              maxFolicAcid: Int? = nil,
                              minIodine: Int? = nil,
                              maxIodine: Int? = nil,
                              minIron: Int? = nil,
                              maxIron: Int? = nil,
                              minMagnesium: Int? = nil,
                              maxMagnesium: Int? = nil,
                              minManganese: Int? = nil,
                              maxManganese: Int? = nil,
                              minPhosphorus: Int? = nil,
                              maxPhosphorus: Int? = nil,
                              minPotassium: Int? = nil,
                              maxPotassium: Int? = nil,
                              minSelenium: Int? = nil,
                              maxSelenium: Int? = nil,
                              minSodium: Int? = nil,
                              maxSodium: Int? = nil,
                              minSugar: Int? = nil,
                              maxSugar: Int? = nil,
                              minZinc: Int? = nil,
                              maxZinc: Int? = nil,
                              completion: @escaping ([Recipe]?) -> Void) {
    var urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?"

    var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "instructionsRequired", value: "true"),
        URLQueryItem(name: "fillIngredients", value: "false"),
        URLQueryItem(name: "addRecipeInformation", value: "true"),
        URLQueryItem(name: "ignorePantry", value: "true"),
        URLQueryItem(name: "limitLicense", value: "false")
    ]

    if let maxReadyTime = maxReadyTime {
        queryItems.append(URLQueryItem(name: "maxReadyTime", value: "\(maxReadyTime)"))
    }

    if let diet = diet {
        queryItems.append(URLQueryItem(name: "diet", value: "\(diet)"))
    }

    if let intolerances = intolerances {
        queryItems.append(URLQueryItem(name: "intolerances", value: "\(intolerances)"))
    }
    
    if let includeIngredients = includeIngredients {
        queryItems.append(URLQueryItem(name: "includeIngredients", value: "\(includeIngredients)"))
    }
    
    if let excludeIngredients = excludeIngredients {
        queryItems.append(URLQueryItem(name: "excludeIngredients", value: "\(excludeIngredients)"))
    }
    
    if let minCarbs = minCarbs {
        queryItems.append(URLQueryItem(name: "minCarbs", value: "\(minCarbs)"))
    }
    
    if let maxCarbs = maxCarbs {
        queryItems.append(URLQueryItem(name: "maxCarbs", value: "\(maxCarbs)"))
    }
    
    if let minProtein = minProtein {
        queryItems.append(URLQueryItem(name: "minProtein", value: "\(minProtein)"))
    }
    
    if let maxProtein = maxProtein {
        queryItems.append(URLQueryItem(name: "maxProtein", value: "\(maxProtein)"))
    }
    
    if let minCalories = minCalories {
        queryItems.append(URLQueryItem(name: "minCalories", value: "\(minCalories)"))
    }
    
    if let maxCalories = maxCalories {
        queryItems.append(URLQueryItem(name: "maxCalories", value: "\(maxCalories)"))
    }
    
    if let minFat = minFat {
        queryItems.append(URLQueryItem(name: "minFat", value: "\(minFat)"))
    }
    
    if let maxFat = maxFat {
        queryItems.append(URLQueryItem(name: "maxFat", value: "\(maxFat)"))
    }
    
    if let minAlcohol = minAlcohol {
        queryItems.append(URLQueryItem(name: "minAlcohol", value: "\(minAlcohol)"))
    }
    
    if let maxAlcohol = maxAlcohol {
        queryItems.append(URLQueryItem(name: "maxAlcohol", value: "\(maxAlcohol)"))
    }
    
    if let minCaffeine = minCaffeine {
        queryItems.append(URLQueryItem(name: "minCaffeine", value: "\(minCaffeine)"))
    }
    
    if let maxCaffeine = maxCaffeine {
        queryItems.append(URLQueryItem(name: "maxCaffeine", value: "\(maxCaffeine)"))
    }
    
    if let minCopper = minCopper {
        queryItems.append(URLQueryItem(name: "minCopper", value: "\(minCopper)"))
    }
    
    if let maxCopper = maxCopper {
        queryItems.append(URLQueryItem(name: "maxCopper", value: "\(maxCopper)"))
    }
    
    if let minCalcium = minCalcium {
        queryItems.append(URLQueryItem(name: "minCalcium", value: "\(minCalcium)"))
    }
    
    if let maxCalcium = maxCalcium {
        queryItems.append(URLQueryItem(name: "maxCalcium", value: "\(maxCalcium)"))
    }
    
    if let minCholine = minCholine {
        queryItems.append(URLQueryItem(name: "minCholine", value: "\(minCholine)"))
    }
    
    if let maxCholine = maxCholine {
        queryItems.append(URLQueryItem(name: "maxCholine", value: "\(maxCholine)"))
    }
    
    if let minCholesterol = minCholesterol {
        queryItems.append(URLQueryItem(name: "minCholesterol", value: "\(minCholesterol)"))
    }
    
    if let maxCholesterol = maxCholesterol {
        queryItems.append(URLQueryItem(name: "maxCholesterol", value: "\(maxCholesterol)"))
    }
    
    if let minFluoride = minFluoride {
        queryItems.append(URLQueryItem(name: "minFluoride", value: "\(minFluoride)"))
    }
    
    if let maxFluoride = maxFluoride {
        queryItems.append(URLQueryItem(name: "maxFluoride", value: "\(maxFluoride)"))
    }
    
    if let minSaturatedFat = minSaturatedFat {
        queryItems.append(URLQueryItem(name: "minSaturatedFat", value: "\(minSaturatedFat)"))
    }
    
    if let maxSaturatedFat = maxSaturatedFat {
        queryItems.append(URLQueryItem(name: "maxSaturatedFat", value: "\(maxSaturatedFat)"))
    }
    
    if let minVitaminA = minVitaminA {
        queryItems.append(URLQueryItem(name: "minVitaminA", value: "\(minVitaminA)"))
    }
    
    if let maxVitaminA = maxVitaminA {
        queryItems.append(URLQueryItem(name: "maxVitaminA", value: "\(maxVitaminA)"))
    }
    
    if let minVitaminC = minVitaminC {
        queryItems.append(URLQueryItem(name: "minVitaminC", value: "\(minVitaminC)"))
    }
    
    if let maxVitaminC = maxVitaminC {
        queryItems.append(URLQueryItem(name: "maxVitaminC", value: "\(maxVitaminC)"))
    }
    
    if let minVitaminD = minVitaminD {
        queryItems.append(URLQueryItem(name: "minVitaminD", value: "\(minVitaminD)"))
    }
    
    if let maxVitaminD = maxVitaminD {
        queryItems.append(URLQueryItem(name: "maxVitaminD", value: "\(maxVitaminD)"))
    }
    
    if let minVitaminE = minVitaminE {
        queryItems.append(URLQueryItem(name: "minVitaminE", value: "\(minVitaminE)"))
    }
    
    if let maxVitaminE = maxVitaminE {
        queryItems.append(URLQueryItem(name: "maxVitaminE", value: "\(maxVitaminE)"))
    }
    
    if let minVitaminK = minVitaminK {
        queryItems.append(URLQueryItem(name: "minVitaminK", value: "\(minVitaminK)"))
    }
    
    if let maxVitaminK = maxVitaminK {
        queryItems.append(URLQueryItem(name: "maxVitaminK", value: "\(maxVitaminK)"))
    }
    
    if let minVitaminB1 = minVitaminB1 {
        queryItems.append(URLQueryItem(name: "minVitaminB1", value: "\(minVitaminB1)"))
    }
    
    if let maxVitaminB1 = maxVitaminB1 {
        queryItems.append(URLQueryItem(name: "maxVitaminB1", value: "\(maxVitaminB1)"))
    }
    
    if let minVitaminB2 = minVitaminB2 {
        queryItems.append(URLQueryItem(name: "minVitaminB2", value: "\(minVitaminB2)"))
    }
    
    if let maxVitaminB2 = maxVitaminB2 {
        queryItems.append(URLQueryItem(name: "maxVitaminB2", value: "\(maxVitaminB2)"))
    }
    
    if let minVitaminB5 = minVitaminB5 {
        queryItems.append(URLQueryItem(name: "minVitaminB5", value: "\(minVitaminB5)"))
    }
    
    if let maxVitaminB5 = maxVitaminB5 {
        queryItems.append(URLQueryItem(name: "maxVitaminB5", value: "\(maxVitaminB5)"))
    }
    
    if let minVitaminB3 = minVitaminB3 {
        queryItems.append(URLQueryItem(name: "minVitaminB3", value: "\(minVitaminB3)"))
    }
    
    if let maxVitaminB3 = maxVitaminB3 {
        queryItems.append(URLQueryItem(name: "maxVitaminB3", value: "\(maxVitaminB3)"))
    }
    
    if let minVitaminB6 = minVitaminB6 {
        queryItems.append(URLQueryItem(name: "minVitaminB6", value: "\(minVitaminB6)"))
    }
    
    if let maxVitaminB6 = maxVitaminB6 {
        queryItems.append(URLQueryItem(name: "maxVitaminB6", value: "\(maxVitaminB6)"))
    }
    
    if let minVitaminB12 = minVitaminB12 {
        queryItems.append(URLQueryItem(name: "minVitaminB12", value: "\(minVitaminB12)"))
    }
    
    if let maxVitaminB12 = maxVitaminB12 {
        queryItems.append(URLQueryItem(name: "maxVitaminB12", value: "\(maxVitaminB12)"))
    }
    
    if let minFiber = minFiber {
        queryItems.append(URLQueryItem(name: "minFiber", value: "\(minFiber)"))
    }
    
    if let maxFiber = maxFiber {
        queryItems.append(URLQueryItem(name: "maxFiber", value: "\(maxFiber)"))
    }
    
    if let minFolate = minFolate {
        queryItems.append(URLQueryItem(name: "minFolate", value: "\(minFolate)"))
    }
    
    if let maxFolate = maxFolate {
        queryItems.append(URLQueryItem(name: "maxFolate", value: "\(maxFolate)"))
    }
    
    if let minFolicAcid = minFolicAcid {
        queryItems.append(URLQueryItem(name: "minFolicAcid", value: "\(minFolicAcid)"))
    }
    
    if let maxFolicAcid = maxFolicAcid {
        queryItems.append(URLQueryItem(name: "maxFolicAcid", value: "\(maxFolicAcid)"))
    }
    
    if let minIodine = minIodine {
        queryItems.append(URLQueryItem(name: "minIodine", value: "\(minIodine)"))
    }
    
    if let maxIodine = maxIodine {
        queryItems.append(URLQueryItem(name: "maxIodine", value: "\(maxIodine)"))
    }
    
    if let minIron = minIron {
        queryItems.append(URLQueryItem(name: "minIron", value: "\(minIron)"))
    }
    
    if let maxIron = maxIron {
        queryItems.append(URLQueryItem(name: "maxIron", value: "\(maxIron)"))
    }
    
    if let minMagnesium = minMagnesium {
        queryItems.append(URLQueryItem(name: "minMagnesium", value: "\(minMagnesium)"))
    }
    
    if let maxMagnesium = maxMagnesium {
        queryItems.append(URLQueryItem(name: "maxMagnesium", value: "\(maxMagnesium)"))
    }
    
    if let minManganese = minManganese {
        queryItems.append(URLQueryItem(name: "minManganese", value: "\(minManganese)"))
    }
    
    if let maxManganese = maxManganese {
        queryItems.append(URLQueryItem(name: "maxManganese", value: "\(maxManganese)"))
    }
    
    if let minPhosphorus = minPhosphorus {
        queryItems.append(URLQueryItem(name: "minPhosphorus", value: "\(minPhosphorus)"))
    }
    
    if let maxPhosphorus = maxPhosphorus {
        queryItems.append(URLQueryItem(name: "maxPhosphorus", value: "\(maxPhosphorus)"))
    }
    
    if let minPotassium = minPotassium {
        queryItems.append(URLQueryItem(name: "minPotassium", value: "\(minPotassium)"))
    }
    
    if let maxPotassium = maxPotassium {
        queryItems.append(URLQueryItem(name: "maxPotassium", value: "\(maxPotassium)"))
    }
    
    if let minSelenium = minSelenium {
        queryItems.append(URLQueryItem(name: "minSelenium", value: "\(minSelenium)"))
    }
    
    if let maxSelenium = maxSelenium {
        queryItems.append(URLQueryItem(name: "maxSelenium", value: "\(maxSelenium)"))
    }
    
    if let minSodium = minSodium {
        queryItems.append(URLQueryItem(name: "minSodium", value: "\(minSodium)"))
    }
    
    if let maxSodium = maxSodium {
        queryItems.append(URLQueryItem(name: "maxSodium", value: "\(maxSodium)"))
    }
    
    if let minSugar = minSugar {
        queryItems.append(URLQueryItem(name: "minSugar", value: "\(minSugar)"))
    }
    
    if let maxSugar = maxSugar {
        queryItems.append(URLQueryItem(name: "maxSugar", value: "\(maxSugar)"))
    }
    
    if let minZinc = minZinc {
        queryItems.append(URLQueryItem(name: "minZinc", value: "\(minZinc)"))
    }
    
    if let maxZinc = maxZinc {
        queryItems.append(URLQueryItem(name: "maxZinc", value: "\(maxZinc)"))
    }

    let query = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
    urlString.append(query)
    print(query)

    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
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

func fetchNutrients(for recipeID: Int, completion: @escaping ([Nutrient]?) -> Void) {
    let nutrientsURLString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(recipeID)/nutritionWidget.json"
    
    guard let nutrientsURL = URL(string: nutrientsURLString) else {
        print("Invalid nutrients URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: nutrientsURL)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let nutrientsTask = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error fetching nutrients: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("No data received for nutrients")
            completion(nil)
            return
        }

        do {
            let nutrients = try decodeNutrients(from: data)
            completion(nutrients)
        } catch {
            print("Error parsing nutrients JSON: \(error)")
            completion(nil)
        }
    }

    nutrientsTask.resume()
}

func decodeNutrients(from data: Data) throws -> [Nutrient]? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let nutrientsContainer = try decoder.decode(NutrientsContainer.self, from: data)
    return nutrientsContainer.nutrients
}
