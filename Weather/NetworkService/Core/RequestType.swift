//
//  RequestType.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
public protocol RequestType {
    var path: String { get }
    var method: Method { get }
    var headers: [String : String] { get }
    var parameters: [String : CustomStringConvertible] { get }
}
