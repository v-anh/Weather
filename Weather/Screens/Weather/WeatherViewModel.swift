//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
import Combine


enum SearchWeatherState {
    case empty
    case loading
    case loaded([WeatherFactor])
    case haveError(Error)
}

struct WeatherViewModelInput {
    let loadView: AnyPublisher<Void,Never>
    let search: AnyPublisher<String,Never>
}

struct WeatherViewModelOutput {
    let weatherSearchOutput :AnyPublisher<SearchWeatherState,Never>
}
protocol WeatherViewModelType {
    func transform(input: WeatherViewModelInput) -> WeatherViewModelOutput
}

protocol WeatherConfigType {
    var unit: String {get}
}

struct WeatherConfig: WeatherConfigType {
    var unit: String {
        "metric"
    }
    
}

final class WeatherViewModel: WeatherViewModelType {
    
    let service: WeatherServiceType
    let config: WeatherConfig
    
    private var cancellable = Set<AnyCancellable>()
    init(service: WeatherServiceType,
         config: WeatherConfig) {
        self.service = service
        self.config = config
    }
    
    
    func transform(input: WeatherViewModelInput) -> WeatherViewModelOutput {
        let initialState: AnyPublisher<SearchWeatherState,Never> = .just(.empty)
        let searchResult = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .filter{$0.count > 3}
            .removeDuplicates().flatMapLatest { [unowned self] searchTerm in
                self.service.getWeather(searchTerm: searchTerm,
                                        units: self.config.unit)
            }
            .map(weatherResultTranform(_:))
            .eraseToAnyPublisher()
        let weatherState = Publishers.Merge(initialState, searchResult).eraseToAnyPublisher()
        return WeatherViewModelOutput(weatherSearchOutput: weatherState)
    }
}

extension WeatherViewModel {
    private func weatherResultTranform(_ result: GetWeatherResult) -> SearchWeatherState {
        
        switch result {
        case .success(let data):
            return data.list.isEmpty ? .empty : .loaded(data.list)
        case .failure(let error):
            return .haveError(error)
        }
    }
}
