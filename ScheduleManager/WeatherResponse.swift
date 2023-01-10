//
//  WeatherResponse.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import Foundation

struct WeatherResponse: Codable {
    var weather: String
    var temp: Double
}

struct CityName: Codable {
    var name: String
    var country: String
}
