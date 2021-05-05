//
//  UIImageViewExtensions.swift
//  ElinextTestTask
//
//  Created by MacBook on 2.05.21.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion(image)
                    }
                }
        }
    }
}
