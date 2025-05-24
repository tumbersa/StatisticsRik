//
//  VisitorTableViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import Core
import UIKit
import PinLayout

final class VisitorTableViewCell: UITableViewCell, ReusableView {

    private lazy var containerView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 14
        containerView.backgroundColor = Colors.white
        return containerView
    }()

    private lazy var avatarImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 19
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Colors.background
        return imageView
    }()

    private lazy var onlineIndicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = 5
        return view
    }()

    private lazy var onlineIndicator: UIView = {
        let onlineIndicator = UIView()
        onlineIndicator.layer.cornerRadius = 4
        onlineIndicator.backgroundColor = Colors.green
        return onlineIndicator
    }()


    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.gilroySemiBold(size: 15).font
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.chevronRight
        return imageView
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

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        UIView.animate(withDuration: 0.2) {
            self.containerView.alpha = highlighted ? 0.5 : 1.0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner,
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]
        divider.isHidden = true
        onlineIndicatorContainer.isHidden = true
    }

    func set(model: VisitorCellModel) {
        userLabel.text = model.text
        if let avatarImageData =  model.avatarImageData {
            avatarImageView.image = UIImage(data: avatarImageData)
        }

        pinViews()
        configureDivider()
        switch (model.isFirst, model.isLast) {
            case (true, true):
                containerView.layer.maskedCorners = [
                    .layerMinXMinYCorner, .layerMaxXMinYCorner,
                    .layerMinXMaxYCorner, .layerMaxXMaxYCorner
                ]
            case (true, false):
                containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                divider.isHidden = false
            case (false, true):
                containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default:
                containerView.layer.maskedCorners = []
                divider.isHidden = false
        }

        model.isOnline ? configureOnlineIndicator() : { onlineIndicatorContainer.isHidden = true }()
    }

}

private extension VisitorTableViewCell {

    func pinViews() {
        contentView.addSubview(containerView)
        containerView.pin.all().marginHorizontal(16)

        containerView.addSubview(avatarImageView)
        avatarImageView.pin.left().top().bottom().width(38)
            .margin(12, 16, 12, 0)

        containerView.addSubview(chevronImageView)
        chevronImageView.pin.right(24).vCenter(to: avatarImageView.edge.vCenter)
            .height(24).width(24)

        containerView.addSubview(userLabel)
        userLabel.pin.after(of: avatarImageView)
            .right(to: chevronImageView.edge.left)
            .marginLeft(12)
        userLabel.sizeToFit()
        userLabel.pin.vCenter(to: avatarImageView.edge.vCenter)

    }

    func configureOnlineIndicator() {
        contentView.addSubview(onlineIndicatorContainer)
        onlineIndicatorContainer.pin
            .bottom(to: avatarImageView.edge.bottom)
            .right(to: avatarImageView.edge.right)
            .width(10).height(10)

        onlineIndicatorContainer.addSubview(onlineIndicator)
        onlineIndicator.pin.center().width(8).height(8)
        onlineIndicatorContainer.isHidden = false
    }

    func configureDivider() {
        containerView.addSubview(divider)
        divider.pin.bottom().left(to: userLabel.edge.left).right(1).height(0.5)
        divider.isHidden = true
    }

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

}
