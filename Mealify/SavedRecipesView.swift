import SwiftUI

struct SavedRecipesView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0
    @EnvironmentObject var userData: UserData
    @State private var firstProduct: Product? // State to hold the first product

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

                    // Display the first product if available
                    if let product = firstProduct {
                        Text("First Product: \(product.description)") // Update with your desired product property
                    } else {
                        Text("No product found")
                    }

                    Spacer()
                }
                .offset(x: isNavBarOpened ? UIScreen.main.bounds.width * 0.6: 0)
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
            // Call searchProducts to fetch the first product
            searchProducts(term: "milk", userData: userData) { result in
                switch result {
                case .success(let products):
                    if let firstProduct = products.first {
                        self.firstProduct = firstProduct
                    }
                case .failure(let error):
                    print("Error fetching products: \(error)")
                }
            }
        }
    }
}
