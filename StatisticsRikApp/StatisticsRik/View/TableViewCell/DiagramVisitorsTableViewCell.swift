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

    private lazy var containerView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = Colors.white
        return containerView
    }()

    private var diagramView: LinearDiagramView?

    private var previousDateLabel: UILabel?

    private var labelsMidX: [CGFloat] = []

    private var visitors: [Int] = []
    private var periodLabels: [String] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        //print(touches.first?.location(in: containerView))
        let point = touches.first?.location(in: containerView) ?? CGPoint()
        pinVerticalBeanViews(at: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        //print(touches.first?.location(in: containerView))
        let point = touches.first?.location(in: containerView) ?? CGPoint()
        pinVerticalBeanViews(at: point)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        labelsMidX = []
        visitors = []
    }

    func set(models: [DiagramVisitorsCellModel], currentFilteredPeriod: FilterPeriod) {
        pinViews()
        pinHorizontalBeanViews()
        pinDateLabels(currentFilteredPeriod.getLastSevenPeriods())

        diagramView = LinearDiagramView()
        guard let diagramView else { return }
        containerView.addSubview(diagramView)
        diagramView.pin.all()
            .margin(10, 15, 32, 32.39)
        visitors = getUserCounts(models: models, currentFilteredPeriod: currentFilteredPeriod)
        diagramView.set(values: visitors, midXs: labelsMidX)
        periodLabels = getPeriodLabels(currentFilteredPeriod: currentFilteredPeriod)
    }

}

private extension DiagramVisitorsTableViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func pinViews() {
        contentView.addSubview(containerView)
        containerView.pin.all().marginHorizontal(16)
    }

    func pinDateLabels(_ models: [String]) {
        layoutIfNeeded()
        let labelWidth: CGFloat = 35
        let labelHeight: CGFloat = 11
        let sideMargin: CGFloat = 31
        let availableWidth = containerView.bounds.width - sideMargin * 2
        let spacingCount = CGFloat(models.count - 1)

        guard models.count > 1 else { return }

        let totalLabelsWidth = CGFloat(models.count) * labelWidth
        let spacing = (availableWidth - totalLabelsWidth) / spacingCount

        for (index, model) in models.enumerated() {
            let label = dateLabel(text: model)
            containerView.addSubview(label)

            let xPosition = sideMargin + CGFloat(index) * (labelWidth + spacing)
            label.pin
                .bottom(10)
                .width(labelWidth)
                .height(labelHeight)
                .left(xPosition)
            labelsMidX.append(label.frame.midX - 15)
        }
    }

    func pinVerticalBeanViews(at touchPoint: CGPoint) {
        guard let diagramView else { return }

        // Переводим точку касания в координаты containerView
        let localPoint = convert(touchPoint, to: containerView)

        // Ищем ближайший midX
        guard var nearestX = labelsMidX.min(by: { abs($0 - localPoint.x) < abs($1 - localPoint.x) }) else { return }
        let index = labelsMidX.firstIndex(of: nearestX) ?? -1
        print(visitors[index])
        print(periodLabels[index])

        containerView.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }

        let infoView = VisitorDiagramInfoView()
        infoView.tag = 999
        containerView.addSubview(infoView)
        nearestX += 14.5


        let formatString = LocalizableStringsDict.visitorsFormatString
        let text = String(format: formatString, visitors[index])
        let font = Fonts.gilroySemiBold(size: 15).font

        // Создаем атрибутированную строку с нужным шрифтом
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = (text as NSString).size(withAttributes: attributes)

        // Вычисляем общую ширину: ширина текста + отступы (32)
        let widthInfoView = textSize.width + 32
        print(widthInfoView)

        let divider: CGFloat
        if index == 0 {
            divider = 4
        } else {
            divider = 2
        }
        let padding = widthInfoView / divider
        let gap =  index == labelsMidX.count-1 ? labelsMidX[index-1] - padding : nearestX - padding

        // Устанавливаем размеры infoView
        infoView.pin.height(72).width(widthInfoView).top().left()
            .margin(9, gap, 0, 0)
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

    func pinHorizontalBeanViews() {
        let leftInset: CGFloat = 15
        let rightInset: CGFloat = 25
        let spacing: CGFloat = 5
        let edgeWidth: CGFloat = 3.5
        let middleWidth: CGFloat = 6.5
        let height: CGFloat = 1
        let yPosition: [CGFloat] = [32, 107, 179]

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

        for y in yPosition {
            var x = leftInset
            for i in 0..<totalElements {
                let isEdge = (i == 0 || i == totalElements - 1)
                let width = isEdge ? edgeWidth : middleWidth

                let view = beanView()
                containerView.addSubview(view)
                view.pin
                    .bottom(y)
                    .left(x)
                    .width(width)
                    .height(height)

                x += width + spacing
            }
        }
    }

    func beanView() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.gray2
        view.layer.cornerRadius = 0.5
        return view
    }

    func dateLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = Colors.silver
        label.font = Fonts.gilroyMedium(size: 11).font
        return label
    }

    func getUserCounts(models: [DiagramVisitorsCellModel], currentFilteredPeriod: FilterPeriod) -> [Int] {
        let calendar = Calendar.current

        let now = Date()

        var result = [Int](repeating: 0, count: 7)

        for i in 0..<7 {
            let (startDate, endDate): (Date, Date)

            switch currentFilteredPeriod {
            case .day:
                guard let dayStart = calendar.date(byAdding: .day, value: -i, to: now)?.startOfDay(),
                      let dayEnd = calendar.date(byAdding: .day, value: -i + 1, to: now)?.startOfDay() else { continue }
                startDate = dayStart
                endDate = dayEnd

            case .week:
                guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -i, to: now)?.startOfWeek(),
                      let weekEnd = calendar.date(byAdding: .weekOfYear, value: -i + 1, to: now)?.startOfWeek() else { continue }
                startDate = weekStart
                endDate = weekEnd

            case .month:
                guard let monthStart = calendar.date(byAdding: .month, value: -i, to: now)?.startOfMonth(),
                      let monthEnd = calendar.date(byAdding: .month, value: -i + 1, to: now)?.startOfMonth() else { continue }
                startDate = monthStart
                endDate = monthEnd
            }

            let filteredUsers = models.filter { $0.date >= startDate && $0.date < endDate }
            let uniqueUserIds = Set(filteredUsers.map { $0.userId })
            result[6 - i] = uniqueUserIds.count
        }

        return result
    }

    func getPeriodLabels(currentFilteredPeriod: FilterPeriod, referenceDate: Date = Date()) -> [String] {
        let calendar = Calendar.current
        var labels = [String](repeating: "", count: 7)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")

        for i in 0..<7 {
            let label: String

            switch currentFilteredPeriod {
            case .day:
                // День: "22 мая"
                if let date = calendar.date(byAdding: .day, value: -i, to: referenceDate) {
                    dateFormatter.dateFormat = "d MMMM"
                    label = dateFormatter.string(from: date)
                } else {
                    label = ""
                }

            case .week:
                // Неделя: "12–18 мая"
                if let weekStart = calendar.date(byAdding: .weekOfYear, value: -i, to: referenceDate)?.startOfWeek(),
                   let weekEnd = calendar.date(byAdding: .weekOfYear, value: -i, to: referenceDate)?.endOfWeek() {
                    let startFormatter = DateFormatter()
                    startFormatter.locale = Locale(identifier: "ru_RU")
                    startFormatter.dateFormat = "d"

                    let endFormatter = DateFormatter()
                    endFormatter.locale = Locale(identifier: "ru_RU")
                    endFormatter.dateFormat = "d MMMM"

                    let startStr = startFormatter.string(from: weekStart)
                    let endStr = endFormatter.string(from: weekEnd)
                    label = "\(startStr)–\(endStr)"
                } else {
                    label = ""
                }

            case .month:
                // Месяц: "Май"
                if let monthStart = calendar.date(byAdding: .month, value: -i, to: referenceDate)?.startOfMonth() {
                    dateFormatter.dateFormat = "LLLL"
                    label = dateFormatter.string(from: monthStart).capitalized // С большой буквы
                } else {
                    label = ""
                }
            }

            labels[6 - i] = label
        }

        return labels
    }

}
