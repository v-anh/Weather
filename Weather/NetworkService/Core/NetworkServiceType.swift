//
//  NetworkServiceType.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
import Combine
public protocol NetworkServiceType {
    var environment: EnvironmentProtocol {get}
    func request<T:Decodable>(_ request: RequestType, type: T.Type) -> AnyPublisher<T,Error>
}
