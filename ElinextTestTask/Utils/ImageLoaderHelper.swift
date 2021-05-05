//
//  ImageLoaderHelper.swift
//  ElinextTestTask
//
//  Created by MacBook on 3.05.21.
//

import Foundation
import UIKit

class ImageLoaderHelper {
    static func loadImage(with url: String, into imageView: UIImageView, cacheName: String, completion: @escaping () -> Void) {
        if URL.isFileExist(withName: cacheName) {
            let imageUrl = URL.constructFilePath(withName: cacheName)
            imageView.image = UIImage(contentsOfFile: imageUrl.path)
            completion()
        } else {
            guard let url = URL(string: url) else { return }
            imageView.load(url: url) {
                completion()
                saveToCache(image: $0, name: cacheName)
            }
        }
    }
    
    static func clearCache() {
        let fileManager = FileManager.default
        do {
            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for url in fileURLs {
               try fileManager.removeItem(at: url)
            }
        } catch {
            print(error)
        }
    }
    
    static func saveToCache(image: UIImage, name: String) {
        guard let directoryPath = try? FileManager.default.url(for: .documentDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil, create: true) else { return }
        let urlString = directoryPath.appendingPathComponent(name)
        try? image.jpegData(compressionQuality: 1)?.write(to: urlString)
    }
}
