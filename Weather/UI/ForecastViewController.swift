//
//  ForecastViewController.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation
import UIKit

enum LoadingErrorType {
    case noAPIKey
    case noCityEntered
    case networkError
}

class ForecastViewController: UIViewController {
    // UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataSourceSwitchLabel: UILabel!
    @IBOutlet weak var dataSourceSwitch: UISwitch!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var forecastTableView: UITableView!
    
    // internal variables
    private var dataProvider = ForecastDataProvider()
    private var forecast: Forecast?
    private var savedSwitchState: Bool = false // default dataSourceSwitch state is off
    private var settingsWereShown: Bool = false
    
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
    private func refreshData() {
        let isLocal = dataSourceSwitch.isOn
        if !isLocal && SettingsStorage.getSavedCity() == nil {
            if !settingsWereShown {
                performSegue(withIdentifier: "settingsSegue", sender: self)
                settingsWereShown = true
            } else {
                presentError(.noCityEntered)
            }
        } else {
            dataProvider.loadForecastData(isLocal: isLocal) { [weak self] forecast in
                self?.visualise(forecast)
            }
        }
    }
    
    private func visualise(_ forecast: Forecast?) {
        if let forecast = forecast {
            self.forecast = forecast
            DispatchQueue.main.async(execute: { [weak self] in
                self?.titleLabel.text = "mainScreen.title".localized + forecast.cityName
                self?.forecastTableView.reloadData()
            })
        } else {
            presentError(.networkError)
        }
    }
    
    private func presentError(_ errorType: LoadingErrorType) {
        let alert = UIAlertController(title: "error.\(errorType).title".localized, message: "error.\(errorType).message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            self.present(alert, animated: true)
            self.dataSourceSwitch.isOn = self.savedSwitchState
        })
    }
}

extension ForecastViewController: CityPresenting {
    func reloadCity() {
        refreshData()
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecast = self.forecast else { return 0 }
        return forecast.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let forecast = self.forecast else { return UITableViewCell() }
        let day = forecast.days[indexPath.row]
        let forecastPoints = forecast.daysForecasts[day] ?? []
        if let forecastCell = tableView.dequeueReusableCell(withIdentifier: ForecastCollectionContainerCell.identifier) as? ForecastCollectionContainerCell {
            forecastCell.setup(using: forecastPoints, day: day)
            return forecastCell
        } else {
            return UITableViewCell()
        }
    }
}
