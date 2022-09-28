//
//  DocumentDetail.swift
//  FireRecipe
//
//  Created by Charlotte Liang on 9/28/22.
//

import SwiftUI

struct DocumentDetail: View {

  var recipe : Recipe
   
  var body: some View {
      VStack {
        Text(recipe.name).font(.title)
        Text(recipe.type).font(.footnote)
        Text("Cook time: \(recipe.time) minutes.")
        
        NavigationLink("Ingredients") {
          IngredientDetail(ingredients:recipe.ingredients)
        }
        Spacer()
        Text("Steps").font(.title2)
        
        List(recipe.steps, id: \.self) { step in
          HStack {
            Image(systemName: "carrot")
            Text(step)
          }
        }
      }
    }
  

}

struct DocumentDetail_Previews: PreviewProvider {
    static var previews: some View {
      DocumentDetail(recipe:Recipe(id: "test", name: "test", time: 0, steps: [], ingredients: [], type: "test"))
    }
}

