//
//  CityDayWeatherViewController.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation
import UIKit

class CityDayWeatherViewController: UIViewController {
    // UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataSourceSwitchLabel: UILabel!
    @IBOutlet weak var switchLabel: UISwitch!
    @IBOutlet weak var settingsButton: UIButton!
    
    // internal variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.setTitle(NSLocalizedString("mainScreen.settingsButton.title", comment: ""), for: .normal)
        if let city = SettingsStorage.loadCity() {
            titleLabel.text = NSLocalizedString("mainScreen.title", comment: "") + city.name
            requestWeatherData(for: city)
        } else {
            performSegue(withIdentifier: "settingsSegue", sender: self)
        }
    }
    
    // User interactions
    @IBAction func dataSourceSwitchAction(_ sender: UISwitch) {
        print("switch activated: \(sender.isOn)")
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    
    // Internal methods
    private func requestWeatherData(for city: City) {
        
    }
}
