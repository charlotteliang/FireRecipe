
import FirebaseAnalyticsSwift
import FirebaseAnalytics
import FirebaseFirestoreSwift
import SwiftUI

struct Recipe: Codable, Hashable {
  @DocumentID var id: String?
  var name: String
  var time: Int
  var steps: [String]
  var ingredients: [String]
  var type: String
}

struct ContentView: View {
  
  @FirestoreQuery(collectionPath: "Recipes") var recipes: [Recipe]
  
  var body: some View {
    VStack {
      NavigationStack {
        List(recipes, id: \.self) { recipe in
          HStack {
            Image(systemName:"fork.knife")
            
            NavigationLink(recipe.name, value: recipe)
          }
        }
        .navigationDestination(for: Recipe.self) { recipe in
          DocumentDetail(recipe:recipe).analyticsScreen(name: recipe.type)
        }
        .navigationTitle("Vegan")
      }
    }
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
