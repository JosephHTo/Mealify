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
    @State private var minCarbsIsEmpty = true
    @State private var maxCarbsIsEmpty = true
    
    @State private var minProtein: String = ""
    @State private var maxProtein: String = ""
    @State private var minProteinIsEmpty = true
    @State private var maxProteinIsEmpty = true
    
    @State private var minCalories: String = ""
    @State private var maxCalories: String = ""
    @State private var minCaloriesIsEmpty = true
    @State private var maxCaloriesIsEmpty = true
    
    @State private var minFat: String = ""
    @State private var maxFat: String = ""
    @State private var minFatIsEmpty = true
    @State private var maxFatIsEmpty = true
    
    @State private var minAlcohol: String = ""
    @State private var maxAlcohol: String = ""
    @State private var minAlcoholIsEmpty = true
    @State private var maxAlcoholIsEmpty = true
    
    @State private var minCaffeine: String = ""
    @State private var maxCaffeine: String = ""
    @State private var minCaffeineIsEmpty = true
    @State private var maxCaffeineIsEmpty = true
    
    @State private var minCopper: String = ""
    @State private var maxCopper: String = ""
    @State private var minCopperIsEmpty = true
    @State private var maxCopperIsEmpty = true

    @State private var minCalcium: String = ""
    @State private var maxCalcium: String = ""
    @State private var minCalciumIsEmpty = true
    @State private var maxCalciumIsEmpty = true

    @State private var minCholine: String = ""
    @State private var maxCholine: String = ""
    @State private var minCholineIsEmpty = true
    @State private var maxCholineIsEmpty = true

    @State private var minCholesterol: String = ""
    @State private var maxCholesterol: String = ""
    @State private var minCholesterolIsEmpty = true
    @State private var maxCholesterolIsEmpty = true

    @State private var minFluoride: String = ""
    @State private var maxFluoride: String = ""
    @State private var minFluorideIsEmpty = true
    @State private var maxFluorideIsEmpty = true

    @State private var minSaturatedFat: String = ""
    @State private var maxSaturatedFat: String = ""
    @State private var minSaturatedFatIsEmpty = true
    @State private var maxSaturatedFatIsEmpty = true

    @State private var minVitaminA: String = ""
    @State private var maxVitaminA: String = ""
    @State private var minVitaminAIsEmpty = true
    @State private var maxVitaminAIsEmpty = true

    @State private var minVitaminC: String = ""
    @State private var maxVitaminC: String = ""
    @State private var minVitaminCIsEmpty = true
    @State private var maxVitaminCIsEmpty = true

    @State private var minVitaminD: String = ""
    @State private var maxVitaminD: String = ""
    @State private var minVitaminDIsEmpty = true
    @State private var maxVitaminDIsEmpty = true

    @State private var minVitaminE: String = ""
    @State private var maxVitaminE: String = ""
    @State private var minVitaminEIsEmpty = true
    @State private var maxVitaminEIsEmpty = true

    @State private var minVitaminK: String = ""
    @State private var maxVitaminK: String = ""
    @State private var minVitaminKIsEmpty = true
    @State private var maxVitaminKIsEmpty = true

    @State private var minVitaminB1: String = ""
    @State private var maxVitaminB1: String = ""
    @State private var minVitaminB1IsEmpty = true
    @State private var maxVitaminB1IsEmpty = true

    @State private var minVitaminB2: String = ""
    @State private var maxVitaminB2: String = ""
    @State private var minVitaminB2IsEmpty = true
    @State private var maxVitaminB2IsEmpty = true

    @State private var minVitaminB5: String = ""
    @State private var maxVitaminB5: String = ""
    @State private var minVitaminB5IsEmpty = true
    @State private var maxVitaminB5IsEmpty = true

    @State private var minVitaminB3: String = ""
    @State private var maxVitaminB3: String = ""
    @State private var minVitaminB3IsEmpty = true
    @State private var maxVitaminB3IsEmpty = true

    @State private var minVitaminB6: String = ""
    @State private var maxVitaminB6: String = ""
    @State private var minVitaminB6IsEmpty = true
    @State private var maxVitaminB6IsEmpty = true

    @State private var minVitaminB12: String = ""
    @State private var maxVitaminB12: String = ""
    @State private var minVitaminB12IsEmpty = true
    @State private var maxVitaminB12IsEmpty = true

    @State private var minFiber: String = ""
    @State private var maxFiber: String = ""
    @State private var minFiberIsEmpty = true
    @State private var maxFiberIsEmpty = true

    @State private var minFolate: String = ""
    @State private var maxFolate: String = ""
    @State private var minFolateIsEmpty = true
    @State private var maxFolateIsEmpty = true

    @State private var minFolicAcid: String = ""
    @State private var maxFolicAcid: String = ""
    @State private var minFolicAcidIsEmpty = true
    @State private var maxFolicAcidIsEmpty = true

    @State private var minIodine: String = ""
    @State private var maxIodine: String = ""
    @State private var minIodineIsEmpty = true
    @State private var maxIodineIsEmpty = true

    @State private var minIron: String = ""
    @State private var maxIron: String = ""
    @State private var minIronIsEmpty = true
    @State private var maxIronIsEmpty = true

    @State private var minMagnesium: String = ""
    @State private var maxMagnesium: String = ""
    @State private var minMagnesiumIsEmpty = true
    @State private var maxMagnesiumIsEmpty = true

    @State private var minManganese: String = ""
    @State private var maxManganese: String = ""
    @State private var minManganeseIsEmpty = true
    @State private var maxManganeseIsEmpty = true

    @State private var minPhosphorus: String = ""
    @State private var maxPhosphorus: String = ""
    @State private var minPhosphorusIsEmpty = true
    @State private var maxPhosphorusIsEmpty = true

    @State private var minPotassium: String = ""
    @State private var maxPotassium: String = ""
    @State private var minPotassiumIsEmpty = true
    @State private var maxPotassiumIsEmpty = true

    @State private var minSelenium: String = ""
    @State private var maxSelenium: String = ""
    @State private var minSeleniumIsEmpty = true
    @State private var maxSeleniumIsEmpty = true

    @State private var minSodium: String = ""
    @State private var maxSodium: String = ""
    @State private var minSodiumIsEmpty = true
    @State private var maxSodiumIsEmpty = true

    @State private var minSugar: String = ""
    @State private var maxSugar: String = ""
    @State private var minSugarIsEmpty = true
    @State private var maxSugarIsEmpty = true

    @State private var minZinc: String = ""
    @State private var maxZinc: String = ""
    @State private var minZincIsEmpty = true
    @State private var maxZincIsEmpty = true

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
                            .cornerRadius(5)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .offset(y: dragOffset)
                    .gesture(DragGesture()
                        .onChanged { value in
                            dragOffset = max(0, value.translation.height)
                            if dragOffset > 15 {
                                withAnimation {
                                    isFilterSidebarVisible = false
                                }
                            }
                        }
                    )
                    
                    Text("FILTERS")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 15)
                        .offset(y: -10)
                    
                    Divider()
                        .overlay(Color.white)
                        .padding(.horizontal, 15)
                    
                    // Max Ready Time
                    VStack (alignment: .leading) {
                        Text("MAX TIME")
                            .font(.headline)
                        
                        TextField("Minutes", text: $maxReadyTimeString, onCommit: {
                            // Handle text field commit if needed
                        })
                        .padding()
                        .background(maxReadyTimeString.isEmpty ? Color.white : Color.yellow)
                        .cornerRadius(5)
                    }
                    .padding(.horizontal, 15)
                    
                    Divider()
                        .overlay(Color.white)
                        .padding(.horizontal, 15)
                    
                    // Diet
                    VStack (alignment: .leading) {
                        Text("DIET")
                            .font(.headline)
                        
                        // Diet Picker
                        Picker("Diet", selection: $selectedDiet) {
                            ForEach(Diet.allCases, id: \.self) { diet in
                                if diet == .none {
                                    Text("none")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .tag(diet)
                                } else {
                                    Text(diet.rawValue)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .tag(diet)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedDiet != .none ? Color.yellow : Color.white)
                        .cornerRadius(5)
                        .clipped() // Ensure background color doesn't overflow
                    }
                    .padding(.horizontal, 15)
                    
                    Divider()
                        .overlay(Color.white)
                        .padding(.horizontal, 15)
                    
                    // Intolerance DisclosureGroup
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Intolerances.allCases, id: \.self) { intolerance in
                                Toggle(intolerance.rawValue.capitalized, isOn: Binding(
                                    get: { selectedIntolerances.contains(intolerance) },
                                    set: { selected in
                                        if selected {
                                            selectedIntolerances.insert(intolerance)
                                        } else {
                                            selectedIntolerances.remove(intolerance)
                                        }
                                    }
                                ))
                                .toggleStyle(ColoredToggleStyle(intolerance: intolerance, selectedIntolerances: selectedIntolerances))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding(.horizontal, 15)
                    } label: {
                        HStack {
                            Text("INTOLERANCES")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    Divider()
                        .overlay(Color.white)
                        .padding(.horizontal, 15)
                    
                    // Include Ingredients
                    VStack (alignment: .leading) {
                        Text("INCLUDE INGREDIENTS")
                            .font(.headline)
                        
                        TextField("Enter ingredients to include", text: $newIncludeIngredient, onCommit: {
                            includeIngredients.insert(newIncludeIngredient.trimmingCharacters(in: .whitespaces))
                            newIncludeIngredient = ""
                        })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        
                        // Display entered ingredients for includeIngredients
                        EnteredIngredientsView(ingredients: includeIngredients, includeIngredients: $includeIngredients, excludeIngredients: $excludeIngredients)
                    }
                    .padding(.horizontal, 15)
                    
                    Divider()
                        .overlay(Color.white)
                        .padding(.horizontal, 15)
                    
                    // Exclude Ingredients
                    VStack (alignment: .leading) {
                        Text("EXCLUDE INGREDIENTS")
                            .font(.headline)
                        
                        TextField("Enter ingredients to exclude", text: $newExcludeIngredient, onCommit: {
                            excludeIngredients.insert(newExcludeIngredient.trimmingCharacters(in: .whitespaces))
                            newExcludeIngredient = ""
                        })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        
                        // Display entered ingredients for excludeIngredients
                        EnteredIngredientsView(ingredients: excludeIngredients, includeIngredients: $includeIngredients, excludeIngredients: $excludeIngredients)
                    }
                    .padding(.horizontal, 15)
                    
                    Divider()
                        .overlay(Color.white)
                        .padding(.horizontal, 15)
                    
                    // Start of Nutrient filters
                    DisclosureGroup {
                        // Carbs
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Carbs")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Carbs (g)", text: $minCarbs)
                                    .font(minCarbsIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minCarbs) {
                                        minCarbsIsEmpty = $minCarbs.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minCarbs.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Carbs (g)", text: $maxCarbs)
                                    .font(maxCarbsIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxCarbs) {
                                        maxCarbsIsEmpty = $maxCarbs.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxCarbs.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Protein
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Protein")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Protein (g)", text: $minProtein)
                                    .font(minProteinIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minProtein) {
                                        minProteinIsEmpty = $minProtein.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minProtein.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Protein (g)", text: $maxProtein)
                                    .font(maxProteinIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxProtein) {
                                        maxProteinIsEmpty = $maxProtein.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxProtein.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Calories
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Calories")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Calories", text: $minCalories)
                                    .font(minCaloriesIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minCalories) {
                                        minCaloriesIsEmpty = $minCalories.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minCalories.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Calories", text: $maxCalories)
                                    .font(maxCaloriesIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxCalories) {
                                        maxCaloriesIsEmpty = $maxCalories.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxCalories.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Fat
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Fat")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Fat (g)", text: $minFat)
                                    .font(minFatIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minFat) {
                                        minFatIsEmpty = $minFat.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minFat.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Fat (g)", text: $maxFat)
                                    .font(maxFatIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxFat) {
                                        maxFatIsEmpty = $maxFat.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxFat.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Alcohol
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Alcohol")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Alcohol (g)", text: $minAlcohol)
                                    .font(minAlcoholIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minAlcohol) {
                                        minAlcoholIsEmpty = $minAlcohol.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minAlcohol.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Alcohol (g)", text: $maxAlcohol)
                                    .font(maxAlcoholIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxAlcohol) {
                                        maxAlcoholIsEmpty = $maxAlcohol.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxAlcohol.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Caffeine
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Caffeine")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Caffeine (mg)", text: $minCaffeine)
                                    .font(minCaffeineIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minCaffeine) {
                                        minCaffeineIsEmpty = $minCaffeine.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minCaffeine.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Caffeine (mg)", text: $maxCaffeine)
                                    .font(maxCaffeineIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxCaffeine) {
                                        maxCaffeineIsEmpty = $maxCaffeine.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxCaffeine.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Copper
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Copper")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Copper (mg)", text: $minCopper)
                                    .font(minCopperIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minCopper) {
                                        minCopperIsEmpty = $minCopper.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minCopper.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Copper (mg)", text: $maxCopper)
                                    .font(maxCopperIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxCopper) {
                                        maxCopperIsEmpty = $maxCopper.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxCopper.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Calcium
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Calcium")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Calcium (mg)", text: $minCalcium)
                                    .font(minCalciumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minCalcium) {
                                        minCalciumIsEmpty = $minCalcium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minCalcium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Calcium (mg)", text: $maxCalcium)
                                    .font(maxCalciumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxCalcium) {
                                        maxCalciumIsEmpty = $maxCalcium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxCalcium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Choline
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Choline")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Choline (mg)", text: $minCholine)
                                    .font(minCholineIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minCholine) {
                                        minCholineIsEmpty = $minCholine.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minCholine.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Choline (mg)", text: $maxCholine)
                                    .font(maxCholineIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxCholine) {
                                        maxCholineIsEmpty = $maxCholine.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxCholine.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Cholesterol
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Cholesterol")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Cholesterol (mg)", text: $minCholesterol)
                                    .font(minCholesterolIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minCholesterol) {
                                        minCholesterolIsEmpty = $minCholesterol.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minCholesterol.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Cholesterol (mg)", text: $maxCholesterol)
                                    .font(maxCholesterolIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxCholesterol) {
                                        maxCholesterolIsEmpty = $maxCholesterol.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxCholesterol.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Fluoride
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Fluoride")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Fluoride (mg)", text: $minFluoride)
                                    .font(minFluorideIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minFluoride) {
                                        minFluorideIsEmpty = $minFluoride.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minFluoride.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Fluoride (mg)", text: $maxFluoride)
                                    .font(maxFluorideIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxFluoride) {
                                        maxFluorideIsEmpty = $maxFluoride.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxFluoride.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Saturated Fat
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Saturated Fat")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Saturated Fat (mg)", text: $minSaturatedFat)
                                    .font(minSaturatedFatIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minSaturatedFat) {
                                        minSaturatedFatIsEmpty = $minSaturatedFat.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minSaturatedFat.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Saturated Fat (mg)", text: $maxSaturatedFat)
                                    .font(maxSaturatedFatIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxSaturatedFat) {
                                        maxSaturatedFatIsEmpty = $maxSaturatedFat.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxSaturatedFat.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin A
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin A")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin A (IU)", text: $minVitaminA)
                                    .font(minVitaminAIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminA) {
                                        minVitaminAIsEmpty = $minVitaminA.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminA.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin A (IU)", text: $maxVitaminA)
                                    .font(maxVitaminAIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminA) {
                                        maxVitaminAIsEmpty = $maxVitaminA.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminA.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin C
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin C")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin C (mg)", text: $minVitaminC)
                                    .font(minVitaminCIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminC) {
                                        minVitaminCIsEmpty = $minVitaminC.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminC.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin C (mg)", text: $maxVitaminC)
                                    .font(maxVitaminCIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminC) {
                                        maxVitaminCIsEmpty = $maxVitaminC.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminC.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin D
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin D")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin D (mcg)", text: $minVitaminD)
                                    .font(minVitaminDIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminD) {
                                        minVitaminDIsEmpty = $minVitaminD.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminD.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin D (mcg)", text: $maxVitaminD)
                                    .font(maxVitaminDIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminD) {
                                        maxVitaminDIsEmpty = $maxVitaminD.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminD.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin E
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin E")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin E (mg)", text: $minVitaminE)
                                    .font(minVitaminEIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminE) {
                                        minVitaminEIsEmpty = $minVitaminE.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminE.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin E (mg)", text: $maxVitaminE)
                                    .font(maxVitaminEIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminE) {
                                        maxVitaminEIsEmpty = $maxVitaminE.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminE.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin K
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin K")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin K (mcg)", text: $minVitaminK)
                                    .font(minVitaminKIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminK) {
                                        minVitaminKIsEmpty = $minVitaminK.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminK.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin K (mcg)", text: $maxVitaminK)
                                    .font(maxVitaminKIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminK) {
                                        maxVitaminKIsEmpty = $maxVitaminK.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminK.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin B1
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin B1")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin B1 (mg)", text: $minVitaminB1)
                                    .font(minVitaminB1IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminB1) {
                                        minVitaminB1IsEmpty = $minVitaminB1.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminB1.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin B1 (mg)", text: $maxVitaminB1)
                                    .font(maxVitaminB1IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminB1) {
                                        maxVitaminB1IsEmpty = $maxVitaminB1.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminB1.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin B2
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin B2")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin B2 (mg)", text: $minVitaminB2)
                                    .font(minVitaminB2IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminB2) {
                                        minVitaminB2IsEmpty = $minVitaminB2.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminB2.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin B2 (mg)", text: $maxVitaminB2)
                                    .font(maxVitaminB2IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminB2) {
                                        maxVitaminB2IsEmpty = $maxVitaminB2.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminB2.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin B5
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin B5")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin B5 (mg)", text: $minVitaminB5)
                                    .font(minVitaminB5IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminB5) {
                                        minVitaminB5IsEmpty = $minVitaminB5.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminB5.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin B5 (mg)", text: $maxVitaminB5)
                                    .font(maxVitaminB5IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminB5) {
                                        maxVitaminB5IsEmpty = $maxVitaminB5.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminB5.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin B3
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin B3")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin B3 (mg)", text: $minVitaminB3)
                                    .font(minVitaminB3IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminB3) {
                                        minVitaminB3IsEmpty = $minVitaminB3.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminB3.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin B3 (mg)", text: $maxVitaminB3)
                                    .font(maxVitaminB3IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminB3) {
                                        maxVitaminB3IsEmpty = $maxVitaminB3.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminB3.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin B6
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin B6")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin B6 (mg)", text: $minVitaminB6)
                                    .font(minVitaminB6IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminB6) {
                                        minVitaminB6IsEmpty = $minVitaminB6.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminB6.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin B6 (mg)", text: $maxVitaminB6)
                                    .font(maxVitaminB6IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminB6) {
                                        maxVitaminB6IsEmpty = $maxVitaminB6.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminB6.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Vitamin B12
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Vitamin B12")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Vitamin B12 (mg)", text: $minVitaminB12)
                                    .font(minVitaminB12IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minVitaminB12) {
                                        minVitaminB12IsEmpty = $minVitaminB12.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minVitaminB12.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Vitamin B12 (mg)", text: $maxVitaminB12)
                                    .font(maxVitaminB12IsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxVitaminB12) {
                                        maxVitaminB12IsEmpty = $maxVitaminB12.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxVitaminB12.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Fiber
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Fiber")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Fiber (g)", text: $minFiber)
                                    .font(minFiberIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minFiber) {
                                        minFiberIsEmpty = $minFiber.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minFiber.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Fiber (g)", text: $maxFiber)
                                    .font(maxFiberIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxFiber) {
                                        maxFiberIsEmpty = $maxFiber.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxFiber.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Folate
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Folate")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Folate (mcg)", text: $minFolate)
                                    .font(minFolateIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minFolate) {
                                        minFolateIsEmpty = $minFolate.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minFolate.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Folate (mcg)", text: $maxFolate)
                                    .font(maxFolateIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxFolate) {
                                        maxFolateIsEmpty = $maxFolate.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxFolate.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Folic Acid
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Folic Acid")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Folic Acid (mg)", text: $minFolicAcid)
                                    .font(minFolicAcidIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minFolicAcid) {
                                        minFolicAcidIsEmpty = $minFolicAcid.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minFolicAcid.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Folic Acid (mg)", text: $maxFolicAcid)
                                    .font(maxFolicAcidIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxFolicAcid) {
                                        maxFolicAcidIsEmpty = $maxFolicAcid.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxFolicAcid.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Iodine
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Iodine")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Iodine (mcg)", text: $minIodine)
                                    .font(minIodineIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minIodine) {
                                        minIodineIsEmpty = $minIodine.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minIodine.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Iodine (mcg)", text: $maxIodine)
                                    .font(maxIodineIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxIodine) {
                                        maxIodineIsEmpty = $maxIodine.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxIodine.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Iron
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Iron")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Iron (mg)", text: $minIron)
                                    .font(minIronIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minIron) {
                                        minIronIsEmpty = $minIron.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minIron.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Iron (mg)", text: $maxIron)
                                    .font(maxIronIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxIron) {
                                        maxIronIsEmpty = $maxIron.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxIron.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Magnesium
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Magnesium")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Magnesium (mg)", text: $minMagnesium)
                                    .font(minMagnesiumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minMagnesium) {
                                        minMagnesiumIsEmpty = $minMagnesium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minMagnesium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Magnesium (mg)", text: $maxMagnesium)
                                    .font(maxMagnesiumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxMagnesium) {
                                        maxMagnesiumIsEmpty = $maxMagnesium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxMagnesium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Manganese
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Manganese")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Manganese (mg)", text: $minManganese)
                                    .font(minManganeseIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minManganese) {
                                        minManganeseIsEmpty = $minManganese.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minManganese.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Manganese (mg)", text: $maxManganese)
                                    .font(maxManganeseIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxManganese) {
                                        maxManganeseIsEmpty = $maxManganese.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxManganese.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Phosphorus
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Phosphorus")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Phosphorus (mg)", text: $minPhosphorus)
                                    .font(minPhosphorusIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minPhosphorus) {
                                        minPhosphorusIsEmpty = $minPhosphorus.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minPhosphorus.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Phosphorus (mg)", text: $maxPhosphorus)
                                    .font(maxPhosphorusIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxPhosphorus) {
                                        maxPhosphorusIsEmpty = $maxPhosphorus.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxPhosphorus.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Potassium
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Potassium")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Potassium (mg)", text: $minPotassium)
                                    .font(minPotassiumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minPotassium) {
                                        minPotassiumIsEmpty = $minPotassium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minPotassium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Potassium (mg)", text: $maxPotassium)
                                    .font(maxPotassiumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxPotassium) {
                                        maxPotassiumIsEmpty = $maxPotassium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxPotassium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Selenium
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Selenium")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Selenium (mcg)", text: $minSelenium)
                                    .font(minSeleniumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minSelenium) {
                                        minSeleniumIsEmpty = $minSelenium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minSelenium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Selenium (mcg)", text: $maxSelenium)
                                    .font(maxSeleniumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxSelenium) {
                                        maxSeleniumIsEmpty = $maxSelenium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxSelenium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Sodium
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Sodium")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Sodium (mg)", text: $minSodium)
                                    .font(minSodiumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minSodium) {
                                        minSodiumIsEmpty = $minSodium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minSodium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Sodium (mg)", text: $maxSodium)
                                    .font(maxSodiumIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxSodium) {
                                        maxSodiumIsEmpty = $maxSodium.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxSodium.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Sugar
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Sugar")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Sugar (g)", text: $minSugar)
                                    .font(minSugarIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minSugar) {
                                        minSugarIsEmpty = $minSugar.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minSugar.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Sugar (g)", text: $maxSugar)
                                    .font(maxSugarIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxSugar) {
                                        maxSugarIsEmpty = $maxSugar.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxSugar.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }

                        // Zinc
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Zinc")
                                .offset(x: 10)
                            
                            HStack {
                                TextField("Min Zinc (mg)", text: $minZinc)
                                    .font(minZincIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: minZinc) {
                                        minZincIsEmpty = $minZinc.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(minZinc.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                                
                                Text("to")
                                
                                TextField("Max Zinc (mg)", text: $maxZinc)
                                    .font(maxZincIsEmpty ? .system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8) : .body)
                                    .onChange(of: maxZinc) {
                                        maxZincIsEmpty = $maxZinc.wrappedValue.isEmpty
                                    }
                                    .padding()
                                    .background(maxZinc.isEmpty ? Color.white : Color.yellow)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 15)
                        }
                    } label: {
                        HStack {
                            Text("NUTRIENTS")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    Spacer()
                }
                .background(Color(UIColor.lightGray))
                .padding(.bottom, 300)
                .transition(.move(edge: .bottom))
                .offset(y: isFilterSidebarVisible ? UIScreen.main.bounds.height * 0.1 : 0)
                .edgesIgnoringSafeArea(.all)
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
                            .font(.headline)
                            .foregroundColor(Color.blue)
                            .frame(width: 150)
                            .cornerRadius(5)
                    }
                    .offset(x: -20)

                    // Apply Filter Button
                    Button(action: {
                        applyFilters()
                    }) {
                        Text("Apply")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .frame(width: 200)
                            .cornerRadius(5)
                    }
                    .background(Color.blue)
                    .cornerRadius(5)
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
        minCholesterol = ""
        maxCholesterol = ""
        minFluoride = ""
        maxFluoride = ""
        minSaturatedFat = ""
        maxSaturatedFat = ""
        minVitaminA = ""
        maxVitaminA = ""
        minVitaminC = ""
        maxVitaminC = ""
        minVitaminD = ""
        maxVitaminD = ""
        minVitaminE = ""
        maxVitaminE = ""
        minVitaminK = ""
        maxVitaminK = ""
        minVitaminB1 = ""
        maxVitaminB1 = ""
        minVitaminB2 = ""
        maxVitaminB2 = ""
        minVitaminB5 = ""
        maxVitaminB5 = ""
        minVitaminB3 = ""
        maxVitaminB3 = ""
        minVitaminB6 = ""
        maxVitaminB6 = ""
        minVitaminB12 = ""
        maxVitaminB12 = ""
        minFiber = ""
        maxFiber = ""
        minFolate = ""
        maxFolate = ""
        minFolicAcid = ""
        maxFolicAcid = ""
        minIodine = ""
        maxIodine = ""
        minIron = ""
        maxIron = ""
        minMagnesium = ""
        maxMagnesium = ""
        minManganese = ""
        maxManganese = ""
        minPhosphorus = ""
        maxPhosphorus = ""
        minPotassium = ""
        maxPotassium = ""
        minSelenium = ""
        maxSelenium = ""
        minSodium = ""
        maxSodium = ""
        minSugar = ""
        maxSugar = ""
        minZinc = ""
        maxZinc = ""
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
                        Text("\(ingredient)")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 5)
                        Spacer()
                        
                        Button(action: {
                            // Remove the ingredient from the appropriate list
                            if includeIngredients.contains(ingredient) {
                                includeIngredients.remove(ingredient)
                            } else if excludeIngredients.contains(ingredient) {
                                excludeIngredients.remove(ingredient)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                    .background(Color.yellow)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                }
            }
        }
    }

    // ColoredToggleStyle
    struct ColoredToggleStyle: ToggleStyle {
        let intolerance: Intolerances
        let selectedIntolerances: Set<Intolerances>
        
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }) {
                HStack {
                    Text(intolerance.rawValue.capitalized)
                        .foregroundColor(selectedIntolerances.contains(intolerance) ? .yellow : .black) // Change color to yellow when selected
                    Spacer()
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .foregroundColor(configuration.isOn ? .yellow : .black) // Change color to yellow when selected
                }
            }
            .padding()
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
