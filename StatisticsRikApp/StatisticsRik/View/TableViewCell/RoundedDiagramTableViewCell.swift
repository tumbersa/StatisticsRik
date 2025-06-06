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

    // MARK: - Constants

    private enum Constants {
        static let containerCornerRadius: CGFloat = 16
        static let diagramSize = CGSize(width: 152, height: 151)
        static let dividerHeight: CGFloat = 0.5
        static let ageStatsHeight: CGFloat = 27
        static let labelHeight: CGFloat = 16
        static let ageLabelWidth: CGFloat = 43
    }

    // MARK: - Properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.containerCornerRadius
        view.backgroundColor = Colors.white
        return view
    }()

    private lazy var menGenderStatsView = GenderStatsView()
    private lazy var womenGenderStatsView = GenderStatsView()

    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separation
        return view
    }()

    private var previousLabel: UILabel?
    private var previousAgeStatsView: AgeStatsView?
    private var diagramView: CircularDiagramView?

    private var ageStatsViews: [AgeStatsView] = []

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        diagramView?.removeFromSuperview()
        diagramView = nil
        previousAgeStatsView = nil
    }

    // MARK: - Public API

    func set(rangesAge: [String], models: [RoundedDiagramCellModel], modelsByAgeRange: [[RoundedDiagramCellModel]]) {
        pinViews()
        configureRangeAgeLabels(rangesAge: rangesAge)
        configureGenderStats(models: models)
        configureAgeStats(modelsByAgeRange: modelsByAgeRange)
    }
}

// MARK: - Private

private extension RoundedDiagramTableViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func pinViews() {
        contentView.addSubview(containerView)
        containerView.pin.all().marginHorizontal(16)

        pinDiagramSection()
        pinGenderStats()
        pinDivider()
    }

    func pinDiagramSection() {
        diagramView = CircularDiagramView(
            lineWidth: 10,
            remainderColor: Colors.red,
            progressColor: Colors.apricot,
            emptyStateColor: Colors.gray
        )
        guard let diagramView else { return }
        containerView.addSubview(diagramView)
        diagramView.pin.top(21).hCenter().size(Constants.diagramSize)
    }

    func pinGenderStats() {
        guard let diagramView else { return }
        containerView.addSubview(menGenderStatsView)
        menGenderStatsView.pin.left()
            .top(to: diagramView.edge.bottom)
            .height(Constants.labelHeight).width(103)
            .margin(20, 40, 0, 0)

        containerView.addSubview(womenGenderStatsView)
        womenGenderStatsView.pin.left(to: menGenderStatsView.edge.right)
            .top(to: diagramView.edge.bottom).right()
            .height(Constants.labelHeight)
            .margin(20, 72, 0, 22)
    }

    func pinDivider() {
        containerView.addSubview(divider)
        divider.pin.left().right().height(Constants.dividerHeight)
            .top(to: menGenderStatsView.edge.bottom).marginTop(20)
    }

    func configureRangeAgeLabels(rangesAge: [String]) {
        guard previousLabel == nil else { return }
        for (index, rangeAge) in rangesAge.enumerated() {
            let label = rangeAgeLabel(text: rangeAge)
            containerView.addSubview(label)

            if index == 0 {
                label.pin.left(24)
                    .top(to: divider.edge.bottom)
                    .marginTop(24)
                    .width(Constants.ageLabelWidth)
                    .height(Constants.labelHeight)
            } else if let previousLabel {
                label.pin.left(24)
                    .top(to: previousLabel.edge.bottom)
                    .marginTop(24)
                    .width(Constants.ageLabelWidth)
                    .height(Constants.labelHeight)
            }

            label.sizeToFit()
            previousLabel = label
        }
    }

    func configureGenderStats(models: [RoundedDiagramCellModel]) {
        let totalCount = models.count

        guard totalCount > 0 else {
            menGenderStatsView.set(circleColor: Colors.red, gender: "Мужчины", percent: "0%")
            womenGenderStatsView.set(circleColor: Colors.apricot, gender: "Женщины", percent: "0%")
            diagramView?.setProgress(0)
            return
        }

        let menCount = models.filter { $0.sex == .men }.count

        let menPercent = Int(Double(menCount) / Double(totalCount) * 100)
        let womenPercent = 100 - menPercent

        menGenderStatsView.set(circleColor: Colors.red, gender: "Мужчины", percent: "\(menPercent)%")
        womenGenderStatsView.set(circleColor: Colors.apricot, gender: "Женщины", percent: "\(womenPercent)%")
        diagramView?.setProgress(CGFloat(Double(womenPercent) / 100), animated: true)
    }

    func configureAgeStats(modelsByAgeRange: [[RoundedDiagramCellModel]]) {
        guard ageStatsViews.isEmpty else {
            for (index, groupedModels) in modelsByAgeRange.enumerated() {
                ageStatsViews[index].set(models: groupedModels)
            }
            return
        }
        for (index, groupedModels) in modelsByAgeRange.enumerated() {
            let ageStatsView = AgeStatsView()
            ageStatsViews.append(ageStatsView)
            containerView.addSubview(ageStatsView)

            if index == 0 {
                ageStatsView.pin.top(to: divider.edge.bottom).left(98).right()
                    .height(Constants.ageStatsHeight).marginTop(20)
            } else if let previousAgeStatsView {
                ageStatsView.pin.top(to: previousAgeStatsView.edge.bottom).left(98).right()
                    .height(Constants.ageStatsHeight).marginTop(12)
            }

            ageStatsView.set(models: groupedModels)
            previousAgeStatsView = ageStatsView
        }
    }

    func rangeAgeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Fonts.gilroySemiBold(size: 15).font
        return label
    }

}
