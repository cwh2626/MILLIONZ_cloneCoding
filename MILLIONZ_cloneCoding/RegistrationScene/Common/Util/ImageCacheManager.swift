//
//  ImageCacheManager.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/08.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}

    private var cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
}
