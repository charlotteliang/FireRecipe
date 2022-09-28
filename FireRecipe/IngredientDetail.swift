//
//  IngredientDetail.swift
//  FireRecipe
//
//  Created by Charlotte Liang on 9/28/22.
//

import SwiftUI
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

struct IngredientDetail: View {
  
  var ingredients : [String]
  @State var isChecked = false
  @RemoteConfigProperty(key: "isCheckBoxSquare", fallback: false) var isCheckBoxSquare: Bool

    var body: some View {
      Text("Ingredients").font(.title)
      List(ingredients, id: \.self) { ingredient in
        HStack{
          Button(action: toggle) {
            if isCheckBoxSquare {
              Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            } else {
              Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
            }
          }
          Text(ingredient)
        }
      }
      Button(action: fetchAndActivate) {
        Text("fetchAndActivate")
      }
    }
  func toggle() {
    isChecked.toggle()
  }
  
  func fetchAndActivate() {
    RemoteConfig.remoteConfig().fetchAndActivate()
  }
}

struct IngredientDetail_Previews: PreviewProvider {
    static var previews: some View {
        IngredientDetail(ingredients: [])
    }
}
