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

// Struct to represent the Department object
struct Department: Codable {
    // Define properties as needed
}

// Struct to represent the Location object
struct LocationResponse: Codable {
    let data: [Location]
}

// Struct to represent the data within each location
struct Location: Codable {
    let locationId: String
    let chain: String
    let address: Address
    let geolocation: Geolocation
    let name: String
    let hours: Hours
    let phone: String
}

func getLocations(zipCode: String, completion: @escaping (Result<[Location], Error>) -> Void) {
    // Validate zip code
    guard zipCode.count == 5, zipCode.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid zip code"])))
        return
    }
    
    // Hardcoded access token
    let accessToken = "eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHBzOi8vYXBpLmtyb2dlci5jb20vdjEvLndlbGwta25vd24vandrcy5qc29uIiwia2lkIjoiWjRGZDNtc2tJSDg4aXJ0N0xCNWM2Zz09IiwidHlwIjoiSldUIn0.eyJhdWQiOiJtZWFsaWZ5LTM0ZDY4NDJiOTZiNGMyNjFiZWUwMWJmZjM2MDZkZDhlMzA3NDcyNzEzMTMzNzQyNzk5MSIsImV4cCI6MTcwODIxMjA0NywiaWF0IjoxNzA4MjEwMjQyLCJpc3MiOiJhcGkua3JvZ2VyLmNvbSIsInN1YiI6ImI0MWQ0ZTVjLTVkMDAtNWRiMS04NWIzLTZhNGM1YzdmMTk2OSIsInNjb3BlIjoiIiwiYXV0aEF0IjoxNzA4MjEwMjQ3NTIzNjI5ODgyLCJhenAiOiJtZWFsaWZ5LTM0ZDY4NDJiOTZiNGMyNjFiZWUwMWJmZjM2MDZkZDhlMzA3NDcyNzEzMTMzNzQyNzk5MSJ9.em6VliiYVQ2N2CLy9doUdXcsO1OZp3I5ismC8kQHm9FZSvvtcN1JsWggPj_BwUURKKFTpxASYMHva5koPY3F0GPj-MHLbIF3r73BzW1wQhEuc0ITUJ8bWNJk5gPP4u0fdAE4TO_hwLxpkHtU7dAfY9ux_jSjjWdq8twOU5NkaQoQmOzvCo_JooHxTyt9af3G4_xw5X-DXAwid2hhi9KTBnK0vM9FGL1gpwWZOOjorx78-Jz8SNozc536rWKZJebvKbHUBiW7uNf4IrBt77e99IuXl6I0oQ7_YV9LhdZVcOLYr1vtW5_sEWe2mxYfsz-QPzVmO7-apNVjcVHQuL3DjA"
    
    // Build the location URL
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
}

struct KrogerAPI {
    static func obtainAccessToken(clientID: String, clientSecret: String, completion: @escaping (Result<String, Error>) -> Void) {
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

        let bodyData = "grant_type=client_credentials".data(using: .utf8)
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
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Access token not found in response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

func fetchKrogerAccessToken() {
    let clientID = "mealify-34d6842b96b4c261bee01bff3606dd8e3074727131337427991"
    let clientSecret = "hRiEuSfza9RVBOVulZT3V6C5wRO0QsKS9RZtNP3N"

    KrogerAPI.obtainAccessToken(clientID: clientID, clientSecret: clientSecret) { result in
        switch result {
        case .success(let accessToken):
            print("Access token: \(accessToken)")
            // Handle successful access token retrieval
        case .failure(let error):
            print("Error obtaining access token: \(error)")
            // Handle error
        }
    }
}
