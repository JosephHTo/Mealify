import SwiftUI

struct ProductSearchView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 250
    @EnvironmentObject var userData: UserData
    @State private var searchQuery: String = ""
    @State private var products: [Product] = [] // State to hold the fetched products

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Main content
                VStack {
                    
                    Text("Product Search")
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
                            searchProducts()
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
                    
                    if userData.selectedLocation?.locationId == nil {
                        Text("Set your desired locations in settings to use Product Search.")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    List(products, id: \.productId) { product in
                        ProductRow(product: product)
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
            switch result {
            case .success(let fetchedProducts):
                products = fetchedProducts
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
}

struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack {
            // Display product information as needed
            Text(product.brand)
            Spacer()
        }
        .padding()
    }
}
