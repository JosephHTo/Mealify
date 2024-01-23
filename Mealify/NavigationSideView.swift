import SwiftUI

struct NavigationSideView: View {
    @Binding var isSidebarVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "house.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .padding(.trailing, 10)

                Text("Featured")
                    .foregroundColor(Color.white)
                    .font(.body)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .onTapGesture {
                // Handle item tap
                print("Tapped on Featured")
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }

            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .padding(.trailing, 10)

                Text("Search")
                    .foregroundColor(Color.white)
                    .font(.body)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .onTapGesture {
                // Handle item tap
                print("Tapped on Search")
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }

            HStack {
                Image(systemName: "square.and.arrow.down.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .padding(.trailing, 10)

                Text("Saved Recipes")
                    .foregroundColor(Color.white)
                    .font(.body)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .onTapGesture {
                // Handle item tap
                print("Saved Recipes")
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }
            
            HStack {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .padding(.trailing, 10)

                Text("Settings")
                    .foregroundColor(Color.white)
                    .font(.body)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .onTapGesture {
                // Handle item tap
                print("Settings")
                withAnimation {
                    isSidebarVisible.toggle()
                }
            }

            Spacer() // Add Spacer to bring HStacks to the top
        }
        .frame(maxHeight: .infinity)
        .frame(width: UIScreen.main.bounds.width * 0.6)
        .background(Color.gray)
        .transition(.move(edge: .leading))
        .onTapGesture {
            withAnimation {
                isSidebarVisible.toggle()
            }
        }
    }
}
