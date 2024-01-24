import SwiftUI

struct SavedRecipesView: View {
    @State private var isNavBarOpened = false
    @State private var sidebarWidth: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                withAnimation {
                    NavigationSideView(isSidebarVisible: $isNavBarOpened)
                        .frame(width: sidebarWidth + 25)
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
                    Text("Saved Recipes")
                        .font(.title)
                        .padding()

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
