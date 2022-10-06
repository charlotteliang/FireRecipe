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
  var time: Int
  var steps: [String]
  var ingredients: [String: Bool]
  var type: String
  var image: String
}

extension Recipe: Codable, Identifiable, Equatable {
}

// so we can use Array.difference
extension Recipe: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Recipe {
  static let samples = [
    Recipe(name: "Daal", time: 20,
           steps: ["Crush garlic"],
           ingredients: ["Garlic": true,
                         "Olive oil": true,
                         "Lentils": true,
                         "Coconut milk": true],
           type: "vegan",
           image: "Daal")
  ]
}
