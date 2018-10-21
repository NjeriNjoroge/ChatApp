//
//  Extensions.swift
//  ChatApp
//
//  Created by Grace Njoroge on 21/10/2018.
//  Copyright © 2018 Grace Njoroge. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for images first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise download afresh
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, reponse, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = UIImage(data: data!)
                }
            }
        }).resume()
    }
}
