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
                    
                    Text("Recipe Search")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    HStack {
                        TextField("Search for recipes", text: $searchQuery, onCommit: {
                            fetchRecipes()
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                        ClearButton(text: $searchQuery)
                    }

                    List(recipes, id: \.id) { recipe in
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
                    }
                }
                .offset(x: isNavBarOpened ? UIScreen.main.bounds.width * 0.6: 0)

                // Navigation Sidebar (Left side)
                withAnimation {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .frame(width: sidebarWidth + 122)
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

struct ClearButton: View {
    @Binding var text: String

    var body: some View {
        Button(action: {
            text = ""
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
                .opacity(text.isEmpty ? 0 : 1)
        }
        .buttonStyle(PlainButtonStyle())
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
