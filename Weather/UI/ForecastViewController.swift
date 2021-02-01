//
//  ForecastViewController.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation
import UIKit

class ForecastViewController: UIViewController {
    // number of forecast data points per day, as defined by openweathermap API
    let pointsPerDay = 8
    
    // UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataSourceSwitchLabel: UILabel!
    @IBOutlet weak var dataSourceSwitch: UISwitch!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var forecastTableView: UITableView!
    
    // internal variables
    private var weatherData: WeatherData?
    private var savedSwitchState: Bool = false // default dataSourceSwitch state is off
    
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
        savedSwitchState = !sender.isOn
        settingsButton.isHidden = sender.isOn
        refreshData()
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }

    // Internal methods
    fileprivate func refreshData() {
        if dataSourceSwitch.isOn {
            loadLocalWeather()
        } else {
            if let city = SettingsStorage.loadCity() {
                loadWeather(for: city.name)
            } else {
                performSegue(withIdentifier: "settingsSegue", sender: self)
            }
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
                self?.titleLabel.text = "mainScreen.title".localized + data.city.name
                self?.forecastTableView.reloadData()
            })
        } else {
            let alert = UIAlertController(title: "generalFailure.title".localized, message: "generalFailure.message".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
            
            DispatchQueue.main.async(execute: { [weak self] in
                guard let self = self else { return }
                self.present(alert, animated: true)
                self.dataSourceSwitch.isOn = self.savedSwitchState
            })
        }
    }
}

extension ForecastViewController: CityPresenting {
    func reloadCity() {
        refreshData()
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = weatherData else { return 0 }
        return data.cnt/pointsPerDay // by default it should be 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayIndex = indexPath.row
        guard let weatherData = weatherData else { return UITableViewCell() }
        let forecastDataForDay = Array(weatherData.list[pointsPerDay*dayIndex...pointsPerDay*(dayIndex+1)-1])
        if let forecastCell = tableView.dequeueReusableCell(withIdentifier: ForecastCollectionContainerCell.identifier) as? ForecastCollectionContainerCell {
            forecastCell.setup(using: forecastDataForDay)
            return forecastCell
        } else {
            return UITableViewCell()
        }
    }
}
