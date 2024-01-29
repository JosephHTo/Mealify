import SwiftUI

struct FilterSideView: View {
    @Binding var isFilterSidebarVisible: Bool
    @Binding var searchQuery: String
    @State private var dragOffset: CGFloat = 0
    @State private var maxReadyTimeString: String = ""
    @State private var selectedDiet: Diet = .none
    var onApplyFilters: ([Recipe]) -> Void

    enum Diet: String, CaseIterable {
        case none = ""
        case lactoVegetarian = "lacto vegetarian"
        case ovoVegetarian = "ovo vegetarian"
        case paleo
        case pescetarian
        case primal
        case vegan
        case vegetarian
    }

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
                .offset(x: 10)
            TextField("Max Ready Time (min)", text: $maxReadyTimeString, onCommit: {
                // Handle text field commit if needed
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            // Diet Text
            Text("Diet")
                .offset(x: 10)

            // Diet Picker
            Picker("Diet", selection: $selectedDiet) {
                ForEach(Diet.allCases, id: \.self) { diet in
                    if diet == .none {
                        Text("none").tag(diet)
                    } else {
                        Text(diet.rawValue).tag(diet)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 20, alignment: .leading)
            .cornerRadius(5)
            .background(Color.white)
            .padding(.horizontal)

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
        let maxReadyTime: Int?
        if !maxReadyTimeString.isEmpty {
            maxReadyTime = Int(maxReadyTimeString)
        } else {
            maxReadyTime = nil
        }

        fetchRecipesWithFilter(maxReadyTime: maxReadyTime, diet: selectedDiet)
    }

    private func fetchRecipesWithFilter(maxReadyTime: Int?, diet: Diet) {
        fetchSpoonacularRecipes(query: searchQuery, maxReadyTime: maxReadyTime, diet: diet.rawValue) { recipes in
            if let recipes = recipes {
                withAnimation {
                    isFilterSidebarVisible = false
                }
                onApplyFilters(recipes)
                print("Fetched recipes with filter:", recipes)
            } else {
                print("Failed to fetch recipes.")
            }
        }
    }
}
