//
//  EmptyTableViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation
import Core
import UIKit

final class EmptyTableViewCell: UITableViewCell, ReusableView {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension EmptyTableViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

}
