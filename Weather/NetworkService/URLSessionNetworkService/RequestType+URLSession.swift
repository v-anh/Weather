//
//  RequestType+URLSession.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
extension RequestType {
    public func urlRequest(with environment: EnvironmentProtocol) -> URLRequest? {
        guard let url = url(with: environment) else {
            return nil
        }
        var request = URLRequest(url: url)
        // Append all related properties.
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        print(request)
        return request
    }
    private func url(with environment: EnvironmentProtocol) -> URL? {
        guard var urlComponents = URLComponents(string: environment.baseURL) else {
            return nil
        }
        urlComponents.path = urlComponents.path + path
        urlComponents.queryItems = queryItems
        urlComponents.queryItems?.append(URLQueryItem(name: "appid", value: environment.apiKey))
        return urlComponents.url
    }
    
    /// Returns the URLRequest `URLQueryItem`
    private var queryItems: [URLQueryItem]? {
        // Chek if it is a GET method.
        guard method == .get else {
            return nil
        }
        // Convert parameters to query items.
        return parameters.map { (key: String, value: CustomStringConvertible) -> URLQueryItem in
            return URLQueryItem(name: key, value: value.description)
        }
    }
}
