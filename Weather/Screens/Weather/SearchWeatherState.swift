//
//  SearchWeatherState.swift
//  Weather
//
//  Created by Anh Tran on 21/09/2021.
//

import Foundation
enum SearchWeatherState {
    case empty
    case loading
    case loaded([WeatherDisplayModel])
    case haveError(Error)
}

extension SearchWeatherState: Equatable {
    static func == (lhs: SearchWeatherState, rhs: SearchWeatherState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.loading, .loading): return true
        case (.loaded(let lshWeathers), .loaded(let rhsWeathers)): return lshWeathers == rhsWeathers
        case (.haveError, .haveError): return true
        default: return false
        }
    }
}
