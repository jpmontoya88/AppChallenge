//
//  URLImageModel.swift
//  challenge
//
//  Created by JP Montoya on 20.12.22.
//

import Foundation
import SwiftUI

class URLImageModel: ObservableObject{
    
    @Published var image: UIImage?
    var urlString: String?
    var imageCache = ImageCache.getImageCache()
    
    init(urlString: String?){
        
        self.urlString = urlString
        loadImage()
        
    }
    
    func loadImage(){
        
        if loadImageFromCache() {
            //print("image from cache")
            return
        }
        
        //print("requesting image from URL")
        loadImageFromURL()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else{
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func loadImageFromURL(){
        
        guard let urlString = urlString else{
            return
        }
        
        let url = URL(string: Constants.Api.imagebaseurl + urlString)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        
        task.resume()
        
    }
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?){
        
        guard error == nil else{
            print("Error: \(error!.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No Image data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else{
                return
            }
            
            self.image = loadedImage
        }
        
        
    }
}

class ImageCache{
    
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
