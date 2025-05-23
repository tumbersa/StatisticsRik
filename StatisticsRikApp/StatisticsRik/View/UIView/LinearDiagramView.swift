//
//  LinearDiagramView.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 23.05.2025.
//

import Foundation
import UIKit
import Core

final class LinearDiagramView: UIView {

    // MARK: - Constants

    private let circleRadius: CGFloat = 5

    // MARK: - Private Properties

    private let bezierPath = UIBezierPath()
    private var points: [CGPoint] = []
    private var adjustedPoints: [CGPoint] = []

    // MARK: - Public Methods

    func set(values: [Int], midXs: [CGFloat]) {
        reset()

        points = calculatePoints(from: values, midXs: midXs)
        adjustedPoints = calculateAdjustedPoints(from: points)

        drawLines(with: adjustedPoints, color: Colors.red)
    }

}

// MARK: - Private Methods

private extension LinearDiagramView {

    func reset() {
        bezierPath.removeAllPoints()
        points = []
        adjustedPoints = []
        layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
    }

    func calculatePoints(from values: [Int], midXs: [CGFloat]) -> [CGPoint] {
        guard
            let maxVal = values.max(),
            let minVal = values.min(),
            values.count == midXs.count
        else {
            return []
        }

        let maxDifference = CGFloat(maxVal - minVal)
        let padding = calculateDynamicPadding(for: maxDifference)
        let usableHeight = frame.height - padding * 2
        let yCoefficient = maxDifference > 0 ? usableHeight / maxDifference : 0

        return values.enumerated().map { index, value in
            let normalizedValue = CGFloat(value - minVal)
            let x = midXs[index]
            let y = frame.height - padding - normalizedValue * yCoefficient
            return CGPoint(x: x, y: y)
        }
    }

    func calculateAdjustedPoints(from points: [CGPoint]) -> [CGPoint] {
        guard points.count >= 2 else { return points }

        var result: [CGPoint] = []

        for index in points.indices {
            switch index {
                case 0:
                    result.append(adjustPoint(from: points[1], to: points[0]))
                case points.count - 1:
                    result.append(adjustPoint(from: points[index - 1], to: points[index]))
                default:
                    result.append(adjustPoint(from: points[index - 1], to: points[index]))
                    result.append(adjustPoint(from: points[index + 1], to: points[index]))
            }
        }

        return result
    }

    func adjustPoint(from first: CGPoint, to second: CGPoint) -> CGPoint {
        let direction = CGVector(dx: second.x - first.x, dy: second.y - first.y)
        let length = hypot(direction.dx, direction.dy)

        guard length > 0 else { return second }

        let unitVector = CGVector(dx: direction.dx / length, dy: direction.dy / length)

        return CGPoint(
            x: second.x - unitVector.dx * circleRadius,
            y: second.y - unitVector.dy * circleRadius
        )
    }

    func calculateDynamicPadding(for difference: CGFloat) -> CGFloat {
        let basePadding: CGFloat = 5.0
        let maxPadding = frame.height / 2.0

        guard difference > 0 else { return maxPadding }

        let sensitivity: CGFloat = 0.5
        let adjustedPadding = maxPadding * (1 - min(1, difference * sensitivity / maxPadding))

        return max(basePadding, adjustedPadding)
    }

    func drawLines(with points: [CGPoint], color: UIColor) {
        for (index, point) in points.enumerated() {
            if index.isMultiple(of: 2) {
                bezierPath.move(to: point)
            } else {
                bezierPath.addLine(to: point)
            }
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)

        addCircleMarkers(color: color)
        animatePath(layer: shapeLayer)
    }

    func animatePath(layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        layer.add(animation, forKey: "line")
    }

    func addCircleMarkers(color: UIColor) {
        for point in points {
            let circleLayer = CAShapeLayer()
            circleLayer.bounds = CGRect(x: 0, y: 0, width: circleRadius * 2, height: circleRadius * 2)
            circleLayer.cornerRadius = circleRadius
            circleLayer.borderWidth = 3
            circleLayer.borderColor = color.cgColor
            circleLayer.backgroundColor = UIColor.clear.cgColor
            circleLayer.fillColor = Colors.white.cgColor
            circleLayer.position = point
            layer.addSublayer(circleLayer)
        }
    }

}
