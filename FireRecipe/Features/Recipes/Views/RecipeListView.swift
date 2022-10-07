//
// RecipeListView.swift
// FireRecipe
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import FirebaseAnalyticsSwift
import FirebaseAnalytics
import FirebaseFirestoreSwift
import SwiftUI
import NukeUI

struct RecipeListView: View {
  @FirestoreQuery(collectionPath: "recipes") var recipes: [Recipe]
  @EnvironmentObject var router: NavigationRouter

  var body: some View {
    ScrollView {
      let cols = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 8)]
      LazyVGrid(columns: cols) {
        ForEach(recipes) { recipe in
          NavigationLink(value: recipe) {
            VStack(alignment: .leading) {
              LazyImage(url: recipe.imageURL, resizingMode: .aspectFill)
                .frame(height: 200)
                .cornerRadius(8)
                .padding([.top, .leading, .trailing], 7)
              Text(recipe.name)
                .font(.headline)
                .padding(.horizontal, 7)
              Spacer()
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
      .navigationDestination(for: Recipe.self) { recipe in
        RecipeDetailsView(recipe: recipe)
          .environmentObject(router)
          .analyticsScreen(name: "Recipe Details", extraParameters: ["recipe_type": recipe.type])
      }
      .padding([.horizontal], 8)
    }
    .navigationTitle("Recipes")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      RecipeListView()
    }
  }
}
