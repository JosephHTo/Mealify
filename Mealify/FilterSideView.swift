import SwiftUI

struct FilterSideView: View {
    @Binding var isFilterSidebarVisible: Bool
    @Binding var searchQuery: String
    @State private var dragOffset: CGFloat = 0
    @State private var maxReadyTimeString: String = ""
    @State private var selectedDiet: Diet = .none
    @State private var selectedIntolerances: Set<Intolerances> = []
    @State private var includeIngredients: Set<String> = []
    @State private var excludeIngredients: Set<String> = []
    @State private var newIncludeIngredient: String = ""
    @State private var newExcludeIngredient: String = ""
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
        ZStack {
            ScrollView {
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
                    
                    // includeIngredients Textfield
                    Text("Include Ingredients")
                        .offset(x: 10)

                    TextField("Enter ingredients to include", text: $newIncludeIngredient, onCommit: {
                        // Pressing Enter adds the ingredient to the list and clears the text field
                        includeIngredients.insert(newIncludeIngredient.trimmingCharacters(in: .whitespaces))
                        newIncludeIngredient = ""
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                    // Display entered ingredients for includeIngredients
                    EnteredIngredientsView(ingredients: includeIngredients)

                    // excludeIngredients Textfield
                    Text("Exclude Ingredients")
                        .offset(x: 10)

                    TextField("Enter ingredients to exclude", text: $newExcludeIngredient, onCommit: {
                        // Pressing Enter adds the ingredient to the list and clears the text field
                        excludeIngredients.insert(newExcludeIngredient.trimmingCharacters(in: .whitespaces))
                        newExcludeIngredient = ""
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 200)
                    .padding(.horizontal)

                    // Display entered ingredients for excludeIngredients
                    EnteredIngredientsView(ingredients: excludeIngredients)
                }
                .background(Color.gray)
                .transition(.move(edge: .bottom))
                .offset(y: isFilterSidebarVisible ? UIScreen.main.bounds.height * 0.1 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // Handle tap if needed
                }
            }

            // Clear and Apply Buttons Anchored to Bottom
            VStack {
                Spacer()
                HStack {
                    // Clear Filter Button
                    Button(action: {
                        clearFilters()
                    }) {
                        Text("Clear")
                            .padding()
                            .foregroundColor(Color.blue)
                            .frame(width: 150)
                            .cornerRadius(10)
                    }
                    .offset(x: -20)

                    // Apply Filter Button
                    Button(action: {
                        applyFilters()
                    }) {
                        Text("Apply")
                            .padding()
                            .foregroundColor(Color.white)
                            .frame(width: 200)
                            .cornerRadius(10)
                    }
                    .background(Color.blue)
                    .cornerRadius(10)
                    .offset()
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
                .background(Color.white)
            }
        }
    }
    private func clearFilters() {
        maxReadyTimeString = ""
        selectedDiet = .none
        selectedIntolerances = []
        includeIngredients = []
        excludeIngredients = []
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
            intolerances: selectedIntolerances,
            includeIngredients: includeIngredients,
            excludeIngredients: excludeIngredients
        )

        fetchRecipesWithFilter(filterParameters)
    }

    private func fetchRecipesWithFilter(_ parameters: FilterParameters) {
        // TODO, query should use (tree%20nut)
        let intolerancesString = parameters.intolerances.map { $0.rawValue }.joined(separator: "%2C")
        let includeIngredientsString = parameters.includeIngredients.joined(separator: "%2C")
        let excludeIngredientsString = parameters.excludeIngredients.joined(separator: "%2C")

        fetchSpoonacularRecipes(
            query: searchQuery,
            maxReadyTime: parameters.maxReadyTime,
            diet: parameters.diet.rawValue,
            intolerances: intolerancesString,
            includeIngredients: includeIngredientsString,
            excludeIngredients: excludeIngredientsString
        ) { recipes in
            if let recipes = recipes {
                withAnimation {
                    isFilterSidebarVisible = false
                }
                onApplyFilters(recipes)

            } else {
                print("Failed to fetch recipes.")
            }
        }
    }

    struct FilterParameters {
        let maxReadyTime: Int?
        let diet: FilterSideView.Diet
        let intolerances: Set<Intolerances>
        let includeIngredients: Set<String>
        let excludeIngredients: Set<String>
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

struct EnteredIngredientsView: View {
    var ingredients: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(ingredients.sorted(), id: \.self) { ingredient in
                Text("- \(ingredient)")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}
