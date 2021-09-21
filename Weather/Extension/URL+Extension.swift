//
//  URL+Extension.swift
//  Weather
//
//  Created by Anh Tran on 21/09/2021.
//

import UIKit

extension URL {
    static func pngIconUrl(_ icon: String) -> URL? {
        return URL(string: ApiConstants.imageUrl + icon + ".png")
    }
}

