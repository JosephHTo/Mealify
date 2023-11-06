import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = []
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
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
            .navigationTitle("Recipes")
        }
        .onAppear {
            fetchRecipes()
        }
    }

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

struct RecipeDetail: View {
    var recipe: Recipe

    var body: some View {
        VStack {
            Text(recipe.title)
                .font(.title)
                .padding()
            
            if let instructions = recipe.instructions {
                Text("Instructions:")
                    .font(.headline)
                Text(instructions)
                    .padding()
            }

            Spacer()
        }
        .navigationBarTitle(recipe.title, displayMode: .inline)
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
