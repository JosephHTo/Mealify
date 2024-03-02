import SwiftUI
import Combine

@main
struct MealifyApp: App {
    @StateObject var userData = UserData.shared

    var body: some Scene {
        WindowGroup {
            FeaturedView()
                .environmentObject(userData)
        }
    }
}

class UserData: ObservableObject {
    static let shared = UserData()

    @Published var selectedLocation: Location? {
        didSet {
            // Save the selectedLocation, for example, using UserDefaults
            if let encodedData = try? JSONEncoder().encode(selectedLocation) {
                UserDefaults.standard.set(encodedData, forKey: "selectedLocation")
            }
        }
    }

    init() {
        if let savedData = UserDefaults.standard.data(forKey: "selectedLocation"),
           let decodedLocation = try? JSONDecoder().decode(Location.self, from: savedData) {
            self.selectedLocation = decodedLocation
        }
    }
}

