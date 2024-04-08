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
                    Text("\(recipe.summary?.removingHTMLTags() ?? "No summary available")")
                        .font(.subheadline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                case .ingredient:
                    if let ingredients = recipe.ingredients {
                        HStack {
                            Button("US") {
                                // Toggle to US measurements
                                isMetricSelected = false
                            }
                            .padding(8)
                            .background(!isMetricSelected ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)

                            Button("Metric") {
                                // Toggle to metric measurements
                                isMetricSelected = true
                            }
                            .padding(8)
                            .background(isMetricSelected ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 1) {
                            ForEach(ingredients, id: \.self) { ingredient in
                                let baseValue = isMetricSelected ? ingredient.amount.metric.value : ingredient.amount.us.value
                                let unit = isMetricSelected ? ingredient.amount.metric.unit : ingredient.amount.us.unit

                                // Calculate the adjusted value based on selectedServingSize
                                let adjustedValue = (baseValue / Double(recipe.servings)) * Double(selectedServingSize)

                                Text("\(String(format: "%.1f", adjustedValue)) \(unit) \(ingredient.name)")
                                    .multilineTextAlignment(.leading) // Left-align the text
                                    .padding(.trailing, 5)
                            }
                            .padding(.vertical, 5)
                        }
                        .padding(.vertical, 1)
                    }
                case .instructions:
                    if let analyzedInstructions = recipe.analyzedInstructions {
                        ForEach(analyzedInstructions, id: \.self) { analyzedInstruction in
                            ForEach(analyzedInstruction.steps, id: \.self) { step in
                                Text("Step \(step.number): \(step.step.trimmingCharacters(in: .whitespacesAndNewlines))")
                                    .padding()
                            }
                        }
                    }
                case .other:
                    // Placeholder for other content
                    Text("Other content goes here")
                        .font(.subheadline)
                        .padding()
                        // Add other content here when needed
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
                Circle()
                    .foregroundColor(.white)
                    .shadow(radius: 3)
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
