//
//  ForecastCollectionContainerCell.swift
//  Weather
//
//  Created by IVAN CHERNOV on 28.01.21.
//

import UIKit

class ForecastCollectionContainerCell: UITableViewCell {

    static let identifier = "forecastCollectionContainerCell"
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    private var forecastDataArray: [CityData] = []
    
    func setup(using forecastDataArray: [CityData]) {
        self.forecastDataArray = forecastDataArray
        dayLabel.text = extractWeekday(from: forecastDataArray.first)
        forecastCollectionView.reloadData()
        setNeedsLayout()
    }
    
    override func prepareForReuse() {
        self.forecastDataArray = []
        forecastCollectionView.reloadData()
        super.prepareForReuse()
    }
    
    private func extractWeekday(from cityData: CityData?) -> String {
        if let data = cityData,
           let date = data.dtTxt.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, dd.MM"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}

extension ForecastCollectionContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as? ForecastCollectionViewCell {
            cell.setup(with: forecastDataArray[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
