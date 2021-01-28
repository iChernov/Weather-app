//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by IVAN CHERNOV on 28.01.21.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "forecastCollectionViewCell"
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!

    func setup(with data: CityData) {
        temperatureLabel.text = "\(data.main.temp) °C"
        dateAndTimeLabel.text = data.dtTxt.replacingOccurrences(of: " ", with: "\n")
        loadImage(data.weather.first?.icon)

    }
    
    private func loadImage(_ imageCode: String?) {
        guard let code = imageCode else { return }
        
        //        data.weather?.first.icon // http://openweathermap.org/img/wn/10d@2x.png
        // http://openweathermap.org/img/wn/10d@2x.png
    }
}
