//
//  LabelTableViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation
import Core
import UIKit
import PinLayout

final class LabelTableViewCell: UITableViewCell, ReusableView {

    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(model: LabelCellModel) {
        label.font = model.font
        label.text = model.text
        label.sizeToFit()
    }

}

private extension LabelTableViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(label)
        label.pin.all().marginHorizontal(16)
    }

}

