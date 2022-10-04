//
//  RecipeImageView.swift
//  FireRecipe
//
//  Created by Charlotte Liang on 9/30/22.
//

import SwiftUI
import FirebaseStorage

class ImageCache : ObservableObject {
    var cache = NSCache<NSString, NSData>()
    
    func get(forKey: String) -> NSData? {
        return cache.object(forKey: NSString(string: forKey))
    }
    func set(forKey: String, data: NSData) {
        cache.setObject(data, forKey: NSString(string: forKey))
    }
}

struct RecipeImageView: View {
  var name: String
  @EnvironmentObject var images : ImageCache
  @State var image: UIImage?
  
  var body: some View {
    if image != nil {
      Image(uiImage: image!).resizable()
    } else {
      ProgressView().onAppear {
        DownloadImage()
      }
    }
  }
  
  func DownloadImage() {
    if let imageData = self.images.get(forKey: self.name) {
      self.image = UIImage(data:imageData as Data)
      return
    }
    let ref = Storage.storage().reference(withPath: "\(self.name).jpg")
    ref.getData(maxSize: 2*1024*1024) { data, error in
      if let error = error {
        print(error)
      } else {
        self.images.set(forKey:self.name, data: data! as NSData)
        self.image = UIImage(data:data!)
      }
    }
  }
  
  init(name: String) {
    self.name = name
  }
}

struct RecipeImageView_Previews: PreviewProvider {
    static var previews: some View {
      RecipeImageView(name: "test")
    }
}
