//
//  Image+Extension.swift
//  Weather
//
//  Created by Anh Tran on 20/09/2021.
//

import UIKit
extension UIImage {
    func resize(_ newWidth: CGFloat) -> UIImage? {
        if size.width < newWidth {
            return self
        }
        
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        let renderer = UIGraphicsImageRenderer(size: CGSize.init(width: newWidth, height: newHeight))
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
