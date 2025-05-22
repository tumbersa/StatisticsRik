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
    case gilroyMedium(size: CGFloat)
    case gilroySemiBold(size: CGFloat)

    public var name: String {
        switch self {
            case .gilroyBold: return "Gilroy-Bold"
            case .gilroyMedium: return "Gilroy-Medium"
            case .gilroySemiBold: return "Gilroy-SemiBold"
        }
    }

    public var font: UIFont {
        switch self {
            case .gilroyBold(let size):
                return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .bold)
            case .gilroyMedium(size: let size):
                return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .medium)
            case .gilroySemiBold(size: let size):
                return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        }
    }

    public static let allFonts: [String] = [
        "Gilroy-Bold",
        "Gilroy-Medium",
        "Gilroy-SemiBold"
    ]
}
