//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Brenden Picioane on 10/7/20.
//  Copyright © 2020 Brenden Picioane. All rights reserved.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getData() {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherKey)"
        guard let url = URL(string: urlString) else {
            print("L. Couldn't create URL.")
            return
        }
        print(url)
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("L. \(error.localizedDescription)")
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("W. \(json)")
            } catch {
                print("JSON L. \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
