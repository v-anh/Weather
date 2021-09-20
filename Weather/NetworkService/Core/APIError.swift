//
//  APIError.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
public enum APIError: Error {
    case noData
    case invalidRequest
    case invalidResponse
    case badRequest
    case serverError
    case parseError
    case unknown
}
