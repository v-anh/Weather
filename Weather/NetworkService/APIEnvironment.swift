//
//  APIEnvironment.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
enum APIEnvironment: EnvironmentProtocol {
    
    //https://api.openweathermap.org/data/2.5/forecast/daily?q=saigon&cnt=7&appid=60c6fbeb4b93ac653c492ba806fc346d&units=metric
    case development
    
    var headers: [String:String] {
        switch self {
        case .development:
            return [
                "Content-Type" : "application/json",
            ]
        }
    }
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://api.openweathermap.org/"
        }
    }
    
    var apiKey: String {
        switch self {
        case .development:
            return "60c6fbeb4b93ac653c492ba806fc346d"
        }
    }
    
    
    var weatherIconUrl:String {
        switch self {
        case .development:
            return "http://openweathermap.org/img/w/"
        }
    }
}
