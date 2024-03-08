import SwiftUI

struct SavedRecipesView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0
    @EnvironmentObject var userData: UserData
    @State private var searchQuery: String = ""
    @State private var products: [Product] = [] // State to hold the fetched products
    @State private var savedRecipes: [Recipe] = [] // State to hold the saved recipes

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                withAnimation {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .frame(width: sidebarWidth + 115)
                        .offset(x: isNavBarOpened ? 0 : -sidebarWidth)
                        .opacity(isNavBarOpened ? 1 : 0)
                        .background(
                            GeometryReader { geometry in
                                Color.white // Set the background color here
                                    .onAppear {
                                        sidebarWidth = geometry.size.width
                                    }
                            }
                        )
                }

                VStack {
                    Text("Saved Recipes")
                        .font(.title)
                        .padding()

                    // Integrate the SearchBar
                    SearchBar(searchQuery: $searchQuery, onCommit: {
                        searchProducts()
                    })

                    // Display saved recipes
                    if !savedRecipes.isEmpty {
                        List(savedRecipes, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                                HStack {
                                    AsyncImage(url: URL(string: recipe.image)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .frame(width: 120, height: 90)
                                                .cornerRadius(5)
                                        } else if phase.error != nil {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 120, height: 90)
                                                .cornerRadius(5)
                                        } else {
                                            ProgressView()
                                                .frame(width: 120, height: 90)
                                                .cornerRadius(5)
                                        }
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    Text(recipe.title)
                                        .font(.headline)
                                }
                            }
                            .padding()
                        }
                    } else {
                        Text("No saved recipes found")
                    }

                    Spacer()
                }
                .offset(x: isNavBarOpened ? UIScreen.main.bounds.width * 0.6 : 0)
            }
            // NavigationSideView Button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            isNavBarOpened.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle.fill")
                    }
                }
            }
            .onAppear {
                // Load saved recipes from UserDefaults
                loadSavedRecipes()
            }
        }
    }

    // Function to load saved recipes from UserDefaults
    func loadSavedRecipes() {
        if let savedRecipesData = UserDefaults.standard.data(forKey: "savedRecipes") {
            let decoder = JSONDecoder()
            if let decodedRecipes = try? decoder.decode([Recipe].self, from: savedRecipesData) {
                savedRecipes = decodedRecipes
            }
        }
    }

    // Function to search products
    func searchProducts() {
        // Call your searchProducts function here with the updated searchQuery
        // Ensure to handle the results appropriately and update the products state
        // Example: Assuming searchProducts is an asynchronous function
        Mealify.searchProducts(term: searchQuery, userData: userData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedProducts):
                    products = fetchedProducts
                    print("Fetched Products: \(fetchedProducts)")
                case .failure(let error):
                    print("Error fetching products: \(error)")
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var searchQuery: String
    var onCommit: () -> Void
    
    var body: some View {
        TextField("Search for products", text: $searchQuery, onCommit: onCommit)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}
