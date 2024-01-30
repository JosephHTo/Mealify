import SwiftUI

struct FilterSideView: View {
    @Binding var isFilterSidebarVisible: Bool
    @Binding var searchQuery: String
    @State private var dragOffset: CGFloat = 0
    @State private var maxReadyTimeString: String = ""
    @State private var selectedDiet: Diet = .none
    @State private var selectedIntolerances: Set<Intolerances> = []
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
            
            // Intolerance Text
            Text("Intolerances")
                .offset(x: 10)

            // Intolerance ScrollView
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Intolerances.allCases, id: \.self) { intolerance in
                        Toggle(intolerance.rawValue, isOn: Binding(
                            get: { selectedIntolerances.contains(intolerance) },
                            set: { selected in
                                if selected {
                                    selectedIntolerances.insert(intolerance)
                                } else {
                                    selectedIntolerances.remove(intolerance)
                                }
                            }
                        ))
                    }
                }
                .padding(.horizontal)
            }
            .frame(width: UIScreen.main.bounds.width - 20, height: 150, alignment: .leading)
            .background(Color.white)
            .cornerRadius(5)
            .padding(.horizontal)

            Spacer()
            
            HStack {
                // Clear Filter Button
                Button(action: {
                    clearFilters()
                }) {
                    Text("Clear")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .offset(x: 20)

                // Apply Filter Button
                Button(action: {
                    applyFilters()
                }) {
                    Text("Apply")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .offset(x: UIScreen.main.bounds.width - 165)
            }
            .padding(.bottom, 50)
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
    private func clearFilters() {
        maxReadyTimeString = ""
        selectedDiet = .none
        selectedIntolerances = []
    }
    
    private func applyFilters() {
        guard !searchQuery.isEmpty else {
            withAnimation {
                isFilterSidebarVisible = false
            }
            return
        }

        let maxReadyTime: Int? = maxReadyTimeString.isEmpty ? nil : Int(maxReadyTimeString)

        // TODO, Only include parameters that have values
        let filterParameters = FilterParameters(
            maxReadyTime: maxReadyTime,
            diet: selectedDiet,
            intolerances: selectedIntolerances
        )

        fetchRecipesWithFilter(filterParameters)
    }

    private func fetchRecipesWithFilter(_ parameters: FilterParameters) {
        // TODO, query should use (tree%20nut)
        let intolerancesString = parameters.intolerances.map { $0.rawValue }.joined(separator: "%2C%20")

        fetchSpoonacularRecipes(
            query: searchQuery,
            maxReadyTime: parameters.maxReadyTime,
            diet: parameters.diet.rawValue,
            intolerances: intolerancesString
        ) { recipes in
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

    struct FilterParameters {
        let maxReadyTime: Int?
        let diet: FilterSideView.Diet
        let intolerances: Set<Intolerances>
    }
}

enum Intolerances: String, CaseIterable {
    case dairy
    case egg
    case gluten
    case peanut
    case sesame
    case seafood
    case shellfish
    case soy
    case sulfite
    case treeNut = "tree nut"
    case wheat
}
