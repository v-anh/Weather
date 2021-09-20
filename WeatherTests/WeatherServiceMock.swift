//
//  WeatherServiceMock.swift
//  WeatherTests
//
//  Created by Anh Tran on 20/09/2021.
//

import Foundation
import Combine
@testable import Weather
class WeatherServiceMock: WeatherServiceType {
    var mockResponse: WeatherResponseModel? = .mock()
    func getWeather(searchTerm: String, units: String) -> AnyPublisher<GetWeatherResult,Never> {
        return Just(.success(mockResponse!)).eraseToAnyPublisher()
    }
}

extension WeatherResponseModel {
    public static let mock = {
        WeatherResponseModel(cod: "cod", message: 1, cnt: 2, city: City(id: 1, name: "city"), list: [WeatherFactor(dt: 1.0, sunrise: 2.0, sunset: 3.0, temp: nil, pressure: 4.0, humidity: 4.0, weather: nil, speed: 4.0, deg: 1, gust: 4.0, clouds: 4, pop: 4.0, rain: 4.0)])
    }
}
