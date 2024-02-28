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

    @Published var selectedLocationId: String?

    private init() {}
}
