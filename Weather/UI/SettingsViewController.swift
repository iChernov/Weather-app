//
//  SettingsViewController.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation
import UIKit

protocol CityPresenting: class {
    func setNewCity(_ cityName: String)
}

class SettingsViewController: UIViewController {
    // UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var cityNameField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    // internal variables
    fileprivate var _selectedCityName: String = ""
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        setTexts()
        refreshSubmitButton()
        submitButton.layer.cornerRadius = 3.0
    }
    
    // User interactions
    @IBAction func submitSettings(_ sender: Any) {
        saveSettings()
        dismiss(animated: true, completion: nil)
    }
    
    // private methods
    private func setTexts() {
        titleLabel.text = NSLocalizedString("settings.title", comment: "The top title of the settings screen")
        explanationLabel.text = NSLocalizedString("settings.explanation", comment: "Explanation regarding why and how user should enter new city name")
        submitButton.setTitle(NSLocalizedString("settings.submitButton.title", comment: ""), for: .normal)
    }
    
    private func refreshSubmitButton() {
        let shouldBeEnabled = (cityNameField.text?.count ?? 0) > 0
        submitButton.isEnabled = shouldBeEnabled
        submitButton.backgroundColor = shouldBeEnabled ? .systemBlue : .gray
        submitButton.alpha = shouldBeEnabled ? 1.0 : 0.5
    }
    
    private func loadSettings() {
        if let city = SettingsStorage.loadCity() {
            cityNameField.text = city.name
        }
    }
    
    private func saveSettings() {
        if let enteredCityName = cityNameField.text as? String {
            SettingsStorage.saveCity(city: City(name: enteredCityName))
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        refreshSubmitButton()
        cityNameField.resignFirstResponder()
        return true
    }
}
