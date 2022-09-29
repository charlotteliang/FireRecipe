//
//  IngredientDetail.swift
//  FireRecipe
//
//  Created by Charlotte Liang on 9/28/22.
//

import SwiftUI
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift
import FirebaseFirestore
import FirebaseFirestoreSwift


struct IngredientDetail: View {
  
  var recipeName : String
  @RemoteConfigProperty(key: "isCheckBoxSquare", fallback: false) var isCheckBoxSquare: Bool
  
  @State var ingredients : [String:Bool]

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
        Text("fetchAndActivate")
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
      IngredientDetail(recipeName:"test", ingredients:[:])
    }
}
