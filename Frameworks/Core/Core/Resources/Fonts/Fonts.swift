//
//  Fonts.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation
import UIKit

public enum Fonts {
    case gilroyBold(size: CGFloat)

    public var name: String {
        switch self {
        case .gilroyBold: return "Gilroy-Bold"
        }
    }

    public var font: UIFont {
        switch self {
        case .gilroyBold(let size):
            return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .bold)
        }
    }

    public static let allFonts: [String] = [
        "Gilroy-Bold"
    ]
}
