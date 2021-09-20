//
//  WeatherService.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
import Combine
typealias GetWeatherResult = Result<WeatherResponseModel,Error>
protocol WeatherServiceType {
    func getWeather(searchTerm: String, units: String) -> AnyPublisher<GetWeatherResult,Never>
}

public struct WeatherService: WeatherServiceType {
    private let networkService:NetworkServiceType
    
    public init(_ networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    func getWeather(searchTerm: String, units: String) -> AnyPublisher<GetWeatherResult,Never> {
        let weatherRequest = WeatherRequest(searchTerm: searchTerm, units: units)
        
        return networkService.request(weatherRequest, type: WeatherResponseModel.self)
            .map {  GetWeatherResult.success($0)}
            .catch { error -> AnyPublisher<Result<WeatherResponseModel, Error>, Never> in
                .just(.failure(error))}
            .subscribe(on: Scheduler.userInitiatedScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
