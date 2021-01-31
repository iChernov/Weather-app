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
        // we can set a precision of temperature here,
        // i.e. Usually decimals after comma are not presented.
        let formattedTemp = String(format: "%.1f", data.main.temp)
        let prefix = data.main.temp > 0 ? "+" : ""
        temperatureLabel.text = prefix + formattedTemp + "°C"
        
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
        IconLoader.shared.loadWeatherIcon(code) { [weak self] result in
            
            switch result {
            case .success(let icon):
                DispatchQueue.main.async {
                    self?.weatherIcon.image = icon
                }
            case .failure(_):
                break
            }
        }
//        let imagesCache = ImageCache.shared
//        // More complex logic could be implemented here - i.e. provide a special images loader
//        // and Combine-based Publisher-Subscriber relation to this loader, which also would
//        // prevent multiple loadings of the icons with the same code, and provide a publisher
//        // to already existing loading instead. NSCache also could be moved there
//        if let icon = imagesCache[code] {
//            weatherIcon.image = icon
//            weatherIcon.setNeedsLayout()
//        } else if let url = URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png") {
//            weatherIcon.load(url: url) { image in
//                if let loadedImage = image {
//                    imagesCache[code] = loadedImage
//                }
//            }
//        }
    }
    
    override func prepareForReuse() {
        temperatureLabel.text = ""
        dateAndTimeLabel.text = ""
        weatherIcon.image = nil
        super.prepareForReuse()
    }
}
