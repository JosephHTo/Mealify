import Foundation

struct Address: Codable {
    let addressLine1: String
    let city: String
    let state: String
    let zipCode: String
    let county: String
}

struct Geolocation: Codable {
    let latitude: Double
    let longitude: Double
    let latLng: String
}

struct Hours: Codable {
    let timezone: String
    let gmtOffset: String
    let open24: Bool
    let monday: DayHours
}

struct DayHours: Codable {
    let open: String
    let close: String
    let open24: Bool
}

struct LocationResponse: Codable {
    let data: [Location]
}

struct Location: Codable {
    let locationId: String?
    let chain: String
    let address: Address
    let geolocation: Geolocation
    let name: String
    let hours: Hours
    let phone: String
}

struct ProductResponse: Codable {
    let data: [Product]
    let meta: Meta
}

struct Meta: Codable {
    // Define properties for the Meta object if needed
}

struct Product: Codable {
    let productId: String
    let aisleLocations: [AisleLocation]
    let brand: String
    let categories: [String]
    let countryOrigin: String
    let description: String
    let items: [Item]
    let itemInformation: ItemInformation
    let temperature: Temperature
    let images: [ProductImage]
    let taxonomies: [Taxonomy]
    let upc: String
}

struct Item: Codable {
    let itemId: String
    let inventory: Inventory
    let favorite: Bool
    let fulfillment: Fulfillment
    let price: Price
    let size: String
}

struct Inventory: Codable {
    let stockLevel: String
}

struct Fulfillment: Codable {
    let curbside: Bool
    let delivery: Bool
}

struct Price: Codable {
    let regular: Double
    let promo: Double
}

struct Temperature: Codable {
    let indicator: String
    let heatSensitive: Bool
}

struct AisleLocation: Codable {
    // Define properties for AisleLocation
}

struct ItemInformation: Codable {
    // Define properties for ItemInformation
}

struct ProductImage: Codable {
    // Define properties for Image
}

struct Taxonomy: Codable {
    // Define properties for Taxonomy
}

// Add Codable conformance for nested objects
extension AisleLocation: Equatable {}
extension ItemInformation: Equatable {}
extension Temperature: Equatable {}
extension ProductImage: Equatable {}
extension Taxonomy: Equatable {}
// Product image structs would go here

// Function to search products
func searchProducts(term: String, userData: UserData, completion: @escaping (Result<[Product], Error>) -> Void) {
    // Fetch access token (Need to adjust this method based on the API, access token is different for product api)
    KrogerAPI.obtainAccessToken(clientID: "mealify-34d6842b96b4c261bee01bff3606dd8e3074727131337427991", clientSecret: "hRiEuSfza9RVBOVulZT3V6C5wRO0QsKS9RZtNP3N", scope: "product.compact") { result in
        switch result {
        case .success(let accessToken):
            // Build the product search URL using the obtained access token and optional locationId
            var productsUrl = "https://api.kroger.com/v1/products?filter.term=\(term)"
            if let locationId = userData.selectedLocationId {
                productsUrl += "&filter.locationId=\(locationId)"
            }
            
            guard let url = URL(string: productsUrl) else {
                print("Invalid URL")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
            
            // Make the request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    return
                }

                // Print the raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")
                }

                do {
                    // Update decoding to match the actual JSON structure
                    let decoder = JSONDecoder()
                    let productsResponse = try decoder.decode(ProductResponse.self, from: data)
                    let products = productsResponse.data
                    completion(.success(products))
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }

            task.resume()
            
        case .failure(let error):
            print("Error obtaining access token: \(error)")
            completion(.failure(error))
        }
    }
}

// Function to fetch locations
func getLocations(zipCode: String, completion: @escaping (Result<[Location], Error>) -> Void) {
    // Validate zip code
    guard zipCode.count == 5, zipCode.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid zip code"])))
        return
    }
    
    // Fetch access token
    KrogerAPI.obtainAccessToken(clientID: "mealify-34d6842b96b4c261bee01bff3606dd8e3074727131337427991", clientSecret: "hRiEuSfza9RVBOVulZT3V6C5wRO0QsKS9RZtNP3N", scope: "") { result in
        switch result {
        case .success(let accessToken):
            // Build the location URL using the obtained access token
            let baseUrl = "https://api.kroger.com/v1/locations"
            let urlString = "\(baseUrl)?filter.zipCode.near=\(zipCode)"
            // Can adjust the radius (default: 10 miles) using filter.radiusInMiles
            
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
            
            // Make the request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    return
                }
                
                do {
                    // Decode JSON response into Location objects
                    let decoder = JSONDecoder()
                    let locationsResponse = try decoder.decode(LocationResponse.self, from: data)
                    let locations = locationsResponse.data
                    completion(.success(locations))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

struct KrogerAPI {
    static func obtainAccessToken(clientID: String, clientSecret: String, scope: String, completion: @escaping (Result<String, Error>) -> Void) {
        let baseURL = "https://api.kroger.com/v1/connect/oauth2/token"
        let credentials = "\(clientID):\(clientSecret)"
        guard let credentialsData = credentials.data(using: .utf8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode credentials"])))
            return
        }
        let base64Credentials = credentialsData.base64EncodedString()

        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")

        var requestBody = "grant_type=client_credentials"
        
        // Include the scope in the request body only if it exists
        if !scope.isEmpty {
            requestBody += "&scope=\(scope)"
        }

        let bodyData = requestBody.data(using: .utf8)
        request.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let accessToken = json?["access_token"] as? String {
                    completion(.success(accessToken))
                } else {
                    print("Error: Access token not found in response. JSON response: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Access token not found in response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
