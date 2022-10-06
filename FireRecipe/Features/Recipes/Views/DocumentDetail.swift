//
// DocumentDetail.swift
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

import SwiftUI
import FirebaseRemoteConfigSwift

struct DocumentDetail: View {
  @Environment(\.defaultMinListRowHeight) var minRowHeight
  var recipe : Recipe
  @EnvironmentObject var cachedImages : ImageCache
  
  @RemoteConfigProperty(key: "imageName", fallback: "carrot") var imageName: String

  var body: some View {
    ScrollView {
      VStack {
        RecipeImageView(name: recipe.name).aspectRatio(contentMode: .fill)
        Text(recipe.name).font(.title)
        Text(recipe.type).font(.footnote)
        Text("Cook time: \(recipe.time) minutes.")
        
        HStack {
          Image(systemName: "checklist")
          NavigationLink("Ingredients") {
            IngredientDetail(recipeName:recipe.name, ingredients: recipe.ingredients)
          }
        }
        Spacer()
        Text("Steps").font(.title2)
        
        List(recipe.steps, id: \.self) { step in
          HStack {
            Image(systemName: imageName)
            Text(step)
          }
        }.frame(minHeight: minRowHeight * CGFloat(recipe.steps.count+1))
      }
    }.environmentObject(cachedImages)
  }
}

struct DocumentDetail_Previews: PreviewProvider {
    static var previews: some View {
      DocumentDetail(recipe: Recipe.samples[0])
    }
}

