import Foundation

// Define structs to represent the nested JSON objects

// Struct to represent the Address object
struct Address: Codable {
    let addressLine1: String
    let city: String
    let state: String
    let zipCode: String
    let county: String
}

// Struct to represent the Geolocation object
struct Geolocation: Codable {
    let latitude: Double
    let longitude: Double
    let latLng: String
}

// Struct to represent the Hours object
struct Hours: Codable {
    let timezone: String
    let gmtOffset: String
    let open24: Bool
    let monday: DayHours
    // Define properties for other days as needed
}

// Struct to represent the hours for each day
struct DayHours: Codable {
    let open: String
    let close: String
    let open24: Bool
}


// Struct to represent the Location object
struct LocationResponse: Codable {
    let data: [Location]
}

// Struct to represent the data within each location
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
}

struct Product: Codable {
    let productId: String
    let aisleLocations: [AisleLocation]?
    let brand: String?
    let categories: [String]?
    let countryOrigin: String?
    let description: String?
    let items: [Item]?
    let itemInformation: ItemInformation?
    let temperature: Temperature?
    let images: [ProductImage]?
    let upc: String?
}

struct AisleLocation: Codable {
    let bayNumber: String?
    let description: String?
    let number: String?
    let numberOfFacings: String?
    let sequenceNumber: String?
    let side: String?
    let shelfNumber: String?
    let shelfPositionInBay: String?
}

struct Item: Codable {
    let itemId: String?
    let inventory: Inventory?
    let favorite: Bool?
    let fulfillment: Fulfillment?
    let price: Price?
    let nationalPrice: Price?
    let size: String?
    let soldBy: String?
}

struct Inventory: Codable {
    let stockLevel: String?
}

struct Fulfillment: Codable {
    let curbside: Bool?
    let delivery: Bool?
    let instore: Bool?
    let shiptohome: Bool?
}

struct Price: Codable {
    let regular: Double?
    let promo: Double?
    let regularPerUnitEstimate: Double?
    let promoPerUnitEstimate: Double?
}

struct ItemInformation: Codable {
    let depth: String?
    let height: String?
    let width: String?
}

struct Temperature: Codable {
    let indicator: String?
    let heatSensitive: Bool?
}

struct ProductImage: Codable {
    let id: String?
    let perspective: String?
    let `default`: Bool?
    let sizes: [ImageSize]?
}

struct ImageSize: Codable {
    let id: String?
    let size: String?
    let url: String?
}

func searchProducts(term: String, userData: UserData, completion: @escaping (Result<[Product], Error>) -> Void) {
    // Fetch access token
    KrogerAPI.obtainAccessToken(clientID: "mealify-34d6842b96b4c261bee01bff3606dd8e3074727131337427991", clientSecret: "hRiEuSfza9RVBOVulZT3V6C5wRO0QsKS9RZtNP3N", scope: "product.compact") { result in
        switch result {
        case .success(let accessToken):
            // Build the product search URL using the obtained access token and optional locationId
            var productsUrl = "https://api.kroger.com/v1/products?filter.term=\(term)"
            if let locationId = userData.selectedLocation?.locationId {
                productsUrl += "&filter.locationId=\(locationId)"
            }
            
            guard let url = URL(string: productsUrl) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
            print(request)
            // Make the request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let data = data, error == nil else {
                    completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    return
                }
                
                // Before decoding
                //print("JSON Data:", String(data: data, encoding: .utf8) ?? "")

                // Decode JSON response into Product objects
                let decoder = JSONDecoder()
                do {
                    let productsResponse = try decoder.decode(ProductResponse.self, from: data)
                    let products = productsResponse.data
                    completion(.success(products))
                } catch {
                    print("Error during decoding:", error)
                    completion(.failure(error))
                }
            }
            
            task.resume()
            
        case .failure(let error):
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
