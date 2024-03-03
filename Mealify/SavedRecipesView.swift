import SwiftUI

struct SavedRecipesView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0
    @EnvironmentObject var userData: UserData
    @State private var searchQuery: String = ""
    @State private var products: [Product] = [] // State to hold the fetched products
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                withAnimation {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .frame(width: sidebarWidth + 25)
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

                    // Display product information
                    if !products.isEmpty {
                        List(products, id: \.productId) { product in
                            VStack(alignment: .leading) {
                                Text("Product: \(product.description)")
                                    .font(.headline)
                                Text("Price: $\(product.items.first?.price.regular ?? 0.0)")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    } else {
                        Text("No products found")
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
