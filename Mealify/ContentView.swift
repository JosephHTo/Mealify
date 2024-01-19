import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = []
    @State private var searchQuery: String = ""
    @State private var isSidebarOpened = false
    @State private var sidebarWidth: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Main content
                VStack {
                    TextField("Search for recipes", text: $searchQuery, onCommit: {
                        fetchRecipes()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                    List(recipes, id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                            HStack {
                                AsyncImage(url: URL(string: recipe.image)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                    } else if phase.error != nil {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                    } else {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                }
                                .aspectRatio(contentMode: .fit)
                                Text(recipe.title)
                            }
                        }
                    }
                }
                .navigationTitle("")

                // Sidebar
                SideView(isSidebarVisible: $isSidebarOpened)
                    .offset(x: isSidebarOpened ? 0 : -sidebarWidth)
                    .animation(.easeInOut)
                    .opacity(isSidebarOpened ? 1 : 0)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.onAppear {
                                sidebarWidth = geometry.size.width
                            }
                        }
                    )
            }
            .onAppear {
                fetchRecipes()
            }
            // Move the button to the top left
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            isSidebarOpened.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle.fill")
                    }
                }
            }
        }
    }

    // Fetch recipes function remains unchanged
    func fetchRecipes() {
        fetchSpoonacularRecipes(query: searchQuery) { fetchedRecipes in
            if let recipes = fetchedRecipes {
                self.recipes = recipes
            } else {
                self.recipes = []
            }
        }
    }
}

struct SideView: View {
    @Binding var isSidebarVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "house.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .padding(.trailing, 10)

                Text("Featured")
                    .foregroundColor(Color.white)
                    .font(.body)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .onTapGesture {
                // Handle item tap
                print("Tapped on Featured")
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }

            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .padding(.trailing, 10)

                Text("Search")
                    .foregroundColor(Color.white)
                    .font(.body)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .onTapGesture {
                // Handle item tap
                print("Tapped on Search")
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }

            HStack {
                Image(systemName: "square.and.arrow.down.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .padding(.trailing, 10)

                Text("Saved Recipes")
                    .foregroundColor(Color.white)
                    .font(.body)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .onTapGesture {
                // Handle item tap
                print("Saved Recipes")
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }

            Spacer() // Add Spacer to bring HStacks to the top
        }
        .frame(maxHeight: .infinity) // Ensure the VStack takes up the full height
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(Color.gray)
        .transition(.move(edge: .leading))
        .onTapGesture {
            withAnimation {
                isSidebarVisible.toggle()
            }
        }
    }
}

struct RecipeDetail: View {
    var recipe: Recipe
    @State private var selectedServingSize: Int
    
    init(recipe: Recipe) {
        self.recipe = recipe
        // Initialize selectedServingSize with the value of recipe.servings
        self._selectedServingSize = State(initialValue: recipe.servings)
    }
    
    @State private var isMetricSelected = false

    var body: some View {
        ScrollView {
            VStack {
                Text(recipe.title)
                    .font(.title)
                    .padding()
                
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(5)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(5)
                    } else {
                        ProgressView()
                            .frame(height: 200)
                            .cornerRadius(5)
                    }
                }
                .aspectRatio(contentMode: .fit)
                
                Text("Summary: \(recipe.summary?.removingHTMLTags() ?? "No summary available")")
                    .font(.subheadline)
                    .padding()

                if let analyzedInstructions = recipe.analyzedInstructions {
                    Text("Instructions:")
                        .font(.headline)
                    ForEach(analyzedInstructions, id: \.self) { analyzedInstruction in
                        ForEach(analyzedInstruction.steps, id: \.self) { step in
                            Text("Step \(step.number): \(step.step.trimmingCharacters(in: .whitespacesAndNewlines))")
                                .padding()
                        }
                    }
                }
                if let ingredients = recipe.ingredients {
                    Text("Ingredients:")
                        .font(.headline)
                    HStack {
                        
                        VStack {
                            // Serving size text display
                            Text("Serving Size: \(selectedServingSize)")
                                .font(.headline)
                                .offset(y:20)
                            // Serving size slider
                            HStack {
                                Slider(
                                    value: Binding(
                                        get: { Double(selectedServingSize) },
                                        set: { selectedServingSize = Int($0) }
                                    ),
                                    in: 1...20,
                                    step: 1
                                ) {
                                    Text("Serving Size")
                                } minimumValueLabel: {
                                    Text("1")
                                } maximumValueLabel: {
                                    Text("20")
                                } onEditingChanged: { _ in
                                    // Handle the selected serving size change if needed
                                }
                                .padding()
                                .accentColor(.blue)
                            }
                        }

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
                Spacer()
            }
        }
    }
}

extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
