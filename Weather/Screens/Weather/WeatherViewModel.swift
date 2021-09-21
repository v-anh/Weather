//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
import Combine

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
    
    enum WeatherSection: CaseIterable {
        case weatherList
    }
    
    let service: WeatherServiceType
    let config: WeatherConfigType
    
    private var cancellable = Set<AnyCancellable>()
    init(service: WeatherServiceType,
         config: WeatherConfigType) {
        self.service = service
        self.config = config
    }
    
    
    func transform(input: WeatherViewModelInput) -> WeatherViewModelOutput {
        let initialState: AnyPublisher<SearchWeatherState,Never> = .just(.empty)
        
        let searchTerm = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .filter{$0.count > 3}

        let searchResult = searchTerm.flatMapLatest { [unowned self] searchTerm in
                self.service.getWeather(searchTerm: searchTerm,
                                        units: self.config.unit)
            }
            .map(weatherResultTranform(_:))
            .eraseToAnyPublisher()
        
        let emptySearchInput = input.search
            .filter(\.isEmpty)
            .map{ _ in SearchWeatherState.empty}
        
        let weatherState = Publishers.Merge3(initialState,emptySearchInput,searchResult).eraseToAnyPublisher()
        return WeatherViewModelOutput(weatherSearchOutput: weatherState)
    }
}

extension WeatherViewModel {
    private func weatherResultTranform(_ result: GetWeatherResult) -> SearchWeatherState {
        switch result {
        case .success(let data):
            let displayModels = makeDisplayModels(data.list)
            return displayModels.isEmpty ? .empty : .loaded(displayModels)
        case .failure(let error):
            return .haveError(error)
        }
    }
    
    private func makeDisplayModels(_ weatherList: [WeatherFactor]?) -> [WeatherDisplayModel] {
        guard let weatherList = weatherList,
              !weatherList.isEmpty else {return []}
        
        return weatherList.compactMap { weatherfactor -> WeatherDisplayModel? in
            guard let temp = weatherfactor.temp,
                  let dt = weatherfactor.dt,
                  let averageTemp = temp.eve,
                  let pressure = weatherfactor.pressure,
                  let humidity = weatherfactor.humidity,
                  let weather = weatherfactor.weather?.first,
                  let description = weather.weatherDescription,
                  let icon = weather.icon,
                  let url = URL.pngIconUrl(icon)
            else {
                return nil
            }
            return WeatherDisplayModel(date: dt,
                                averageTemp: averageTemp,
                                pressure: pressure,
                                humidity: humidity,
                                description: description,
                                iconUrl: url)
        }
    }
}
