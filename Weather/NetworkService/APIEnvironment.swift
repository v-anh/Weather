//
//  APIEnvironment.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
struct ApiConstants {
    static let developmentAPIKey = "60c6fbeb4b93ac653c492ba806fc346d"
    static let baseUrl = "https://api.openweathermap.org/"
    static let imageUrl = "https://openweathermap.org/img/w/"
}

enum APIEnvironment: EnvironmentProtocol {
    
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
            return ApiConstants.baseUrl
        }
    }
    
    var apiKey: String {
        switch self {
        case .development:
            return ApiConstants.developmentAPIKey
        }
    }
    
    var weatherIconUrl:String {
        switch self {
        case .development:
            return "http://openweathermap.org/img/w/"
        }
    }
}
