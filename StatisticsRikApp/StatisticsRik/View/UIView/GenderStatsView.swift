//
//  GenderStatsView.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import Core
import UIKit

final class GenderStatsView: UIView {

    private lazy var circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()

    private lazy var genderlabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroyMedium(size: 13).font
        return label
    }()

    private lazy var percentlabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroyMedium(size: 13).font
        return label
    }()

    func set(circleColor: UIColor, gender: String, percent: String) {
        circleView.backgroundColor = circleColor
        genderlabel.text = gender
        percentlabel.text = percent

        pinViews()
    }

}

private extension GenderStatsView {

    func pinViews() {
        addSubview(circleView)
        circleView.pin.left().top().bottom().width(10).marginVertical(3)

        addSubview(genderlabel)
        genderlabel.pin.after(of: circleView).right().height(16).marginLeft(6)
        genderlabel.sizeToFit()
        genderlabel.pin.vCenter(to: circleView.edge.vCenter)

        addSubview(percentlabel)
        percentlabel.pin.right().left(to: genderlabel.edge.right).height(16).marginLeft(6)
        percentlabel.sizeToFit()
        percentlabel.pin.vCenter(to: circleView.edge.vCenter)
    }

}
