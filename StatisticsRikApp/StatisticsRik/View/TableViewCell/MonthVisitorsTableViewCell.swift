//
//  MonthVisitorsTableViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation
import Core
import UIKit
import PinLayout
import Core

final class MonthVisitorsTableViewCell: UITableViewCell, ReusableView {

    private lazy var containerView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = Colors.white
        return containerView
    }()

    private var diagramView: CubicDiagramView?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroyBold(size: 20).font
        return label
    }()

    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroyMedium(size: 15).font
        label.numberOfLines = 0
        label.layer.opacity = 0.5
        return label
    }()

    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.separation
        return divider
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner,
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]
        divider.removeFromSuperview()
        diagramView?.removeFromSuperview()
        diagramView = nil
    }

    func set(model: MonthVisitorsCellModel) {
        titleImageView.image = model.titleImage
        descriptionLabel.text = model.description
        titleLabel.text = model.title

        switch (model.isFirst, model.isLast) {
            case (true, true):
                containerView.layer.maskedCorners = [
                    .layerMinXMinYCorner, .layerMaxXMinYCorner,
                    .layerMinXMaxYCorner, .layerMaxXMaxYCorner
                ]
            case (true, false):
                containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                configureDivider()
            case (false, true):
                containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default:
                containerView.layer.maskedCorners = []
                configureDivider()
        }

        diagramView = CubicDiagramView()
        pinViews()
        diagramView?.set(values: model.monthVisiotsChange, diagramColor: model.diagramColor)

    }

}

private extension MonthVisitorsTableViewCell {

    func pinViews() {
        contentView.addSubview(containerView)
        containerView.pin.all().marginHorizontal(16)


        guard let diagramView else { return }
        containerView.addSubview(diagramView)
        diagramView.pin.left().top().bottom().width(95).margin(16, 20, 16, 0)

        containerView.addSubview(titleLabel)
        titleLabel.pin.top().after(of: diagramView).right().height(25).margin(16, 20, 0, 0)
        titleLabel.sizeToFit()


        containerView.addSubview(titleImageView)
        titleImageView.pin.after(of: titleLabel).vCenter(to: titleLabel.edge.vCenter)
            .width(16).height(16)
            .marginLeft(2)

        containerView.addSubview(descriptionLabel)
        descriptionLabel.pin.below(of: titleImageView).bottom().right().after(of: diagramView)
            .margin(7, 20, 16, 20)
    }

    func configureDivider() {
        containerView.addSubview(divider)
        divider.pin.bottom(-2).left().right().height(0.5)
    }

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

}
