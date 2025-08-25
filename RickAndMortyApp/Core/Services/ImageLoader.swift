//
//  ImageLoader.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()

    public func setImage(url: URL?, into imageView: UIImageView) {
        imageView.image = nil
        guard let url else { return }
        if let cached = cache.object(forKey: url as NSURL) {
            imageView.image = cached; return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, _, _ in
            guard let data, let img = UIImage(data: data) else { return }
            
            self?.cache.setObject(img, forKey: url as NSURL)
            DispatchQueue.main.async {
                imageView?.image = img
            }
        }
        task.resume()
    }
}
