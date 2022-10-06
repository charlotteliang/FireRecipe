//
// IngredientDetail.swift
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
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift
import FirebaseFirestore
import FirebaseFirestoreSwift


struct IngredientDetail: View {
  
  var recipeName : String
  @State var ingredients : [String:Bool]
  
  @RemoteConfigProperty(key: "isCheckBoxSquare", fallback: false) var isCheckBoxSquare: Bool

  var body: some View {
    Text("Ingredients").font(.title)
    List{
      ForEach(Array(ingredients.keys), id: \.self) { key in
        HStack{
          Button(action: {
            toggle(ingredientName: key)
          }) {
            let value : Bool = ingredients[key] ?? false
            if isCheckBoxSquare {
              Image(systemName: value ? "checkmark.square.fill" : "square")
            } else {
              Image(systemName: value ? "checkmark.circle.fill" : "circle")
            }
          }
          Text(key)
        }
      }
    }
    
    Button(action: fetchAndActivate) {
      HStack {
        Image(systemName: "sunrise")
        Text("Activate (Testing)")
      }
    }
  }
  
  func toggle(ingredientName: String) {
    let db = Firestore.firestore()
  
    ingredients[ingredientName]?.toggle()
    db.collection("Recipes").document(recipeName).updateData(["ingredients":ingredients])
  }
  
  func fetchAndActivate() {
    RemoteConfig.remoteConfig().fetchAndActivate()
  }
}

struct IngredientDetail_Previews: PreviewProvider {
    static var previews: some View {
      IngredientDetail(recipeName:"test", ingredients:["tomatoe":true, "banana": false])
    }
}
