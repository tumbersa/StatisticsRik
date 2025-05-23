//
//  VisitorDiagramInfoView.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 23.05.2025.
//

import Foundation
import Core
import UIKit

final class VisitorDiagramInfoView: UIView {

    private lazy var visitorLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroySemiBold(size: 15).font
        label.textColor = Colors.red
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroyMedium(size: 13).font
        label.layer.opacity = 0.5
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(visitors: Int, dateText: String) {
        let formatString = LocalizableStringsDict.visitorsFormatString
        visitorLabel.text = String(format: formatString, visitors)
        dateLabel.text = dateText

        pinViews()
    }

}

private extension VisitorDiagramInfoView {

    func pinViews() {
        addSubview(visitorLabel)
        visitorLabel.pin
            .top().left().right().height(16)
            .margin(16, 16, 0, 16)

        visitorLabel.sizeToFit()

        addSubview(dateLabel)
        dateLabel.pin
            .left().right().top(to: visitorLabel.edge.bottom).height(16)
            .margin(8, 16, 0, 0)

        dateLabel.sizeToFit()
    }

    func configureAppearance() {
        backgroundColor = Colors.white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = Colors.gray3.cgColor
    }

}
