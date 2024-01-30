import SwiftUI

struct SearchView: View {
    @State private var recipes: [Recipe] = []
    @State private var searchQuery: String = ""
    @State private var maxReadyTime: Int? = nil
    @State private var isNavBarOpened = false
    @State private var isFilterSidebarOpened = false
    @State private var sidebarWidth: CGFloat = 0
    @State private var sidebarHeight: CGFloat = 0

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
                .offset(x: isNavBarOpened ? UIScreen.main.bounds.width * 0.6: 0)
                
                // Navigation Sidebar (Left side)
                withAnimation {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .offset(x: isNavBarOpened ? 0 : -sidebarWidth)
                        .opacity(isNavBarOpened ? 1 : 0)
                        .background(
                            GeometryReader { geometry in
                                Color.clear.onAppear {
                                    sidebarWidth = geometry.size.width
                                }
                            }
                        )
                }
                
                // Filter Sidebar (Right side)
                withAnimation {
                    FilterSideView(isFilterSidebarVisible: $isFilterSidebarOpened, searchQuery: $searchQuery) { updatedRecipes in
                        // Update recipes when the filter is applied
                        recipes = updatedRecipes
                    }
                    .offset(y: isFilterSidebarOpened ? 0 : sidebarHeight)
                    .opacity(isFilterSidebarOpened ? 1 : 0)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.onAppear {
                                sidebarWidth = geometry.size.width
                                sidebarHeight = geometry.size.height
                            }
                        }
                    )
                }
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
                    .disabled(isFilterSidebarOpened)
                }

                // FilterSideView Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isFilterSidebarOpened.toggle()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                    }
                    .disabled(isNavBarOpened)
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

extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
