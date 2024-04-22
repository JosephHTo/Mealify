import SwiftUI

struct SearchView: View {
    @State private var recipes: [Recipe] = []
    @State private var searchQuery: String = ""
    @State private var maxReadyTime: Int? = nil
    @State private var isNavBarOpened = false
    @State private var isFilterSidebarOpened = false
    @State private var sidebarWidth: CGFloat = 250
    @State private var sidebarHeight: CGFloat = 0
    @State private var isLoading = false
    @State private var showRecipeList = false

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
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width, height: 0.5)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading)
                        
                        TextField("Search", text: $searchQuery, onCommit: {
                            fetchRecipes()
                        })
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color.gray.opacity(0))
                        .cornerRadius(5)
                        .padding(.trailing)
                        
                        ClearButton(text: $searchQuery)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                    
                    ScrollView {
                        if isLoading {
                            ProgressIndicator()
                                .padding()
                        } else if showRecipeList {
                            LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)], spacing: 10) {
                                ForEach(recipes, id: \.id) { recipe in
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
                            
                            if recipes.isEmpty && !searchQuery.isEmpty {
                                Text("No Recipes Found")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                }
                .offset(x: isNavBarOpened ? sidebarWidth : 0)
                
                // Navigation Side view (Left Side)
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
                    .foregroundColor(isNavBarOpened ? .black : .blue)
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
        .onAppear {
            showRecipeList = true
        }
    }

    func fetchRecipes() {
        isLoading = true
        fetchSpoonacularRecipes(query: searchQuery) { fetchedRecipes in
            if let recipes = fetchedRecipes {
                self.recipes = recipes
            } else {
                self.recipes = []
            }
            self.isLoading = false
        }
    }
}

struct ProgressIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue, lineWidth: 5)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
            
            Text("Loading...")
                .font(.headline)
                .padding(.top, 8)
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
