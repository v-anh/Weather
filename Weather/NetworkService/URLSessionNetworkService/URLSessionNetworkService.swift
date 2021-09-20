//
//  URLSessionNetworkService.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
import Combine

final class URLSessionNetworkService: NetworkServiceType {
    
    var environment: EnvironmentProtocol
    
    private let session: URLSession
    let cache: Cacheable

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral),
         enviroment: EnvironmentProtocol = APIEnvironment.development,
         cache: Cacheable = URLResponseCache.default) {
        self.session = session
        self.environment = enviroment
        self.cache = cache
    }
    
}

extension URLSessionNetworkService {
    func request<T:Decodable>(_ request: RequestType, type: T.Type) -> AnyPublisher<T,Error> {
        guard let request = request.urlRequest(with: self.environment) else {
            return .fail(APIError.invalidRequest)
        }
        if let cacheData = cache.object(ofType: type.self, forKey: request) {
            return .just(cacheData)
        }
        return session.dataTaskPublisher(for: request)
            .mapError{ _ in APIError.invalidRequest }
            .print().flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(APIError.invalidRequest)
                }
                let result = self.verify(data: data, urlResponse: response)
                switch result {
                case .success(let data):
                    return .just(data)
                case .failure(let error):
                    return .fail(error)
                    
                }
            }.decode(type: type.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func verify(data: Data?, urlResponse: HTTPURLResponse) -> Result<Data, APIError> {
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(APIError.noData)
            }
        case 400...499:
            return .failure(APIError.badRequest)
        case 500...599:
            return .failure(APIError.serverError)
        default:
            return .failure(APIError.unknown)
        }
    }
    
}
