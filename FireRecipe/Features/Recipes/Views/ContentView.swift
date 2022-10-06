
import FirebaseAnalyticsSwift
import FirebaseAnalytics
import FirebaseFirestoreSwift
import SwiftUI

struct ContentView: View {
  
  @FirestoreQuery(collectionPath: "Recipes") var recipes: [Recipe]
  private var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
  @State private var cachedImages : ImageCache = ImageCache()
    
  var body: some View {
    VStack {
      NavigationStack {
        ScrollView(.vertical, showsIndicators: false) {
          LazyVGrid(columns: twoColumnGrid, spacing: 10) {
              ForEach(recipes, id: \.self) { recipe in
              VStack {
                NavigationLink(
                  destination: DocumentDetail(recipe:recipe).analyticsScreen(name: recipe.type),
                  label: {
                    VStack {
                      RecipeImageView(name: recipe.name)
                      Text(recipe.name)
                    }.frame(width: 180, height: 200)
                  }
                ).buttonStyle(PlainButtonStyle())
              }
            }
            .padding(.horizontal)
          }.navigationTitle("FireRecipe 😋")
        }
      }.environmentObject(cachedImages)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
