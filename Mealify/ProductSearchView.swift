import SwiftUI

struct ProductSearchView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 250
    @EnvironmentObject var userData: UserData
    @State private var searchQuery: String = ""
    @State private var products: [Product] = []
    @State private var isLoading = false

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
                    
                    // Show progress indicator if loading
                    if isLoading {
                        ProgressIndicator()
                            .padding()
                    } else {
                        // Show product list if not loading
                        List(products, id: \.productId) { product in
                            ProductRow(product: product)
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

    // Function to search products
    func searchProducts() {
        // Set loading state to true
        isLoading = true
        
        // Call your searchProducts function here with the updated searchQuery
        // Ensure to handle the results appropriately and update the products state
        // Example: Assuming searchProducts is an asynchronous function
        Mealify.searchProducts(term: searchQuery, userData: userData) { result in
            switch result {
            case .success(let fetchedProducts):
                // Update products state with fetched products
                self.products = fetchedProducts
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
            
            // Set loading state to false when done
            self.isLoading = false
        }
    }
}


struct ProductRow: View {
    let product: Product
    @State private var productImage: UIImage? // State to hold the product image

    private let placeholderImage = Image(systemName: "photo")

    var body: some View {
        HStack {
            // Display the image if available
            if let productImage = productImage {
                Image(uiImage: productImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50) // Adjust size as needed
            } else {
                placeholderImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50) // Adjust size as needed
            }
            Spacer()
            
            // Product description which include the brand name
            Text(product.description ?? "N/A")
            
            Spacer()
            
            // Display the promo/regular price if it exists
            if let price = product.items?.first?.price {
                if let promoPrice = price.promo, promoPrice != 0 {
                    Text(String(format: "%.2f", promoPrice))
                } else if let regularPrice = price.regular {
                    Text(String(format: "%.2f", regularPrice))
                } else {
                    Text("Unavailable")
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            loadImage()
        }
    }

    // Function to asynchronously load the product image
    private func loadImage() {
        if let imageUrlString = product.images?.first?.sizes?.first?.url,
           let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    // Update the state with the loaded image
                    DispatchQueue.main.async {
                        self.productImage = image
                    }
                } else {
                    print("Failed to load image:", error ?? "Unknown error")
                }
            }.resume()
        }
    }
}
