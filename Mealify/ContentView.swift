import SwiftUI

struct RecipesView: View {
    enum Tab {
        case recent, saved
    }
    
    @State private var selectedTab: Tab = .recent
    @EnvironmentObject var userData: UserData
    @State private var savedRecipes: [Recipe] = [] // State to hold the saved recipes
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 250 // Initial width for the side navigation view
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Transparent background
                Color.clear.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width, height: 0.5)
                    
                    HStack {
                        Button(action: {
                            selectedTab = .recent
                        }) {
                            Text("Recent")
                                .font(selectedTab == .recent ? .headline : .subheadline)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .saved
                            loadSavedRecipes() // Load saved recipes when the "Saved" tab is selected
                        }) {
                            Text("Saved")
                                .font(selectedTab == .saved ? .headline : .subheadline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, UIScreen.main.bounds.width/5)
                    
                    // Underline slider animation
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width / 2, height: 2)
                            .offset(x: selectedTab == .recent ? 0 : geometry.size.width / 2)
                    }
                    .frame(height: 2)
                    
                    // Display recipes based on selected tab
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)], spacing: 10) {
                            ForEach(selectedRecipes(), id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                                    VStack(alignment: .leading) {
                                        AsyncImage(url: URL(string: recipe.image)) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .frame(width: 150, height: 120)
                                                    .cornerRadius(5)
                                            } else if phase.error != nil {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .frame(width: 150, height: 120)
                                                    .cornerRadius(5)
                                            } else {
                                                ProgressView()
                                                    .frame(width: 150, height: 120)
                                                    .cornerRadius(5)
                                            }
                                        }
                                        .aspectRatio(contentMode: .fit)
                                        
                                        Text(recipe.title)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .blur(radius: isNavBarOpened ? 5 : 0)
                .allowsHitTesting(isNavBarOpened ? false : true)
                .offset(x: isNavBarOpened ? sidebarWidth : 0)
                
                // Side view
                if isNavBarOpened {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .frame(width: sidebarWidth)
                        .offset(x: 0)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                        .background(Color.black.opacity(0.5))
                        .onTapGesture {
                            withAnimation {
                                isNavBarOpened.toggle()
                            }
                        }
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
                            .foregroundColor(isNavBarOpened ? .black : .blue)
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
    
    // Function to return selected recipes based on the tab
    private func selectedRecipes() -> [Recipe] {
        switch selectedTab {
        case .recent:
            return userData.recentRecipes
        case .saved:
            return savedRecipes
        }
    }
}


struct RecentRecipesView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        // Display recent recipes
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)], spacing: 10) {
                ForEach(userData.recentRecipes, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: recipe.image)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 150, height: 120)
                                        .cornerRadius(5)
                                case .failure(_):
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 150, height: 120)
                                        .cornerRadius(5)
                                case .empty:
                                    ProgressView()
                                        .frame(width: 150, height: 120)
                                        .cornerRadius(5)
                                @unknown default:
                                    ProgressView()
                                        .frame(width: 150, height: 120)
                                        .cornerRadius(5)
                                }
                            }
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            Text(recipe.title)
                                .font(.headline)
                        }
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}
