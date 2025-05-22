//
//  AgeStatsView.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import Core
import UIKit

final class AgeStatsView: UIView {

    private lazy var menBeanView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.red
        view.layer.cornerRadius = 2.5
        return view
    }()

    private lazy var womenBeanView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.apricot
        view.layer.cornerRadius = 2.5
        return view
    }()

    private lazy var menPercentLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroyMedium(size: 10).font
        return label
    }()

    private lazy var womenPercentLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroyMedium(size: 10).font
        return label
    }()

    func set(models: [RoundedDiagramCellModel]) {
        let menPercent = models.count == 0 ?
        0 :
        Int(Double(models.filter{ $0.sex == .men }.count) / Double(models.count) * 100)

        let womenPercent = models.count == 0 ?
        0 :
        Int(Double(models.filter{ $0.sex == .women }.count) / Double(models.count) * 100)

        menPercentLabel.text = "\(menPercent)%"
        womenPercentLabel.text = "\(womenPercent)%"

        pinViews(models: models, menPercent: menPercent, womenPercent: womenPercent)
    }
}

private extension AgeStatsView {

    func pinViews(models: [RoundedDiagramCellModel], menPercent: Int, womenPercent: Int) {
        addSubview(menBeanView)
        let menBeanWidth: CGFloat = CGFloat(0...2 ~= menPercent ? 5 : menPercent * 2)
        menBeanView.pin.top().left().height(5).width(menBeanWidth)

        addSubview(menPercentLabel)
        menPercentLabel.pin
            .top().left(to: menBeanView.edge.right)
            .height(11).width(30)
            .marginLeft(10)
        menPercentLabel.sizeToFit()

        menBeanView.pin.vCenter(to: menPercentLabel.edge.vCenter)

        addSubview(womenBeanView)
        let womenBeanWidth: CGFloat = CGFloat(0...2 ~= womenPercent ? 5 : womenPercent * 2)
        womenBeanView.pin
            .top(to: menPercentLabel.edge.bottom).left()
            .height(5).width(womenBeanWidth)
            .marginTop(5)

        addSubview(womenPercentLabel)
        womenPercentLabel.pin
            .top(to: menPercentLabel.edge.bottom).left(to: womenBeanView.edge.right)
            .height(11).width(30)
            .marginLeft(10).marginTop(5)

        womenPercentLabel.sizeToFit()
        womenBeanView.pin.vCenter(to: womenPercentLabel.edge.vCenter)
    }

}
