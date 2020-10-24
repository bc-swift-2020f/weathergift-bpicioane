//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Brenden Picioane on 10/9/20.
//  Copyright © 2020 Brenden Picioane. All rights reserved.
//

import Foundation

struct DailyWeather {
    var dailyIcon: String
    var dailyWeekday: String
    var dailySummary: String
    var dailyHigh: Int
    var dailyLow: Int
}

struct HourlyWeather {
    var hour: String
    var hourlyTemperature: Int
    var hourlyIcon: String
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

private let hourFormatter: DateFormatter = {
    let hourFormatter = DateFormatter()
    hourFormatter.dateFormat = "ha"
    return hourFormatter
}()

class WeatherDetail: WeatherLocation {
    
    private struct Result: Codable {
        var timezone: String
        var current: Current
        var daily: [Daily]
        var hourly: [Hourly]
    }
    
    private struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    private struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    private struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    private struct Hourly: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    private struct Temp: Codable {
        var max: Double
        var min: Double
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather] = []
    
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
                //print("W. \(result)")
                //print("The time zone for \(self.name) is \(result.timezone)")
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dayIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
                for index in 0..<result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekdayDate)
                    let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyHigh = Int(result.daily[index].temp.max.rounded())
                    let dailyLow = Int(result.daily[index].temp.min.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    print("Day: \(dailyWeekday), High: \(dailyHigh), Low: \(dailyLow)")
                }
                for index in 0..<result.hourly.count {
                    let hourlyDate = Date(timeIntervalSince1970: result.hourly[index].dt)
                    hourFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let hour = hourFormatter.string(from: hourlyDate)
                    let hourlyIcon = self.fileNameForIcon(icon: result.hourly[index].weather[0].icon)
                    let hourlyTemperature = Int(result.hourly[index].temp.rounded())
                    let hourlyWeather = HourlyWeather(hour: hour, hourlyTemperature: hourlyTemperature, hourlyIcon: hourlyIcon)
                    self.hourlyWeatherData.append(hourlyWeather)
                    print("Hour: \(hour), Temperature: \(hourlyTemperature), Icon: \(hourlyIcon)")
                }
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

