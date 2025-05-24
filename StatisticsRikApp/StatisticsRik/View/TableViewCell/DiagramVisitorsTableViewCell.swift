//
//  DiagramVisitorsTableViewCell.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 23.05.2025.
//

import Foundation
import Core
import UIKit

final class DiagramVisitorsTableViewCell: UITableViewCell, ReusableView {

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = Colors.white
        return view
    }()


    private var diagramView: LinearDiagramView?
    private var dateLabels: [UILabel] = []

    private var horizontalBeansView: [BeansView] = []
    private let verticalBeanView = BeansView()

    private let infoView = VisitorDiagramInfoView()

    private var labelsMidX: [CGFloat] = []

    private var visitors: [Int] = []
    private var periodLabels: [String] = []

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        verticalBeanView.isHidden = true
        infoView.isHidden = true
        diagramView?.removeFromSuperview()
        diagramView = nil
    }

    // MARK: - Configuration

    func set(dateLabelsText: [String], visitors: [Int], periodLabels: [String]) {
        self.visitors = visitors
        self.periodLabels = periodLabels

        setupViews()
        addDateLabels(dateLabelsText)
        addDiagramView()
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouch(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleTouch(touches)
    }

}

private extension DiagramVisitorsTableViewCell {

    func handleTouch(_ touches: Set<UITouch>) {
        guard let point = touches.first?.location(in: containerView) else { return }
        displayInfoView(at: point)
    }

    // MARK: - UI Setup

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func setupViews() {
        contentView.addSubview(containerView)
        containerView.pin.all().marginHorizontal(16)

        addHorizontalBeans()
        addVerticalBeanView()

        containerView.addSubview(infoView)
    }

    func addVerticalBeanView() {
        guard verticalBeanView.superview == nil else { return }

        verticalBeanView.isHidden = true
        containerView.addSubview(verticalBeanView)

        verticalBeanView.pin
            .top(5).left().bottom(37).width(1)
        verticalBeanView.set(alignment: .verical, color: Colors.red)
    }

    func addDateLabels(_ labels: [String]) {
        guard dateLabels.isEmpty else {
            for index in dateLabels.indices {
                dateLabels[index].text = labels[index]
            }
            return
        }
        let labelWidth: CGFloat = 35
        let labelHeight: CGFloat = 11
        let sideMargin: CGFloat = 31
        let availableWidth = containerView.bounds.width - sideMargin * 2
        let spacing = (availableWidth - (CGFloat(labels.count) * labelWidth)) / CGFloat(labels.count - 1)

        for (index, text) in labels.enumerated() {
            let label = createDateLabel(with: text)
            dateLabels.append(label)
            containerView.addSubview(label)
            let xPosition = sideMargin + CGFloat(index) * (labelWidth + spacing)
            label.pin.bottom(10).width(labelWidth).height(labelHeight).left(xPosition)
            labelsMidX.append(label.frame.midX - 15)
        }
    }

    func addDiagramView() {
        diagramView = LinearDiagramView()
        guard let diagramView = diagramView else { return }
        containerView.addSubview(diagramView)
        diagramView.pin.all().margin(10, 15, 32, 32.39)
        diagramView.set(values: visitors, midXs: labelsMidX)
    }

    func addHorizontalBeans() {
        guard horizontalBeansView.isEmpty else { return }
        let yPositions: [CGFloat] = [32, 107, 179]
        let width = containerView.frame.width - 15 - 32.39
        for y in yPositions {
            let beanView = BeansView()
            containerView.addSubview(beanView)
            beanView.pin.left(15).bottom(y).height(1).width(width)
            beanView.set(alignment: .horizontal, color: Colors.gray2)
            horizontalBeansView.append(beanView)
        }
    }

    // MARK: - Info View Display

    func displayInfoView(at point: CGPoint) {
        let localPoint = convert(point, to: containerView)
        guard var nearestX = labelsMidX.min(by: { abs($0 - localPoint.x) < abs($1 - localPoint.x) }) else { return }
        guard let index = labelsMidX.firstIndex(of: nearestX) else { return }
        nearestX += 14.5

        guard let diagramView = diagramView else { return }
        containerView.bringSubviewToFront(diagramView)

        pinInfoView(amountVisitors: visitors[index], index: index, nearestX: nearestX)

        verticalBeanView.pin.left(nearestX)
        verticalBeanView.isHidden = false
        infoView.isHidden = false
    }

    func pinInfoView(amountVisitors: Int, index: Int, nearestX: CGFloat) {
        containerView.bringSubviewToFront(infoView)

        let formatString = LocalizableStringsDict.visitorsFormatString
        let text = String(format: formatString, amountVisitors)
        let font = Fonts.gilroySemiBold(size: 15).font
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        let widthInfoView = textSize.width + 32

        let divider: CGFloat = (index == 0) ? 4 : 2
        let padding = widthInfoView / divider
        let gap = (index == labelsMidX.count - 1) ? labelsMidX[index - 1] - padding : nearestX - padding

        infoView.pin.height(72).width(widthInfoView).top().left().margin(9, gap, 0, 0)
        infoView.set(visitors: visitors[index], dateText: periodLabels[index])
    }

    // MARK: - Helpers

    func createDateLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = Colors.silver
        label.font = Fonts.gilroyMedium(size: 11).font
        return label
    }

}
