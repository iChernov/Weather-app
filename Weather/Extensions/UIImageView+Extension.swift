//
//  UIImageView+Extension.swift
//  Weather
//
//  Created by IVAN CHERNOV on 30.01.21.
//

import UIKit

// All credits goes to Paul Hudson
// https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
