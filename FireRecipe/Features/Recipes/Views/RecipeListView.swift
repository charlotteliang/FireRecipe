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

struct RecipeListView: View {
  
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
    RecipeListView()
  }
}
