//
//  WeatherRequest.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
struct WeatherRequest:RequestType {
    typealias Response = WeatherResponseModel
    
    let searchTerm: String
    let units: String
    var path: String {
        "data/2.5/forecast/daily"
    }
    var method: Method {
        .get
    }
    
    var headers: [String : String] { [:] }
    
    var parameters: [String : CustomStringConvertible] {
        ["q":searchTerm,
         "units":units]
    }
}
