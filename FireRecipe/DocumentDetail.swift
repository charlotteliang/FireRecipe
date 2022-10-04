//
//  DocumentDetail.swift
//  FireRecipe
//
//  Created by Charlotte Liang on 9/28/22.
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
      DocumentDetail(recipe:Recipe(id: "test"))
    }
}

