import SwiftUI

struct SavedRecipesView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0
    @EnvironmentObject var userData: UserData
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
        .onAppear {
            // Call searchProducts to fetch the products
            searchProducts(term: "milk", userData: userData) { result in
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
}
