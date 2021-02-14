//
//  SettingsViewController.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation
import UIKit

protocol CityPresenting: class {
    func reloadCity()
}

class SettingsViewController: UIViewController {
    // UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var cityNameField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    // internal variables
    fileprivate var _selectedCityName: String = ""
    weak var delegate: CityPresenting?

    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        setTexts()
        refreshSubmitButton()
        submitButton.layer.cornerRadius = 3.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reloadCity()
    }
    
    // User interactions
    @IBAction func submitSettings(_ sender: Any) {
        saveSettings()
        delegate?.reloadCity()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func detectClosestCity(_ sender: Any) {
        // not required in task - not released in this solution
        // but in general - it is a good idea to suggest a city
        // based on user's location
    }
    
    // private methods
    private func setTexts() {
        titleLabel.text = "settings.title".localized
        explanationLabel.text = "settings.explanation".localized
        submitButton.setTitle("settings.submitButton.title".localized, for: .normal)
    }
    
    private func refreshSubmitButton() {
        let shouldBeEnabled = (cityNameField.text?.count ?? 0) > 0
        submitButton.isEnabled = shouldBeEnabled
        submitButton.backgroundColor = shouldBeEnabled ? .systemBlue : .gray
        submitButton.alpha = shouldBeEnabled ? 1.0 : 0.5
    }
    
    private func loadSettings() {
        if let city = SettingsStorage.getSavedCity() {
            cityNameField.text = city.name
        }
    }
    
    private func saveSettings() {
        if var enteredCityName = cityNameField.text {
            while enteredCityName.last?.isWhitespace == true {
                enteredCityName = String(enteredCityName.dropLast())
            }
            SettingsStorage.saveCity(city: UserCity(name: enteredCityName))
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
