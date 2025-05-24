//
//  BeansView.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 24.05.2025.
//

import Foundation
import UIKit
import Core
import PinLayout

enum BeansViewAlignment {
    case horizontal
    case verical
}


final class BeansView: UIView {

    func set(alignment: BeansViewAlignment, color: UIColor) {
        switch alignment {
            case .horizontal:
                pinHorizontalBeans(color: color)
            case .verical:
                pinVericalBeans(color: color)
        }
    }

}

private extension BeansView {

    func pinHorizontalBeans(color: UIColor) {
        let spacing: CGFloat = 5
        let edgeWidth: CGFloat = 3.5
        let middleWidth: CGFloat = 6.5
        let height: CGFloat = 1

        let availableWidth = bounds.width
        var count = 2
        var totalWidth = edgeWidth * 2

        while true {
            let newTotal = totalWidth + middleWidth + spacing
            if newTotal > availableWidth {
                break
            }
            totalWidth += middleWidth + spacing
            count += 1
        }

        let middleCount = max(count - 2, 0)
        let totalElements = middleCount + 2

        var x = 0.0
        for i in 0..<totalElements {
            let isEdge = (i == 0 || i == totalElements - 1)
            let width = isEdge ? edgeWidth : middleWidth
            let line = createBeanView(color: color)
            addSubview(line)
            line.pin.bottom().left(x).width(width).height(height)
            x += width + spacing
        }
    }

    func pinVericalBeans(color: UIColor) {
        let width: CGFloat = 1
        let height: CGFloat = 6.5
        let spacing: CGFloat = 11.5
        let topMargin = frame.minY

        let yPositions = stride(from: topMargin + 6.5, to: frame.maxY, by: spacing)

        for y in yPositions {
            let beanView = createBeanView(color: color)
            addSubview(beanView)

            beanView.pin
                .top(y)
                .left()
                .width(width)
                .height(height)
        }
    }

    func createBeanView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 0.5
        return view
    }

}
