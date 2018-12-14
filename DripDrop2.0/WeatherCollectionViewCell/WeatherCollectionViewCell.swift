//
//  WeatherCollectionViewCell.swift
//  DripDrop2.0
//
//  Created by DevMountain on 12/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var dailyWeather: DailyWeather?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let dailyWeather = dailyWeather else { return }
        summaryLabel.text = dailyWeather.summary
        temperatureLabel.text = "\(Int(dailyWeather.avgTemperature))º"
        let image = UIImage(named: dailyWeather.iconName)
        iconImageView.image = image
        
        iconImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        iconImageView.layer.shadowRadius = 2.0
        iconImageView.layer.shadowOpacity = 0.8
    }
    
}
