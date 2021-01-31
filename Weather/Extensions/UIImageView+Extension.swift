//
//  UIImageView+Extension.swift
//  Weather
//
//  Created by IVAN CHERNOV on 30.01.21.
//

import UIKit

// All credits goes to Paul Hudson
// https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview

typealias ImageLoadAction = (UIImage?) -> Void

extension UIImageView {
    func load(url: URL, completion: ImageLoadAction? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completion?(image)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
