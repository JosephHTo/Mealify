import SwiftUI

class UserData:ObservableObject {
	static let shared=UserData()

	@Published var selectedLocation:Location? {
		didSet {
			if let encodedData=try?JSONEncoder().encode(selectedLocation) {
				UserDefaults.standard.set(encodedData,forKey:"selectedLocation")
			}
		}
	}

	@Published var recipeList:[Recipe] {
		didSet {
			if let encoded=try?JSONEncoder().encode(recipeList) {
				UserDefaults.standard.set(encoded,forKey:"recipeList")
			}
		}
	}

	@Published var recentRecipes:[Recipe] {
		didSet {
			if let encoded=try?JSONEncoder().encode(recentRecipes) {
				UserDefaults.standard.set(encoded,forKey:"recentRecipes")
			}
		}
	}

	init() {
		//Load the following values from UserDefaults
		if let savedData=UserDefaults.standard.data(forKey: "selectedLocation"),
		   let decodedLocation=try?JSONDecoder().decode(Location.self,from:savedData) {
			self.selectedLocation=decodedLocation
		}
		
		if let savedRecipeData=UserDefaults.standard.data(forKey:"recipeList"),
		   let decodedRecipeList=try?JSONDecoder().decode([Recipe].self,from:savedRecipeData) {
			self.recipeList = decodedRecipeList
		}
		else {//No saved recipes
			self.recipeList = []
		}

		if let savedRecentRecipeData=UserDefaults.standard.data(forKey:"recentRecipes"),
		   let decodedRecentRecipes=try?JSONDecoder().decode([Recipe].self,from: savedRecentRecipeData) {
			self.recentRecipes = decodedRecentRecipes
		}
		else {//No recent recipes
			self.recentRecipes = []
		}
	}
	
	//Save a recipes to recents.
	func saveRecentRecipe(_ recipe:Recipe) {
		// Fetch the recent recipes from UserDefaults
		var recentRecipes=self.recentRecipes

		// Ensure the recipe is unique
		if !recentRecipes.contains(where: { $0.id==recipe.id }) {
			recentRecipes.insert(recipe, at: 0)

			// Keep only the most recent 10 recipes
			recentRecipes=Array(recentRecipes.prefix(10))

			// Update the published property
			self.recentRecipes=recentRecipes

			// Save the updated recent recipes to UserDefaults
			if let encodedData=try?JSONEncoder().encode(recentRecipes) {
				UserDefaults.standard.set(encodedData,forKey:"recentRecipes")
			}
		}
		else {
			// If the recipe already exists, remove it from its current position
			if let existingIndex=recentRecipes.firstIndex(where: { $0.id==recipe.id }) {
				recentRecipes.remove(at:existingIndex)
				// Put the existing recipe at the front of the list
				recentRecipes.insert(recipe,at:0)

				// Update the published property
				self.recentRecipes=recentRecipes

				// Save the updated recent recipes to UserDefaults
				if let encodedData=try? JSONEncoder().encode(recentRecipes) {
					UserDefaults.standard.set(encodedData,forKey:"recentRecipes")
				}
			}
		}
	}

	// Function to clear recent recipes
	func clearRecentRecipes() {
		recentRecipes=[]
	}
}
