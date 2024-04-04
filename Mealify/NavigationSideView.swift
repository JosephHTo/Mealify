import SwiftUI
import UIKit

struct NavigationSideView: View {
    @Binding var isSidebarVisible: Bool
    @EnvironmentObject var userData: UserData

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationLink(destination: RecipesView().navigationBarBackButtonHidden(true)) {
                HStack {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 10)

                    Text("Recipes")
                        .foregroundColor(Color.white)
                        .font(.body)

                    Spacer()
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 8)
            }

            // NavigationLink for SearchView
            NavigationLink(destination: SearchView().navigationBarBackButtonHidden(true)) {
                HStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 10)

                    Text("Recipe Search")
                        .foregroundColor(Color.white)
                        .font(.body)

                    Spacer()
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 8)
            }
            
            // NavigationLink for ProductSearchView
            NavigationLink(destination: ProductSearchView().navigationBarBackButtonHidden(true)) {
                HStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 10)

                    Text("Product Search")
                        .foregroundColor(Color.white)
                        .font(.body)

                    Spacer()
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 8)
            }

            // NavigationLink for SettingsView
            NavigationLink(destination: SettingsView().navigationBarBackButtonHidden(true)) {
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
