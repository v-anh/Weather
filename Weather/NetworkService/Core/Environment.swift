//
//  Environment.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
public protocol EnvironmentProtocol {
    var headers: [String:String] { get }
    var baseURL: String { get }
    var apiKey:String {get}
}
