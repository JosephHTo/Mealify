// File is no longer in use, contents moved over to ContentView.swift
/*
 import SwiftUI
 
struct SavedRecipesView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0
    @EnvironmentObject var userData: UserData
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
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
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
}
*/
