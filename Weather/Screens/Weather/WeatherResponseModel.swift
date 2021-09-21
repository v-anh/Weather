//
//  WeatherResponseModel.swift
//  Weather
//
//  Created by Anh Tran on 19/09/2021.
//

import Foundation
public struct WeatherResponseModel:Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let city: City?
    let list:[WeatherFactor]?
}

public struct City:Codable {
    let id: Double?
    let name: String?
}

public struct WeatherFactor:Codable {
    let dt: TimeInterval?
    let sunrise: Double?
    let sunset: Double?
    let temp: Temp?
    let pressure: Double?
    let humidity: Double?
    let weather: [Weather]?
    let speed: Double?
    let deg:Int?
    let gust:Double?
    let clouds:Int?
    let pop:Double?
    let rain:Double?
}

public struct Weather: Codable {
    let id: Int?
    let main:String?
    let weatherDescription: String?
    let icon: String?
    private enum CodingKeys: String, CodingKey {
            case id,main,icon
            case weatherDescription = "description"
        }
}

public struct Temp:Codable {
    let eve:Float?
}
