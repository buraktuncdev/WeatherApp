//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Burak Tunc on 6.07.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error: Error)
    
    func sayHello(name:String)
}

struct WeatherManager {

    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=<APIKEY>
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherWithLatLong(latitude:CLLocationDegrees, longitute:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            
            let task = session.dataTask(with: url, completionHandler: {data, response, error in
                if error != nil {
                    print("Error: \(error!)")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        
                        // Weather Manager Delegate didUpdateWeather Method
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                        // Own Delegate Method
                        self.delegate?.sayHello(name: "Burak")
                    }
                }
            })
            
            // 4. Start The Task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.getCelcius(temp: decodedData.main.temp)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }catch{
            print("Decode error \(error)")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
    
    
}
