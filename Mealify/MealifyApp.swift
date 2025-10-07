import SwiftUI
import Combine
import UIKit

@main
struct MealifyApp:App {
    @StateObject var userData=UserData.shared

    var body:some Scene {
        WindowGroup {
            RecipesView()
                .environmentObject(userData)
        }
    }
}
