//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Brenden Picioane on 10/9/20.
//  Copyright © 2020 Brenden Picioane. All rights reserved.
//

import Foundation

class WeatherDetail: WeatherLocation {
    struct Result: Codable {
        var timezone: String
        var current: Current
    }
    
    struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    
    func getData(completed: @escaping () -> ()) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherKey)"
        guard let url = URL(string: urlString) else {
            print("L. Couldn't create URL.")
            completed()
            return
        }
        print(url)
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("L. \(error.localizedDescription)")
            }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                print("W. \(result)")
                //print("The time zone for \(self.name) is \(result.timezone)")
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dailyIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
            } catch {
                print("JSON L. \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
    private func fileNameForIcon(icon: String) -> String {
        var newFileName = ""
        switch icon {
        case "01d", "02d":
            newFileName = "clear-day"
        case "01n", "02n":
            newFileName = "clear-night"
        case "03d", "04d", "03n", "04n":
            newFileName = "few-clouds-day"
        case "09d", "09n", "10d", "10n", "11d", "11n", "50d", "50n":
            newFileName = "scattered-clouds-day"
        case "13d":
            newFileName = "snow-day"
        case "13n":
            newFileName = "snow-night"
        default:
            newFileName = icon
        }
        return newFileName
    }
}

