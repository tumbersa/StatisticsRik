//
//  LocalizableStringsDict.swift
//  Core
//
//  Created by Глеб Капустин on 23.05.2025.
//

import Foundation

public enum LocalizableStringsDict {
    public static let visitorsFormatString = NSLocalizedString(
        "visitors",
        bundle: Bundle(identifier: "kapustin.Core") ?? Bundle.main,
        comment: "Number of visitors"
    )
}
