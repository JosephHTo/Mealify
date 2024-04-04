import SwiftUI

struct ProductSearchView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0
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

                    List(products, id: \.productId) { product in
                        ProductRow(product: product)
                    }
                }
                .offset(x: isNavBarOpened ? UIScreen.main.bounds.width * 0.6 : 0)

                // NavigationSideView (Left side)
                withAnimation {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .frame(width: sidebarWidth + 118)
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
