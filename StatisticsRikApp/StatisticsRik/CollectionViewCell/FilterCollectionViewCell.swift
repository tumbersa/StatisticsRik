//
//  FilterCollectionViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import UIKit
import Core

final class FilterCollectionViewCell: UICollectionViewCell, ReusableView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroySemiBold(size: 15).font
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureAppearance()
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? Colors.red : .clear
            contentView.layer.borderWidth = isSelected ? 0 : 1
            titleLabel.textColor = isSelected ? Colors.white : Colors.black
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String) {
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        titleLabel.pin.all().margin(8, 16)
        titleLabel.sizeToFit()
    }

}

private extension FilterCollectionViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Colors.gray.cgColor
        contentView.layer.cornerRadius = 16
    }

}
