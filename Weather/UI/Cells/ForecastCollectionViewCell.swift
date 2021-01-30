//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by IVAN CHERNOV on 28.01.21.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "forecastCollectionViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.borderColor = UIColor.systemBlue.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 2.0
    }
    
    func setup(with data: CityData) {
        temperatureLabel.text = "\(data.main.temp) °C"
        
        if let date = data.dtTxt.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy\nHH:mm"
            dateAndTimeLabel.text = dateFormatter.string(from: date).replacingOccurrences(of: " ", with: "\n")
        }
        loadImage(data.weather.first?.icon)
        setNeedsLayout()
    }
    
    private func loadImage(_ imageCode: String?) {
        guard let code = imageCode else { return }
        if let url = URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png") {
            weatherIcon.load(url: url)
        }
    }
    
    override func prepareForReuse() {
        temperatureLabel.text = ""
        dateAndTimeLabel.text = ""
        weatherIcon.image = nil
        super.prepareForReuse()
    }
}
