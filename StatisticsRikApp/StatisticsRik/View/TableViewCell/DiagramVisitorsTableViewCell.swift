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
    private var labelsMidX: [CGFloat] = []
    private var visitors: [Int] = []
    private var periodLabels: [String] = []
    private var horizontalBeansView: [BeansView] = []

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
        containerView.subviews.forEach { $0.removeFromSuperview() }
        labelsMidX.removeAll()
        visitors.removeAll()
    }

    // MARK: - Configuration

    func set(models: [DiagramVisitorsCellModel], currentFilteredPeriod: FilterPeriod) {
        setupViews()
        addHorizontalLines()
        addDateLabels(currentFilteredPeriod.getLastSevenPeriods())

        addDiagramView()

        visitors = VisitorStatisticsCalculator.calculateVisitorCounts(from: models, for: currentFilteredPeriod)
        periodLabels = DateLabelFormatter().generateLabels(for: currentFilteredPeriod)
        guard let diagramView = diagramView else { return }
        diagramView.set(values: visitors, midXs: labelsMidX)
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
    }

    func addDateLabels(_ labels: [String]) {
        let labelWidth: CGFloat = 35
        let labelHeight: CGFloat = 11
        let sideMargin: CGFloat = 31
        let availableWidth = containerView.bounds.width - sideMargin * 2
        let spacing = (availableWidth - (CGFloat(labels.count) * labelWidth)) / CGFloat(labels.count - 1)

        for (index, text) in labels.enumerated() {
            let label = createDateLabel(with: text)
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
    }

    func addHorizontalLines() {
//        guard horizontalBeansView.isEmpty else { return }
//        let beanView = BeansView()
//        containerView.addSubview(beanView)
        let leftInset: CGFloat = 15
        let rightInset: CGFloat = 25
        let spacing: CGFloat = 5
        let edgeWidth: CGFloat = 3.5
        let middleWidth: CGFloat = 6.5
        let height: CGFloat = 1
        let yPositions: [CGFloat] = [32, 107, 179]

        let availableWidth = contentView.bounds.width - leftInset - rightInset
        var count = 2
        var totalWidth = edgeWidth * 2

        while true {
            let newTotal = totalWidth + middleWidth + spacing
            if newTotal + rightInset + leftInset > availableWidth {
                break
            }
            totalWidth += middleWidth + spacing
            count += 1
        }

        let middleCount = max(count - 2, 0)
        let totalElements = middleCount + 2

        for y in yPositions {
            var x = leftInset
            for i in 0..<totalElements {
                let isEdge = (i == 0 || i == totalElements - 1)
                let width = isEdge ? edgeWidth : middleWidth
                let line = createLineView()
                containerView.addSubview(line)
                line.pin.bottom(y).left(x).width(width).height(height)
                x += width + spacing
            }
        }
    }

    // MARK: - Info View Display

    func displayInfoView(at point: CGPoint) {
        guard let diagramView = diagramView else { return }
        let localPoint = convert(point, to: containerView)
        guard var nearestX = labelsMidX.min(by: { abs($0 - localPoint.x) < abs($1 - localPoint.x) }) else { return }
        guard let index = labelsMidX.firstIndex(of: nearestX) else { return }

        containerView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }

        let infoView = VisitorDiagramInfoView()
        infoView.tag = 999
        containerView.addSubview(infoView)
        nearestX += 14.5

        let formatString = LocalizableStringsDict.visitorsFormatString
        let text = String(format: formatString, visitors[index])
        let font = Fonts.gilroySemiBold(size: 15).font
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        let widthInfoView = textSize.width + 32

        let divider: CGFloat = (index == 0) ? 4 : 2
        let padding = widthInfoView / divider
        let gap = (index == labelsMidX.count - 1) ? labelsMidX[index - 1] - padding : nearestX - padding

        infoView.pin.height(72).width(widthInfoView).top().left().margin(9, gap, 0, 0)
        infoView.set(visitors: visitors[index], dateText: periodLabels[index])

        let width: CGFloat = 1
        let height: CGFloat = 6.5 // равна ширине middleWidth из horizontalBeans
        let spacing: CGFloat = 11.5 // расстояние между линиями (примерное)
        let topMargin = diagramView.frame.minY

        let yPositions = stride(from: topMargin + 5, to: diagramView.frame.maxY, by: spacing)

        for y in yPositions {
            let view = UIView()
            view.backgroundColor = Colors.red
            view.layer.cornerRadius = 0.5
            view.tag = 999
            containerView.addSubview(view)

            view.pin
                .top(y)
                .left(nearestX)
                .width(width)
                .height(height)
        }

        containerView.bringSubviewToFront(diagramView)
        containerView.bringSubviewToFront(infoView)
    }

    // MARK: - Helpers

    func createLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.gray2
        view.layer.cornerRadius = 0.5
        return view
    }

    func createDateLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = Colors.silver
        label.font = Fonts.gilroyMedium(size: 11).font
        return label
    }

}
