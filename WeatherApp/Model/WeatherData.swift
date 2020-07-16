//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Burak Tunc on 6.07.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    
    func getCelcius(temp:Double) -> Double {
        return temp - 272.15
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
