import SwiftUI

struct RecipesView: View {
    enum Tab {
        case recent, saved
    }
    
    @State private var selectedTab: Tab = .recent
    @EnvironmentObject var userData: UserData
    @State private var savedRecipes: [Recipe] = [] // State to hold the saved recipes
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                // Transparent background
                Color.clear.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.75)
                    
                    HStack {
                        // Tab selection buttons
                        Button(action: {
                            selectedTab = .recent
                        }) {
                            Text("Recent")
                                .font(selectedTab == .recent ? .headline : .subheadline)
                        }
                        .padding()
                        
                        Button(action: {
                            selectedTab = .saved
                            loadSavedRecipes() // Load saved recipes when the "Saved" tab is selected
                        }) {
                            Text("Saved")
                                .font(selectedTab == .saved ? .headline : .subheadline)
                        }
                        .padding()
                    }
                    
                    // Display recipes based on selected tab
                    switch selectedTab {
                    case .recent:
                        RecentRecipesView()
                    case .saved:
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
                                .padding(.top, 20)
                        }
                    }
                    
                    Spacer()
                }
                .offset(x: isNavBarOpened ? UIScreen.main.bounds.width * 0.6 : 0)
                
                // Side view
                NavigationSideView(isSidebarVisible: $isNavBarOpened)
                    .frame(width: sidebarWidth + 50)
                    .offset(x: isNavBarOpened ? 0 : -sidebarWidth - 100)
                    .opacity(isNavBarOpened ? 1 : 0)
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

struct RecentRecipesView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        // Display recent recipes
        List(userData.recentRecipes, id: \.id) { recipe in
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
    }
}
