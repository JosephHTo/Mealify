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
    
    @State private var minCarbs: String = ""
    @State private var maxCarbs: String = ""
    
    @State private var minProtein: String = ""
    @State private var maxProtein: String = ""
    
    @State private var minCalories: String = ""
    @State private var maxCalories: String = ""
    
    @State private var minFat: String = ""
    @State private var maxFat: String = ""
    
    @State private var minAlcohol: String = ""
    @State private var maxAlcohol: String = ""
    
    @State private var minCaffeine: String = ""
    @State private var maxCaffeine: String = ""
    
    @State private var minCopper: String = ""
    @State private var maxCopper: String = ""
    
    @State private var minCalcium: String = ""
    @State private var maxCalcium: String = ""
    
    @State private var minCholine: String = ""
    @State private var maxCholine: String = ""
    
    @State private var minCholesterol: String = ""
    @State private var maxCholesterol: String = ""
    
    @State private var minFluoride: String = ""
    @State private var maxFluoride: String = ""
    
    @State private var minSaturatedFat: String = ""
    @State private var maxSaturatedFat: String = ""
    
    @State private var minVitaminA: String = ""
    @State private var maxVitaminA: String = ""
    
    @State private var minVitaminC: String = ""
    @State private var maxVitaminC: String = ""
    
    @State private var minVitaminD: String = ""
    @State private var maxVitaminD: String = ""
    
    @State private var minVitaminE: String = ""
    @State private var maxVitaminE: String = ""
    
    @State private var minVitaminK: String = ""
    @State private var maxVitaminK: String = ""
    
    @State private var minVitaminB1: String = ""
    @State private var maxVitaminB1: String = ""
    
    @State private var minVitaminB2: String = ""
    @State private var maxVitaminB2: String = ""
    
    @State private var minVitaminB5: String = ""
    @State private var maxVitaminB5: String = ""
    
    @State private var minVitaminB3: String = ""
    @State private var maxVitaminB3: String = ""
    
    @State private var minVitaminB6: String = ""
    @State private var maxVitaminB6: String = ""
    
    @State private var minVitaminB12: String = ""
    @State private var maxVitaminB12: String = ""
    
    @State private var minFiber: String = ""
    @State private var maxFiber: String = ""
    
    @State private var minFolate: String = ""
    @State private var maxFolate: String = ""
    
    @State private var minFolicAcid: String = ""
    @State private var maxFolicAcid: String = ""
    
    @State private var minIodine: String = ""
    @State private var maxIodine: String = ""
    
    @State private var minIron: String = ""
    @State private var maxIron: String = ""
    
    @State private var minMagnesium: String = ""
    @State private var maxMagnesium: String = ""
    
    @State private var minManganese: String = ""
    @State private var maxManganese: String = ""
    
    @State private var minPhosphorus: String = ""
    @State private var maxPhosphorus: String = ""
    
    @State private var minPotassium: String = ""
    @State private var maxPotassium: String = ""
    
    @State private var minSelenium: String = ""
    @State private var maxSelenium: String = ""
    
    @State private var minSodium: String = ""
    @State private var maxSodium: String = ""
    
    @State private var minSugar: String = ""
    @State private var maxSugar: String = ""
    
    @State private var minZinc: String = ""
    @State private var maxZinc: String = ""
    
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
                            if dragOffset > 11 {
                                withAnimation {
                                    isFilterSidebarVisible = false
                                }
                            }
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
                    EnteredIngredientsView(ingredients: includeIngredients, includeIngredients: $includeIngredients, excludeIngredients: $excludeIngredients)

                    // excludeIngredients Textfield
                    Text("Exclude Ingredients")
                        .offset(x: 10)

                    TextField("Enter ingredients to exclude", text: $newExcludeIngredient, onCommit: {
                        // Pressing Enter adds the ingredient to the list and clears the text field
                        excludeIngredients.insert(newExcludeIngredient.trimmingCharacters(in: .whitespaces))
                        newExcludeIngredient = ""
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                    // Display entered ingredients for excludeIngredients
                    EnteredIngredientsView(ingredients: excludeIngredients, includeIngredients: $includeIngredients, excludeIngredients: $excludeIngredients)
                    
                    // Start of Nutrient filters
                    // Carbs
                    Text("Carbs")
                        .offset(x: 10)
                    
                    // Min and Max Carbs Textfields
                    HStack {
                        TextField("Min Carbs (g)", text: $minCarbs)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Carbs (g)", text: $maxCarbs)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Protein
                    Text("Protein")
                        .offset(x: 10)
                    
                    // Min and Max Protein Textfields
                    HStack {
                        TextField("Min Protein (g)", text: $minProtein)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Protein (g)", text: $maxProtein)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Calories
                    Text("Calories")
                        .offset(x: 10)
                    
                    // Min and Max Calories Textfields
                    HStack {
                        TextField("Min Calories", text: $minCalories)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Calories", text: $maxCalories)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Fat
                    Text("Fat")
                        .offset(x: 10)
                    
                    // Min and Max Fat Textfields
                    HStack {
                        TextField("Min Fat (g)", text: $minFat)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Fat (g)", text: $maxFat)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Alcohol
                    Text("Alcohol")
                        .offset(x: 10)
                    
                    // Min and Max Alcohol Textfields
                    HStack {
                        TextField("Min Alcohol (g)", text: $minAlcohol)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Alcohol (g)", text: $maxAlcohol)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Caffeine
                    Text("Caffeine")
                        .offset(x: 10)
                    
                    // Min and Max Caffeine  Textfields
                    HStack {
                        TextField("Min Caffeine (mg)", text: $minCaffeine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Caffeine (mg)", text: $maxCaffeine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Copper
                    Text("Copper")
                        .offset(x: 10)
                    
                    // Min and Max Copper Textfields
                    HStack {
                        TextField("Min Copper (mg)", text: $minCopper)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Copper (mg)", text: $maxCopper)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Calcium
                    Text("Calcium")
                        .offset(x: 10)
                    
                    // Min and Max Calcium Textfields
                    HStack {
                        TextField("Min Calcium (mg)", text: $minCalcium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Calcium (mg)", text: $maxCalcium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Choline
                    Text("Choline")
                        .offset(x: 10)
                    
                    // Min and Max Choline Textfields
                    HStack {
                        TextField("Min Choline (mg)", text: $minCholine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Choline (mg)", text: $maxCholine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Cholesterol
                    Text("Cholesterol")
                        .offset(x: 10)
                    
                    // Min and Max Cholesterol Textfields
                    HStack {
                        TextField("Min Cholesterol (mg)", text: $minCholesterol)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Cholesterol (mg)", text: $maxCholesterol)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Fluoride
                    Text("Fluoride")
                        .offset(x: 10)
                    
                    // Min and Max Fluoride Textfields
                    HStack {
                        TextField("Min Fluoride (mg)", text: $minFluoride)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Fluoride (mg)", text: $maxFluoride)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Saturated Fat
                    Text("Saturated Fat")
                        .offset(x: 10)
                    
                    // Min and Max Saturated Fat Textfields
                    HStack {
                        TextField("Min Saturated Fat (mg)", text: $minSaturatedFat)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Saturated Fat (mg)", text: $maxSaturatedFat)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin A
                    Text("Vitamin A")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin A Textfields
                    HStack {
                        TextField("Min Vitamin A (IU)", text: $minVitaminA)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin A (IU)", text: $maxVitaminA)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin C
                    Text("Vitamin C")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin C Textfields
                    HStack {
                        TextField("Min Vitamin C (mg)", text: $minVitaminC)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin C (mg)", text: $maxVitaminC)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin D
                    Text("Vitamin D")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin D Textfields
                    HStack {
                        TextField("Min Vitamin D (mcg)", text: $minVitaminD)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin D (mcg)", text: $maxVitaminD)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin E
                    Text("Vitamin E")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin E Textfields
                    HStack {
                        TextField("Min Vitamin E (mg)", text: $minVitaminE)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin E (mg)", text: $maxVitaminE)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin K
                    Text("Vitamin K")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin K Textfields
                    HStack {
                        TextField("Min Vitamin K (mcg)", text: $minVitaminK)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin K (mcg)", text: $maxVitaminK)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin B1
                    Text("Vitamin B1")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin B1 Textfields
                    HStack {
                        TextField("Min Vitamin B1 (mg)", text: $minVitaminB1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin B1 (mg)", text: $maxVitaminB1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin B2
                    Text("Vitamin B2")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin B2 Textfields
                    HStack {
                        TextField("Min Vitamin B2 (mg)", text: $minVitaminB2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin B2 (mg)", text: $maxVitaminB2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin B5
                    Text("Vitamin B5")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin B5 Textfields
                    HStack {
                        TextField("Min Vitamin B5 (mg)", text: $minVitaminB5)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin B5 (mg)", text: $maxVitaminB5)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin B3
                    Text("Vitamin B3")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin B3 Textfields
                    HStack {
                        TextField("Min Vitamin B3 (mg)", text: $minVitaminB3)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin B3 (mg)", text: $maxVitaminB3)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin B6
                    Text("Vitamin B6")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin B6 Textfields
                    HStack {
                        TextField("Min Vitamin B6 (mg)", text: $minVitaminB6)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin B6 (mg)", text: $maxVitaminB6)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Vitamin B12
                    Text("Vitamin B12")
                        .offset(x: 10)
                    
                    // Min and Max Vitamin B12 Textfields
                    HStack {
                        TextField("Min Vitamin B12 (mg)", text: $minVitaminB12)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Vitamin B12 (mg)", text: $maxVitaminB12)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Fiber
                    Text("Fiber")
                        .offset(x: 10)
                    
                    // Min and Max Fiber Textfields
                    HStack {
                        TextField("Min Fiber (g)", text: $minFiber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Fiber (g)", text: $maxFiber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Folate
                    Text("Folate")
                        .offset(x: 10)
                    
                    // Min and Max Folate Textfields
                    HStack {
                        TextField("Min Folate (mcg)", text: $minFolate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Folate (mcg)", text: $maxFolate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Folic Acid
                    Text("Folic Acid")
                        .offset(x: 10)
                    
                    // Min and Max Folic Acid Textfields
                    HStack {
                        TextField("Min Folic Acid (mg)", text: $minFolicAcid)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Folic Acid (mg)", text: $maxFolicAcid)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Iodine
                    Text("Iodine")
                        .offset(x: 10)
                    
                    // Min and Max Iodine Textfields
                    HStack {
                        TextField("Min Iodine (mcg)", text: $minIodine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Iodine (mcg)", text: $maxIodine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Iron
                    Text("Iron")
                        .offset(x: 10)
                    
                    // Min and Max Iron Textfields
                    HStack {
                        TextField("Min Iron (mg)", text: $minIron)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Iron (mg)", text: $maxIron)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Magnesium
                    Text("Magnesium")
                        .offset(x: 10)
                    
                    // Min and Max Magnesium Textfields
                    HStack {
                        TextField("Min Magnesium (mg)", text: $minMagnesium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Magnesium (mg)", text: $maxMagnesium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Manganese
                    Text("Manganese")
                        .offset(x: 10)
                    
                    // Min and Max Manganese Textfields
                    HStack {
                        TextField("Min Manganese (mg)", text: $minManganese)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Manganese (mg)", text: $maxManganese)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Phosphorus
                    Text("Phosphorus")
                        .offset(x: 10)
                    
                    // Min and Max Phosphorus Textfields
                    HStack {
                        TextField("Min Phosphorus (mg)", text: $minPhosphorus)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Phosphorus (mg)", text: $maxPhosphorus)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Potassium
                    Text("Potassium")
                        .offset(x: 10)
                    
                    // Min and Max Potassium Textfields
                    HStack {
                        TextField("Min Potassium (mg)", text: $minPotassium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Potassium (mg)", text: $maxPotassium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Selenium
                    Text("Selenium")
                        .offset(x: 10)
                    
                    // Min and Max Selenium Textfields
                    HStack {
                        TextField("Min Selenium (mcg)", text: $minSelenium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Selenium (mcg)", text: $maxSelenium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Sodium
                    Text("Sodium")
                        .offset(x: 10)
                    
                    // Min and Max Sodium Textfields
                    HStack {
                        TextField("Min Sodium (mg)", text: $minSodium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Sodium (mg)", text: $maxSodium)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Sugar
                    Text("Sugar")
                        .offset(x: 10)
                    
                    // Min and Max Sugar Textfields
                    HStack {
                        TextField("Min Sugar (g)", text: $minSugar)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Sugar (g)", text: $maxSugar)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Zinc
                    Text("Zinc")
                        .offset(x: 10)
                    
                    // Min and Max Zinc Textfields
                    HStack {
                        TextField("Min Zinc (mg)", text: $minZinc)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Max Zinc (mg)", text: $maxZinc)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                }
                .background(Color.gray)
                .padding(.bottom, 300)
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
        minCarbs = ""
        maxCarbs = ""
        minProtein = ""
        maxProtein = ""
        minCalories = ""
        maxCalories = ""
        minFat = ""
        maxFat = ""
        minAlcohol = ""
        maxAlcohol = ""
        minCaffeine = ""
        maxCaffeine = ""
        minCopper = ""
        maxCopper = ""
        minCalcium = ""
        maxCalcium = ""
        minCholine = ""
        maxCholine = ""
    }
    
    private func applyFilters() {
        guard !searchQuery.isEmpty else {
            withAnimation {
                isFilterSidebarVisible = false
            }
            return
        }

        let maxReadyTime: Int? = maxReadyTimeString.isEmpty ? nil : Int(maxReadyTimeString)
        let minCarbs: Int? = minCarbs.isEmpty ? nil : Int(minCarbs)
        let maxCarbs: Int? = maxCarbs.isEmpty ? nil : Int(maxCarbs)
        let minProtein: Int? = minProtein.isEmpty ? nil : Int(minProtein)
        let maxProtein: Int? = maxProtein.isEmpty ? nil : Int(maxProtein)
        let minCalories: Int? = minCalories.isEmpty ? nil : Int(minCalories)
        let maxCalories: Int? = maxCalories.isEmpty ? nil : Int(maxCalories)
        let minFat: Int? = minFat.isEmpty ? nil : Int(minFat)
        let maxFat: Int? = maxFat.isEmpty ? nil : Int(maxFat)
        let minAlcohol: Int? = minAlcohol.isEmpty ? nil : Int(minAlcohol)
        let maxAlcohol: Int? = maxAlcohol.isEmpty ? nil : Int(maxAlcohol)
        let minCaffeine: Int? = minCaffeine.isEmpty ? nil : Int(minCaffeine)
        let maxCaffeine: Int? = maxCaffeine.isEmpty ? nil : Int(maxCaffeine)
        let minCopper: Int? = minCopper.isEmpty ? nil : Int(minCopper)
        let maxCopper: Int? = maxCopper.isEmpty ? nil : Int(maxCopper)
        let minCalcium: Int? = minCalcium.isEmpty ? nil : Int(minCalcium)
        let maxCalcium: Int? = maxCalcium.isEmpty ? nil : Int(maxCalcium)
        let minCholine: Int? = minCholine.isEmpty ? nil : Int(minCholine)
        let maxCholine: Int? = maxCholine.isEmpty ? nil : Int(maxCholine)
        let minCholesterol: Int? = minCholesterol.isEmpty ? nil : Int(minCholesterol)
        let maxCholesterol: Int? = maxCholesterol.isEmpty ? nil : Int(maxCholesterol)
        let minFluoride: Int? = minFluoride.isEmpty ? nil : Int(minFluoride)
        let maxFluoride: Int? = maxFluoride.isEmpty ? nil : Int(maxFluoride)
        let minSaturatedFat: Int? = minSaturatedFat.isEmpty ? nil : Int(minSaturatedFat)
        let maxSaturatedFat: Int? = maxSaturatedFat.isEmpty ? nil : Int(maxSaturatedFat)
        let minVitaminA: Int? = minVitaminA.isEmpty ? nil : Int(minVitaminA)
        let maxVitaminA: Int? = maxVitaminA.isEmpty ? nil : Int(maxVitaminA)
        let minVitaminC: Int? = minVitaminC.isEmpty ? nil : Int(minVitaminC)
        let maxVitaminC: Int? = maxVitaminC.isEmpty ? nil : Int(maxVitaminC)
        let minVitaminD: Int? = minVitaminD.isEmpty ? nil : Int(minVitaminD)
        let maxVitaminD: Int? = maxVitaminD.isEmpty ? nil : Int(maxVitaminD)
        let minVitaminE: Int? = minVitaminE.isEmpty ? nil : Int(minVitaminE)
        let maxVitaminE: Int? = maxVitaminE.isEmpty ? nil : Int(maxVitaminE)
        let minVitaminK: Int? = minVitaminK.isEmpty ? nil : Int(minVitaminK)
        let maxVitaminK: Int? = maxVitaminK.isEmpty ? nil : Int(maxVitaminK)
        let minVitaminB1: Int? = minVitaminB1.isEmpty ? nil : Int(minVitaminB1)
        let maxVitaminB1: Int? = maxVitaminB1.isEmpty ? nil : Int(maxVitaminB1)
        let minVitaminB2: Int? = minVitaminB2.isEmpty ? nil : Int(minVitaminB2)
        let maxVitaminB2: Int? = maxVitaminB2.isEmpty ? nil : Int(maxVitaminB2)
        let minVitaminB5: Int? = minVitaminB5.isEmpty ? nil : Int(minVitaminB5)
        let maxVitaminB5: Int? = maxVitaminB5.isEmpty ? nil : Int(maxVitaminB5)
        let minVitaminB3: Int? = minVitaminB3.isEmpty ? nil : Int(minVitaminB3)
        let maxVitaminB3: Int? = maxVitaminB3.isEmpty ? nil : Int(maxVitaminB3)
        let minVitaminB6: Int? = minVitaminB6.isEmpty ? nil : Int(minVitaminB6)
        let maxVitaminB6: Int? = maxVitaminB6.isEmpty ? nil : Int(maxVitaminB6)
        let minVitaminB12: Int? = minVitaminB12.isEmpty ? nil : Int(minVitaminB12)
        let maxVitaminB12: Int? = maxVitaminB12.isEmpty ? nil : Int(maxVitaminB12)
        let minFiber: Int? = minFiber.isEmpty ? nil : Int(minFiber)
        let maxFiber: Int? = maxFiber.isEmpty ? nil : Int(maxFiber)
        let minFolate: Int? = minFolate.isEmpty ? nil : Int(minFolate)
        let maxFolate: Int? = maxFolate.isEmpty ? nil : Int(maxFolate)
        let minFolicAcid: Int? = minFolicAcid.isEmpty ? nil : Int(minFolicAcid)
        let maxFolicAcid: Int? = maxFolicAcid.isEmpty ? nil : Int(maxFolicAcid)
        let minIodine: Int? = minIodine.isEmpty ? nil : Int(minIodine)
        let maxIodine: Int? = maxIodine.isEmpty ? nil : Int(maxIodine)
        let minIron: Int? = minIron.isEmpty ? nil : Int(minIron)
        let maxIron: Int? = maxIron.isEmpty ? nil : Int(maxIron)
        let minMagnesium: Int? = minMagnesium.isEmpty ? nil : Int(minMagnesium)
        let maxMagnesium: Int? = maxMagnesium.isEmpty ? nil : Int(maxMagnesium)
        let minManganese: Int? = minManganese.isEmpty ? nil : Int(minManganese)
        let maxManganese: Int? = maxManganese.isEmpty ? nil : Int(maxManganese)
        let minPhosphorus: Int? = minPhosphorus.isEmpty ? nil : Int(minPhosphorus)
        let maxPhosphorus: Int? = maxPhosphorus.isEmpty ? nil : Int(maxPhosphorus)
        let minPotassium: Int? = minPotassium.isEmpty ? nil : Int(minPotassium)
        let maxPotassium: Int? = maxPotassium.isEmpty ? nil : Int(maxPotassium)
        let minSelenium: Int? = minSelenium.isEmpty ? nil : Int(minSelenium)
        let maxSelenium: Int? = maxSelenium.isEmpty ? nil : Int(maxSelenium)
        let minSodium: Int? = minSodium.isEmpty ? nil : Int(minSodium)
        let maxSodium: Int? = maxSodium.isEmpty ? nil : Int(maxSodium)
        let minSugar: Int? = minSugar.isEmpty ? nil : Int(minSugar)
        let maxSugar: Int? = maxSugar.isEmpty ? nil : Int(maxSugar)
        let minZinc: Int? = minZinc.isEmpty ? nil : Int(minZinc)
        let maxZinc: Int? = maxZinc.isEmpty ? nil : Int(maxZinc)

        // TODO, Only include parameters that have values
        let filterParameters = FilterParameters(
            maxReadyTime: maxReadyTime,
            diet: selectedDiet,
            intolerances: selectedIntolerances,
            includeIngredients: includeIngredients,
            excludeIngredients: excludeIngredients,
            minCarbs: minCarbs,
            maxCarbs: maxCarbs,
            minProtein: minProtein,
            maxProtein: maxProtein,
            minCalories: minCalories,
            maxCalories: maxCalories,
            minFat: minFat,
            maxFat: maxFat,
            minAlcohol: minAlcohol,
            maxAlcohol: maxAlcohol,
            minCaffeine: minCaffeine,
            maxCaffeine: maxCaffeine,
            minCopper: minCopper,
            maxCopper: maxCopper,
            minCalcium: minCalcium,
            maxCalcium: maxCalcium,
            minCholine: minCholine,
            maxCholine: maxCholine,
            minCholesterol: minCholesterol,
            maxCholesterol: maxCholesterol,
            minFluoride: minFluoride,
            maxFluoride: maxFluoride,
            minSaturatedFat: minSaturatedFat,
            maxSaturatedFat: maxSaturatedFat,
            minVitaminA: minVitaminA,
            maxVitaminA: maxVitaminA,
            minVitaminC: minVitaminC,
            maxVitaminC: maxVitaminC,
            minVitaminD: minVitaminD,
            maxVitaminD: maxVitaminD,
            minVitaminE: minVitaminE,
            maxVitaminE: maxVitaminE,
            minVitaminK: minVitaminK,
            maxVitaminK: maxVitaminK,
            minVitaminB1: minVitaminB1,
            maxVitaminB1: maxVitaminB1,
            minVitaminB2: minVitaminB2,
            maxVitaminB2: maxVitaminB2,
            minVitaminB5: minVitaminB5,
            maxVitaminB5: maxVitaminB5,
            minVitaminB3: minVitaminB3,
            maxVitaminB3: maxVitaminB3,
            minVitaminB6: minVitaminB6,
            maxVitaminB6: maxVitaminB6,
            minVitaminB12: minVitaminB12,
            maxVitaminB12: maxVitaminB12,
            minFiber: minFiber,
            maxFiber: maxFiber,
            minFolate: minFolate,
            maxFolate: maxFolate,
            minFolicAcid: minFolicAcid,
            maxFolicAcid: maxFolicAcid,
            minIodine: minIodine,
            maxIodine: maxIodine,
            minIron: minIron,
            maxIron: maxIron,
            minMagnesium: minMagnesium,
            maxMagnesium: maxMagnesium,
            minManganese: minManganese,
            maxManganese: maxManganese,
            minPhosphorus: minPhosphorus,
            maxPhosphorus: maxPhosphorus,
            minPotassium: minPotassium,
            maxPotassium: maxPotassium,
            minSelenium: minSelenium,
            maxSelenium: maxSelenium,
            minSodium: minSodium,
            maxSodium: maxSodium,
            minSugar: minSugar,
            maxSugar: maxSugar,
            minZinc: minZinc,
            maxZinc: maxZinc
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
            excludeIngredients: excludeIngredientsString,
            minCarbs: parameters.minCarbs,
            maxCarbs: parameters.maxCarbs,
            minProtein: parameters.minProtein,
            maxProtein: parameters.maxProtein,
            minCalories: parameters.minCalories,
            maxCalories: parameters.maxCalories,
            minFat: parameters.minFat,
            maxFat: parameters.maxFat,
            minAlcohol: parameters.minAlcohol,
            maxAlcohol: parameters.maxAlcohol,
            minCaffeine: parameters.minCaffeine,
            maxCaffeine: parameters.maxCaffeine,
            minCopper: parameters.minCopper,
            maxCopper: parameters.maxCopper,
            minCalcium: parameters.minCalcium,
            maxCalcium: parameters.maxCalcium,
            minCholine: parameters.minCholine,
            maxCholine: parameters.maxCholine,
            minCholesterol: parameters.minCholesterol,
            maxCholesterol: parameters.maxCholesterol,
            minFluoride: parameters.minFluoride,
            maxFluoride: parameters.maxFluoride,
            minSaturatedFat: parameters.minSaturatedFat,
            maxSaturatedFat: parameters.maxSaturatedFat,
            minVitaminA: parameters.minVitaminA,
            maxVitaminA: parameters.maxVitaminA,
            minVitaminC: parameters.minVitaminC,
            maxVitaminC: parameters.maxVitaminC,
            minVitaminD: parameters.minVitaminD,
            maxVitaminD: parameters.maxVitaminD,
            minVitaminE: parameters.minVitaminE,
            maxVitaminE: parameters.maxVitaminE,
            minVitaminK: parameters.minVitaminK,
            maxVitaminK: parameters.maxVitaminK,
            minVitaminB1: parameters.minVitaminB1,
            maxVitaminB1: parameters.maxVitaminB1,
            minVitaminB2: parameters.minVitaminB2,
            maxVitaminB2: parameters.maxVitaminB2,
            minVitaminB5: parameters.minVitaminB5,
            maxVitaminB5: parameters.maxVitaminB5,
            minVitaminB3: parameters.minVitaminB3,
            maxVitaminB3: parameters.maxVitaminB3,
            minVitaminB6: parameters.minVitaminB6,
            maxVitaminB6: parameters.maxVitaminB6,
            minVitaminB12: parameters.minVitaminB12,
            maxVitaminB12: parameters.maxVitaminB12,
            minFiber: parameters.minFiber,
            maxFiber: parameters.maxFiber,
            minFolate: parameters.minFolate,
            maxFolate: parameters.maxFolate,
            minFolicAcid: parameters.minFolicAcid,
            maxFolicAcid: parameters.maxFolicAcid,
            minIodine: parameters.minIodine,
            maxIodine: parameters.maxIodine,
            minIron: parameters.minIron,
            maxIron: parameters.maxIron,
            minMagnesium: parameters.minMagnesium,
            maxMagnesium: parameters.maxMagnesium,
            minManganese: parameters.minManganese,
            maxManganese: parameters.maxManganese,
            minPhosphorus: parameters.minPhosphorus,
            maxPhosphorus: parameters.maxPhosphorus,
            minPotassium: parameters.minPotassium,
            maxPotassium: parameters.maxPotassium,
            minSelenium: parameters.minSelenium,
            maxSelenium: parameters.maxSelenium,
            minSodium: parameters.minSodium,
            maxSodium: parameters.maxSodium,
            minSugar: parameters.minSugar,
            maxSugar: parameters.maxSugar,
            minZinc: parameters.minZinc,
            maxZinc: parameters.maxZinc
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
    
    struct EnteredIngredientsView: View {
        var ingredients: Set<String>
        @Binding var includeIngredients: Set<String>
        @Binding var excludeIngredients: Set<String>

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                ForEach(ingredients.sorted(), id: \.self) { ingredient in
                    HStack {
                        Text("- \(ingredient)")
                            .foregroundColor(.blue)
                        Spacer()
                        Button(action: {
                            // Remove the ingredient from the appropriate list
                            if includeIngredients.contains(ingredient) {
                                includeIngredients.remove(ingredient)
                            } else if excludeIngredients.contains(ingredient) {
                                excludeIngredients.remove(ingredient)
                            }
                        }) {
                            Image(systemName: "x.circle")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    struct FilterParameters {
        let maxReadyTime: Int?
        let diet: FilterSideView.Diet
        let intolerances: Set<Intolerances>
        let includeIngredients: Set<String>
        let excludeIngredients: Set<String>
        let minCarbs: Int?
        let maxCarbs: Int?
        let minProtein: Int?
        let maxProtein: Int?
        let minCalories: Int?
        let maxCalories: Int?
        let minFat: Int?
        let maxFat: Int?
        let minAlcohol: Int?
        let maxAlcohol: Int?
        let minCaffeine: Int?
        let maxCaffeine: Int?
        let minCopper: Int?
        let maxCopper: Int?
        let minCalcium: Int?
        let maxCalcium: Int?
        let minCholine: Int?
        let maxCholine: Int?
        let minCholesterol: Int?
        let maxCholesterol: Int?
        let minFluoride: Int?
        let maxFluoride: Int?
        let minSaturatedFat: Int?
        let maxSaturatedFat: Int?
        let minVitaminA: Int?
        let maxVitaminA: Int?
        let minVitaminC: Int?
        let maxVitaminC: Int?
        let minVitaminD: Int?
        let maxVitaminD: Int?
        let minVitaminE: Int?
        let maxVitaminE: Int?
        let minVitaminK: Int?
        let maxVitaminK: Int?
        let minVitaminB1: Int?
        let maxVitaminB1: Int?
        let minVitaminB2: Int?
        let maxVitaminB2: Int?
        let minVitaminB5: Int?
        let maxVitaminB5: Int?
        let minVitaminB3: Int?
        let maxVitaminB3: Int?
        let minVitaminB6: Int?
        let maxVitaminB6: Int?
        let minVitaminB12: Int?
        let maxVitaminB12: Int?
        let minFiber: Int?
        let maxFiber: Int?
        let minFolate: Int?
        let maxFolate: Int?
        let minFolicAcid: Int?
        let maxFolicAcid: Int?
        let minIodine: Int?
        let maxIodine: Int?
        let minIron: Int?
        let maxIron: Int?
        let minMagnesium: Int?
        let maxMagnesium: Int?
        let minManganese: Int?
        let maxManganese: Int?
        let minPhosphorus: Int?
        let maxPhosphorus: Int?
        let minPotassium: Int?
        let maxPotassium: Int?
        let minSelenium: Int?
        let maxSelenium: Int?
        let minSodium: Int?
        let maxSodium: Int?
        let minSugar: Int?
        let maxSugar: Int?
        let minZinc: Int?
        let maxZinc: Int?
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
