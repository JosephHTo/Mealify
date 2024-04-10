import SwiftUI

struct RecipeDetail: View {
    enum Tab {
        case overview, ingredient, instructions, other
    }
    
    var recipe: Recipe
    @State private var selectedTab: Tab = .overview
    @State private var selectedServingSize: Int
    @State private var isSaved: Bool = false
    @State private var isServingSizePopoverPresented = false
    @State private var nutrients: [Nutrient]? = nil
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode

    init(recipe: Recipe) {
        self.recipe = recipe
        // Initialize selectedServingSize with the value of recipe.servings
        self._selectedServingSize = State(initialValue: recipe.servings)

        // Check if the recipe is saved in UserDefaults
        if let savedRecipes = UserDefaults.standard.data(forKey: "savedRecipes") {
            let decoder = JSONDecoder()
            if let decodedRecipes = try? decoder.decode([Recipe].self, from: savedRecipes) {
                isSaved = decodedRecipes.contains { $0.id == recipe.id }
            }
        }
    }

    @State private var isMetricSelected = false

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width*9/10, height: UIScreen.main.bounds.height/3)
                            .cornerRadius(5)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width*9/10, height: UIScreen.main.bounds.height/3)
                            .cornerRadius(5)
                    } else {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width*9/10, height: UIScreen.main.bounds.height/3)
                            .cornerRadius(5)
                    }
                }
                .aspectRatio(contentMode: .fit)
                
                HStack {
                    VStack (alignment: .leading) {
                        Text(recipe.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            Text("\(recipe.readyInMinutes) minutes")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                            
                            Divider()
                            
                            Button(action: {
                                // Toggle the serving size popover
                                isServingSizePopoverPresented.toggle()
                            }) {
                                Text("\(selectedServingSize) servings")
                                    .font(.subheadline)
                            }
                            .popover(isPresented: $isServingSizePopoverPresented, arrowEdge: .top) {
                                // Popover content for serving size adjustment
                                VStack {
                                    // Text showing the current number
                                    Text("Current Serving Size: \(selectedServingSize)")
                                        .padding()
                                    
                                    // Serving size slider
                                    Slider(
                                        value: Binding(
                                            get: { Double(selectedServingSize) },
                                            set: { selectedServingSize = Int($0) }
                                        ),
                                        in: 1...20,
                                        step: 1
                                    ) {
                                        Text("Serving Size")
                                    }
                                    .padding()
                                    .accentColor(.blue)
                                    
                                    // Done button
                                    Button("Done") {
                                        isServingSizePopoverPresented.toggle()
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle save/delete button tap
                        isSaved.toggle()
                        saveRecipe()
                    }) {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .foregroundColor(isSaved ? .red : .gray)
                            .padding()
                            .font(.title)
                    }
                }
                .padding()
                
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                
                HStack {
                    // Tab selection buttons
                    Button(action: {
                        selectedTab = .overview
                    }) {
                        Text("Overview")
                            .font(selectedTab == .overview ? .headline : .subheadline)
                    }
                    
                    Button(action: {
                        selectedTab = .ingredient
                    }) {
                        Text("Ingredients")
                            .font(selectedTab == .ingredient ? .headline : .subheadline)
                    }
                    
                    Button(action: {
                        selectedTab = .instructions
                    }) {
                        Text("Instructions")
                            .font(selectedTab == .instructions ? .headline : .subheadline)
                    }
                    
                    Button(action: {
                        selectedTab = .other
                    }) {
                        Text("Other")
                            .font(selectedTab == .other ? .headline : .subheadline)
                    }
                }
                
                // Display content based on selected tab
                switch selectedTab {
                case .overview:
                    if let summary = recipe.summary?.removingHTMLTags(), !summary.isEmpty {
                        Text(summary)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(5)
                            .padding([.horizontal, .bottom], 15)
                    } else {
                        Text("No summary available")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal, .bottom], 15) // Add padding to create space around the fallback message
                    }
                    
                case .ingredient:
                    if let ingredients = recipe.ingredients {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 20) {
                                Button("US") {
                                    // Toggle to US measurements
                                    isMetricSelected = false
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(!isMetricSelected ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                
                                Button("Metric") {
                                    // Toggle to metric measurements
                                    isMetricSelected = true
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(isMetricSelected ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                            }
                            
                            ForEach(ingredients, id: \.self) { ingredient in
                                let baseValue = isMetricSelected ? ingredient.amount.metric.value : ingredient.amount.us.value
                                let unit = isMetricSelected ? ingredient.amount.metric.unit : ingredient.amount.us.unit
                                
                                // Calculate the adjusted value based on selectedServingSize
                                let adjustedValue = (baseValue / Double(recipe.servings)) * Double(selectedServingSize)
                                
                                HStack {
                                    Text("\(String(format: "%.1f", adjustedValue)) \(unit)")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(ingredient.name)
                                        .foregroundColor(.secondary)
                                }
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(5)
                                .shadow(radius: 2) // Add shadow for depth effect
                            }
                        }
                        .padding()
                    }
                    
                case .instructions:
                    if let analyzedInstructions = recipe.analyzedInstructions {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(analyzedInstructions, id: \.self) { analyzedInstruction in
                                ForEach(analyzedInstruction.steps, id: \.self) { step in
                                    HStack(alignment: .top) {
                                        Text("\(step.number)")
                                            .foregroundColor(Color.gray)
                                            .font(.title)
                                            .padding(.leading, 10)
                                            .frame(width: 40, alignment: .leading) // Adjust width for consistent alignment
                                        Text(step.step.trimmingCharacters(in: .whitespacesAndNewlines))
                                            .padding(.trailing, 5)
                                        Spacer()
                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(radius: 2) // Add shadow for depth effect
                                }
                            }
                        }
                        .padding()
                    }
                    
                case .other:
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Diets")
                            .font(.title2)
                            .underline()
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.blue)
                        
                        if let diets = recipe.diets, !diets.isEmpty {
                            ForEach(diets.indices, id: \.self) { index in
                                let diet = diets[index]
                                
                                VStack(alignment: .leading) { // Set alignment to leading
                                    Text(diet.capitalized)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 15)
                                    
                                    if index < diets.count - 1 {
                                        Divider() // Add a divider between diets except for the last one
                                    }
                                }
                                .padding(.bottom, index == diets.count - 1 ? 15 : 0) // Add bottom padding only to the last diet
                            }
                        } else {
                            Text("Not Applicable")
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 15)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                    .padding()
                    
                    if let nutrients = nutrients {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Nutritional Info Per Serving")
                                .font(.title2)
                                .underline()
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                                .padding(.horizontal, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.blue)
                            
                            ForEach(nutrients.indices, id: \.self) { index in
                                let nutrient = nutrients[index]
                                let roundedAmount = String(format: "%.2f", nutrient.amount)
                                
                                HStack {
                                    Text(nutrient.name)
                                        .foregroundColor(.primary)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("\(roundedAmount) \(nutrient.unit)")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 15)
                                
                                if index < nutrients.count - 1 {
                                    Divider() // Divider between nutrients
                                        .padding(.horizontal, 15)
                                }
                            }
                            
                            Spacer()
                        }
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                        .padding()
                    }
                }
                
                Spacer()
            }
            .onAppear {
                // Check if the recipe is saved in UserDefaults
                if let savedRecipes = UserDefaults.standard.data(forKey: "savedRecipes") {
                    let decoder = JSONDecoder()
                    if let decodedRecipes = try? decoder.decode([Recipe].self, from: savedRecipes) {
                        isSaved = decodedRecipes.contains { $0.id == recipe.id }
                    }
                }
                
                // Save the recipe to recentRecipes when it appears
                userData.saveRecentRecipe(recipe)
                
                fetchNutrients(for: recipe.id) { result in
                        DispatchQueue.main.async {
                            self.nutrients = result
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
        .navigationBarItems(leading: backButton)
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            ZStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
        }
        .frame(width: 30, height: 30) // Adjust size as needed
    }
    private func saveRecipe() {
        var savedRecipes: [Recipe]

        // Fetch the saved recipes from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "savedRecipes") {
            let decoder = JSONDecoder()
            if let decodedRecipes = try? decoder.decode([Recipe].self, from: data) {
                savedRecipes = decodedRecipes
            } else {
                savedRecipes = []
            }
        } else {
            savedRecipes = []
        }

        // Check if the recipe is already saved
        if let index = savedRecipes.firstIndex(where: { $0.id == recipe.id }) {
            // Recipe is already saved, remove it
            savedRecipes.remove(at: index)
        } else {
            // Recipe is not saved, add it
            savedRecipes.append(recipe)
        }

        // Print the current list of saved recipes for debugging
        print("Current saved recipes:")
        for savedRecipe in savedRecipes {
            print(savedRecipe.title)
        }

        // Save the updated list of saved recipes to UserDefaults
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(savedRecipes) {
            UserDefaults.standard.set(encodedData, forKey: "savedRecipes")
        }
    }
}
