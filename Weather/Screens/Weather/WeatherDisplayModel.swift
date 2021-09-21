//
//  WeatherDisplayModel.swift
//  Weather
//
//  Created by Anh Tran on 21/09/2021.
//

import Foundation
public struct WeatherDisplayModel {
    let date: TimeInterval
    let averageTemp: Float
    let pressure: Double
    let humidity: Double
    let description: String
    let iconUrl: URL
}
extension WeatherDisplayModel: Hashable {
    public static func == (lhs: WeatherDisplayModel, rhs: WeatherDisplayModel) -> Bool {
        return lhs.date == rhs.date
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}
