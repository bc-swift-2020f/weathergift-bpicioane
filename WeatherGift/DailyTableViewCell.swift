//
//  DailyTableViewCell.swift
//  WeatherGift
//
//  Created by Brenden Picioane on 10/24/20.
//  Copyright © 2020 Brenden Picioane. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    var dailyWeather: DailyWeather! {
        didSet {
            dailyImageView.image = UIImage(named: dailyWeather.dailyIcon)
            dailyWeekdayLabel.text = dailyWeather.dailyWeekday
            dailyHighLabel.text = "\(dailyWeather.dailyHigh)°"
            dailyLowLabel.text = "\(dailyWeather.dailyLow)°"
            dailySummaryView.text = dailyWeather.dailySummary
            

        }
    }

    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyWeekdayLabel: UILabel!
    @IBOutlet weak var dailyHighLabel: UILabel!
    @IBOutlet weak var dailyLowLabel: UILabel!
    @IBOutlet weak var dailySummaryView: UITextView!
    

}
