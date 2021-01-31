//
//  ImageCache.swift
//  Weather
//
//  Created by IVAN CHERNOV on 31.01.21.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private var cache: NSCache = NSCache<NSString, UIImage>()
    
    subscript(key: String) -> UIImage? {
        get {
            cache.object(forKey: key as NSString)
        }
        set(image) {
            image == nil ? self.cache.removeObject(forKey: (key as NSString)) : self.cache.setObject(image!, forKey: (key as NSString))
        }
    }
}
