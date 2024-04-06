import SwiftUI

struct SettingsView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 250
    @State private var zipCode: String = ""
    @State private var locations: [Location] = []
    @State private var selectedLocationIndex: Int?
    @State private var selectedLocation: Location?
    @State private var isExplanationPresented = false
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                VStack(spacing: 20) {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: 0.5)
                    
                    HStack {
                        Text("Set desired Kroger location")
                            .font(.headline)
                        Button(action: {
                            // Toggle the explanation popup
                            isExplanationPresented.toggle()
                        }) {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.blue)
                        }
                        .popover(isPresented: $isExplanationPresented) {
                            VStack {
                                Text("Desired Kroger Location")
                                    .font(.headline)
                                
                                Divider()
                                    .frame(width: UIScreen.main.bounds.width * 0.75)
                                
                                Text("This action allows you to set your preferred Kroger location. The product search obtains products from the corresponding selected location. In order to use this feature, a location needs to be selected. Product availibility and pricing may differ based on location.")
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                
                                Button("Close") {
                                    isExplanationPresented.toggle()
                                }
                            }
                            .padding()
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    
                    HStack {
                        TextField("5-digit Zip Code", text: $zipCode)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            // Call the function to fetch location data
                            getLocations(zipCode: zipCode) { result in
                                switch result {
                                case .success(let fetchedLocations):
                                    locations = fetchedLocations
                                case .failure(let error):
                                    print("Error fetching locations: \(error)")
                                }
                            }
                        }) {
                            Text("Search")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(5)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                    
                    // Display selected location if exists
                    if let selectedLocation = userData.selectedLocation {
                        VStack(alignment: .leading) {
                            Text("Selected Location:")
                                .font(.headline)
                            Text(selectedLocation.name)
                                .font(.title)
                            Text(selectedLocation.address.addressLine1)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading)
                        .offset(x: -27)
                    } else {
                        // Display "No locations found" if no selected location
                        if locations.isEmpty {
                            Text("No locations found")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    
                    // Display list of search results
                    List {
                        ForEach(locations.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text(locations[index].name)
                                    .font(.headline)
                                Text(locations[index].address.addressLine1)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .onTapGesture {
                                // Update selected location when a location is tapped
                                selectedLocation = locations[index]
                                userData.selectedLocation = selectedLocation
                            }
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
                    }
                }
            }
        }
    }
}
