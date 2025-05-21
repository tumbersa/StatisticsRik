//
//  ReusableView.swift
//  Core
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation

public protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
