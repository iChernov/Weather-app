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
    private var forecastPoints: [ForecastPoint] = []
        
    func setup(using forecastPoints: [ForecastPoint], day: Date) {
        self.forecastPoints = forecastPoints
        dayLabel.text = DateFormattingHelper.getSimpleDateString(from: day)
        forecastCollectionView.reloadData()
        setNeedsLayout()
    }
    
    override func prepareForReuse() {
        self.forecastPoints = []
        forecastCollectionView.reloadData()
        super.prepareForReuse()
    }

}

extension ForecastCollectionContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as? ForecastCollectionViewCell {
            cell.setup(with: forecastPoints[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
