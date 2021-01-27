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
    @IBOutlet weak var dataSourceSwitch: UISwitch!
    @IBOutlet weak var settingsButton: UIButton!
    
    // internal variables
    private var weatherData: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.setTitle("mainScreen.settingsButton.title".localized, for: .normal)
        dataSourceSwitchLabel.text = "mainScreen.dataSourceSwitch.title".localized
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SettingsViewController {
            destination.delegate = self
        }
    }
    
    // User interactions
    @IBAction func dataSourceSwitchAction(_ sender: UISwitch) {
        print("switch activated: \(sender.isOn)")
        refreshData()
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }

    // Internal methods
    fileprivate func refreshData() {
        if dataSourceSwitch.isOn {
            if let city = SettingsStorage.loadCity() {
                titleLabel.text = "mainScreen.title".localized + city.name
                loadWeather(for: city.name)
            } else {
                performSegue(withIdentifier: "settingsSegue", sender: self)
            }
        } else {
            loadLocalWeather()
        }
    }
    
    fileprivate func loadLocalWeather() {
        WeatherDataManager.fetchLocalWeather(fileName: "LocalWeatherData", fileType: "json") { [weak self] weatherData in
            self?.visualise(weatherData)
        }
    }
    
    fileprivate func loadWeather(for cityName: String) {
        WeatherDataManager.fetchWeather(for: cityName) { [weak self] weatherData in
            self?.visualise(weatherData)
        }
    }
    
    fileprivate func visualise(_ weatherData: WeatherData?) {
        if let data = weatherData {
            self.weatherData = data
            DispatchQueue.main.async(execute: { [weak self] in
                self?.reloadTable()
            })
        } else {
            let alert = UIAlertController(title: "generalFailure.title".localized, message: "generalFailure.message".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
            
            DispatchQueue.main.async(execute: { [weak self] in
                self?.present(alert, animated: true)
            })
        }
    }
    
    fileprivate func reloadTable() {
        self.view.backgroundColor = .green
    }
}

extension CityDayWeatherViewController: CityPresenting {
    func reloadCity() {
        refreshData()
    }
}

