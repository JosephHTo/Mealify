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
                        .frame(width: sidebarWidth + 115)
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

                    HStack {
                        Text("Set desired Kroger location")
                            .font(.headline)
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
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
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
                        .offset(x: -27)
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
