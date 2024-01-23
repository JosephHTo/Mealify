import SwiftUI

struct FilterSideView: View {
    @Binding var isFilterSidebarVisible: Bool
    @Binding var searchQuery: String
    @State private var dragOffset: CGFloat = 0
    @State private var maxReadyTimeString: String = ""
    var onApplyFilters: ([Recipe]) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 40, height: 5)
                    .foregroundColor(Color.white)
                    .cornerRadius(2.5)
                    .padding(.vertical, 10)
                Spacer()
            }
            .contentShape(Rectangle())
            .offset(y: dragOffset)
            .gesture(DragGesture()
                .onChanged { value in
                    dragOffset = max(0, value.translation.height)
                }
                .onEnded { value in
                    if dragOffset > UIScreen.main.bounds.height * 0.2 {
                        withAnimation {
                            isFilterSidebarVisible = false
                        }
                    }
                    dragOffset = 0
                }
            )

            // Textfield for max ready time
            Text("Time")
                .offset(x:10)
            TextField("Max Ready Time (min)", text: $maxReadyTimeString, onCommit: {
                // Handle text field commit if needed
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .keyboardType(.numberPad)

            Spacer()

            // Apply Filter Button
            Button(action: {
                applyFilters()
            }) {
                Text("Apply Filter")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 100)
            .offset(x: UIScreen.main.bounds.width - 130)
        }
        .frame(height: UIScreen.main.bounds.height * 0.8)
        .background(Color.gray)
        .transition(.move(edge: .bottom))
        .offset(y: isFilterSidebarVisible ? UIScreen.main.bounds.height * 0.1 : 0)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            // Handle tap if needed
        }
    }

    private func applyFilters() {
        // Convert the maxReadyTimeString to an integer
        if let maxReadyTime = Int(maxReadyTimeString) {
            // Call the fetch function with the updated filter
            fetchRecipesWithFilter(maxReadyTime: maxReadyTime)
        } else {
            // Handle case where the input is not a valid integer (e.g., empty or non-numeric)
            print("Invalid input for max ready time")
        }
    }

    private func fetchRecipesWithFilter(maxReadyTime: Int) {
        // Call your fetchSpoonacularRecipes function with the new filter
        fetchSpoonacularRecipes(query: searchQuery, maxReadyTime: maxReadyTime) { recipes in
            // Handle the fetched recipes
            if let recipes = recipes {
                withAnimation {
                    // Close the filter sidebar
                    isFilterSidebarVisible = false
                }
                // Call the closure to pass back the updated recipes
                onApplyFilters(recipes)
                print("Fetched recipes with filter:", recipes)
            } else {
                print("Failed to fetch recipes.")
            }
        }
    }
}
