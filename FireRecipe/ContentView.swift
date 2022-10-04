
import FirebaseAnalyticsSwift
import FirebaseAnalytics
import FirebaseFirestoreSwift
import SwiftUI

struct Recipe: Identifiable, Hashable, Decodable, Encodable {
  @DocumentID var id: String?
  var name: String
  var time: Int
  var steps: [String]
  var ingredients: [String: Bool]
  var type: String
  var image: String
  
  init(id: String? = nil, name: String = "test", time: Int = 0, steps: [String] = [], ingredients: [String : Bool] = [:], type: String="test", image: String = "test") {
    self.id = id
    self.name = name
    self.time = time
    self.steps = steps
    self.ingredients = ingredients
    self.type = type
    self.image = image
  }
}

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
                      RecipeImageView(name: recipe.name).frame(width: 180, height: 160)
                      Text(recipe.name)
                    }
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
