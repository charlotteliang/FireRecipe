//
//  RecipeDetailsView2.swift
//  FireRecipe
//
//  Created by Peter Friese on 06.10.22.
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

import SwiftUI
import FirebaseRemoteConfigSwift

struct RecipeDetailsView2: View {
  var recipe: Recipe
  @Environment(\.dismiss) var dismiss
  @State var presentSheet = true
  var body: some View {
    VStack {
      Image("avocado_toast")
        .resizable()
        .scaledToFit()
      Text("You just found an easter egg ;-)")
      Spacer()
    }
    .ignoresSafeArea()
    .sheet(isPresented: $presentSheet) {
      RecipeView(recipe: recipe) {
        presentSheet = false
        dismiss()
      }
        .interactiveDismissDisabled()
        .presentationDetents([.fraction(0.75)])
    }
  }
}

enum RecipeSection : String, CaseIterable {
    case ingredients = "Ingredients"
    case instructions = "Instructions"
}

struct RecipeView: View {
  var recipe: Recipe
  var callback: (() -> ())?
  @State private var sectionSelection = RecipeSection.ingredients


  var body: some View {
    VStack {
      Button("BACK") {
        callback?()
      }
      RecipeTitleView(recipe: recipe)
        .padding(20)
      Picker("", selection: $sectionSelection) {
        ForEach(RecipeSection.allCases, id: \.self) { option in
          Text(option.rawValue)
        }
      }
      .pickerStyle(.segmented)
      .padding(.horizontal, 20)
      switch sectionSelection {
      case .ingredients:
        IngredientsView(recipe: recipe)
      case .instructions:
        InstructionsView(recipe: recipe)
      }
    }
  }
}

struct IngredientsView: View {
  var recipe: Recipe
  var body: some View {
    List {
      Section {
        ForEach(recipe.ingredients, id: \.self) { ingredient in
          Text(["\(ingredient.quantity)", ingredient.unit, ingredient.name].joined(separator: " "))
        }
      } header: {
        HStack {
          Text("Ingredients")
            .font(.title3)
          Spacer()
          Text("\(recipe.ingredients.count) items")
        }
      }
    }
    .listRowSeparator(.hidden)
    .listStyle(.plain)
  }
}

struct InstructionsView: View {
  @RemoteConfigProperty(key: "imageName", fallback: "carrot") var imageName: String
  var recipe: Recipe
  var body: some View {
    List {
      Section {
        ForEach(recipe.steps, id: \.self) { step in
          Label(step, systemImage: imageName)
        }
      } header: {
        HStack {
          Text("Instructions")
            .font(.title3)
          Spacer()
          Text("\(recipe.steps.count) steps")
        }
      }
    }
    .listRowSeparator(.hidden)
    .listStyle(.plain)
  }
}


struct RecipeTitleView: View {
  var recipe: Recipe
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(recipe.name)
          .font(.title)
          .bold()
        Spacer()
        Label("\(recipe.time) Min", systemImage: "clock")
      }
      if let description = recipe.description {
        Text(description)
      }
    }
  }
}

struct RecipeDetailsView2_Previews: PreviewProvider {
  static var previews: some View {
    RecipeDetailsView2(recipe: Recipe.samples[0])
    RecipeView(recipe: Recipe.samples[0])
  }
}
