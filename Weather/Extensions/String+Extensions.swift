//
//  String+Extensions.swift
//  Weather
//
//  Created by IVAN CHERNOV on 27.01.21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
