import SwiftUI

struct SettingsView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0
    @State private var zipCode: String = ""
    @State private var locations: [Location] = []
    @State private var selectedLocationIndex: Int?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                withAnimation {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .frame(width: sidebarWidth)
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
                    Text("Settings")
                        .font(.title)
                        .padding()

                    TextField("Enter Zip Code", text: $zipCode)
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
                        Text("Save")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    if let selectedIndex = selectedLocationIndex {
                        // Display selected location details
                        VStack(alignment: .leading) {
                            Text("Selected Location:")
                                .font(.headline)
                            Text(locations[selectedIndex].name)
                                .font(.title)
                            Text(locations[selectedIndex].address.addressLine1)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    } else if !locations.isEmpty {
                        // Display list of locations
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
                                    selectedLocationIndex = index
                                }
                            }
                        }
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
    }
}
