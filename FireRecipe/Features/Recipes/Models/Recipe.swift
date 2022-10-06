//
// Recipe.swift
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

import Foundation
import FirebaseFirestoreSwift

struct Recipe {
  @DocumentID var id: String?
  var name: String
  var description: String?
  var time: Int
  var steps: [String]
  var ingredients: [Ingredient]
  var type: String
  var image: String
}

struct Ingredient {
  var name: String
  var quantity: Double
  var unit: String
}

extension Recipe: Codable, Identifiable, Equatable {
}

extension Recipe {
  var imageURL: URL {
    URL(string: image)!
  }
}

// so we can use Array.difference
extension Recipe: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Ingredient: Codable, Equatable {
}

extension Ingredient: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}


extension Recipe {
  static let samples = [
    Recipe(name: "Avocado Toast",
           description: "Avocado toast is is a delicious and simple breakfast, snack or light meal!",
           time: 10,
           steps: [
            "Smash your avocado!",
            "Top the toast with the avocado spread and fried egg.",
            "Add salt and chilly pepper flakes and there you go!"
           ],
           ingredients: [
            Ingredient(name: "Avocado", quantity: 0.5, unit: "pcs"),
            Ingredient(name: "Poached egg", quantity: 1, unit: "pcs"),
            Ingredient(name: "Whole wheat bread", quantity: 1, unit: "slice")
           ],
           type: "vegan",
           image: "avocado_toast")
  ]
}
