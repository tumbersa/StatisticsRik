//
//  RoundedDiagramTableViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import Core
import UIKit

final class RoundedDiagramTableViewCell: UITableViewCell, ReusableView {

    private let rangesAge: [String] = [
        "18-21", "22-25", "26-30", "31-35", "36-40", "40-50", ">50"
    ]

    private lazy var containerView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = Colors.white
        return containerView
    }()

    private lazy var diagramView: UIView = UIView()

    private lazy var menGenderStatsView = GenderStatsView()
    private lazy var womenGenderStatsView = GenderStatsView()

    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.separation
        return divider
    }()

    private var previousLabel: UILabel?
    private var previousAgeStatsView: AgeStatsView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(models: [RoundedDiagramCellModel]) {
        containerView.subviews.forEach {
            if $0 != diagramView && $0 != menGenderStatsView && $0 != womenGenderStatsView && $0 != divider {
                $0.removeFromSuperview()
            }
        }
        pinViews()

        let menPercent = models.count == 0 ?
        0 :
        Int(Double(models.filter{ $0.sex == .men }.count) / Double(models.count) * 100)
        menGenderStatsView.set(circleColor: Colors.red, gender: "Мужчины", percent: "\(menPercent)%")

        let womenPercent = models.count == 0 ?
        0 :
        Int(Double(models.filter{ $0.sex == .women }.count) / Double(models.count) * 100)
        womenGenderStatsView.set(circleColor: Colors.apricot, gender: "Женщины", percent: "\(womenPercent)%")

        for (index, gropedModels) in groupModelsByAgeRange(models: models).enumerated() {
            let ageStatsView = AgeStatsView()
            containerView.addSubview(ageStatsView)
            if index == 0 {
                ageStatsView.pin.top(to: divider.edge.bottom).left(98).right().height(27)
                    .marginTop(20)
            } else if let previousAgeStatsView {
                ageStatsView.pin.top(to: previousAgeStatsView.edge.bottom).left(98).right().height(27)
                   .marginTop(12)
            }

            ageStatsView.set(models: gropedModels)
            previousAgeStatsView = ageStatsView
        }

    }

}

private extension RoundedDiagramTableViewCell {

    func pinViews() {
        contentView.addSubview(containerView)
        containerView.pin.all().marginHorizontal(16)

        containerView.addSubview(diagramView)
        diagramView.backgroundColor = .red
        diagramView.pin.top(21).hCenter().width(152).height(151)

        containerView.addSubview(menGenderStatsView)
        menGenderStatsView.pin.left().top(to: diagramView.edge.bottom).height(16).width(103)
            .margin(20, 40, 0, 0)

        containerView.addSubview(womenGenderStatsView)
        womenGenderStatsView.pin.left(to: menGenderStatsView.edge.right).top(to: diagramView.edge.bottom)
            .right().height(16)
            .margin(20, 72, 0, 22)

        containerView.addSubview(divider)
        divider.pin.left().right().height(0.5).top(to: menGenderStatsView.edge.bottom)
            .marginTop(20)

        for (index, rangeAge) in rangesAge.enumerated() {
            let rangeAgeLabel = rangeAgeLabel(text: rangeAge)
            containerView.addSubview(rangeAgeLabel)

            if index == 0 {
                rangeAgeLabel.pin.left(24).top(to: divider.edge.bottom).marginTop(24)
                    .width(43).height(16)
            } else if let previousLabel {
                rangeAgeLabel.pin.left(24).top(to: previousLabel.edge.bottom).marginTop(24)
                    .width(43).height(16)
            }

            rangeAgeLabel.sizeToFit()
            rangeAgeLabel.pin.height(16)
            previousLabel = rangeAgeLabel
        }

    }

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func rangeAgeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Fonts.gilroySemiBold(size: 15).font
        return label
    }

    func groupModelsByAgeRange(models: [RoundedDiagramCellModel]) -> [[RoundedDiagramCellModel]] {
        return rangesAge.map { ageRange in
            models.filter { model in
                switch ageRange {
                case "18-21": return (18...21).contains(model.age)
                case "22-25": return (22...25).contains(model.age)
                case "26-30": return (26...30).contains(model.age)
                case "31-35": return (31...35).contains(model.age)
                case "36-40": return (36...40).contains(model.age)
                case "40-50": return (40...50).contains(model.age)
                case ">50": return model.age > 50
                default: return false
                }
            }
        }
    }

}

