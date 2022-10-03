//
//  RecipeImageView.swift
//  FireRecipe
//
//  Created by Charlotte Liang on 9/30/22.
//

import SwiftUI

struct RecipeImageView: View {
  var name: String
  var body: some View {
    AsyncImage(url: URL(string:name)) { phase in
      phase.resizable()
    } placeholder: {
      ProgressView()
    }
  }
}

struct RecipeImageView_Previews: PreviewProvider {
    static var previews: some View {
      RecipeImageView(name: "test")
    }
}
