//
//  CubicDiagramView.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 23.05.2025.
//

import Foundation
import UIKit
import Core

final class CubicDiagramView: UIView {

    private let bezierPath = UIBezierPath()
    private let circleLayer = CAShapeLayer()
    private let circleRadius: CGFloat = 5

    private var points: [CGPoint] = []
    private var adjustedPoints: [CGPoint] = []

    func set(values: [Int], diagramColor: UIColor) {
        guard !values.isEmpty else { return }

        reset()

        points = calculatePoints(from: values)
        adjustedPoints = adjustLastPointIfNeeded(points)

        drawCurve(with: adjustedPoints, color: diagramColor)
    }

}

private extension CubicDiagramView {

    func reset() {
        bezierPath.removeAllPoints()
        points = []
        adjustedPoints = []
        layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
    }

    func calculatePoints(from values: [Int]) -> [CGPoint] {
        let maxVal = CGFloat(values.max() ?? 0)
        let minVal = CGFloat(values.min() ?? 0)
        let maxDifference = maxVal - minVal

        let dynamicPadding = calculateDynamicPadding(for: maxDifference)
        let xStep = frame.width / CGFloat(max(values.count - 1, 1))
        let yCoefficient = (frame.height - dynamicPadding * 2) / (maxDifference == 0 ? 2 : maxDifference)

        return values.enumerated().map { index, value in
            let x = CGFloat(index) * xStep
            let y = frame.height - dynamicPadding - CGFloat(value) * yCoefficient
            return CGPoint(x: x, y: y)
        }
    }

    func calculateDynamicPadding(for difference: CGFloat) -> CGFloat {
        let basePadding: CGFloat = 5.0
        let maxPossiblePadding = frame.height / 2.0

        guard difference > 0 else { return maxPossiblePadding }

        let sensitivityFactor: CGFloat = 0.5
        let adjusted = maxPossiblePadding * (1 - min(1, difference * sensitivityFactor / maxPossiblePadding))

        return max(basePadding, adjusted)
    }

    func adjustLastPointIfNeeded(_ originalPoints: [CGPoint]) -> [CGPoint] {
        guard originalPoints.count >= 2 else { return originalPoints }

        var adjusted = originalPoints
        let last = originalPoints.last!
        let secondLast = originalPoints[originalPoints.count - 2]

        let direction = CGVector(dx: last.x - secondLast.x, dy: last.y - secondLast.y)
        let length = hypot(direction.dx, direction.dy)

        guard length > 0 else { return originalPoints }

        let unitVector = CGVector(dx: direction.dx / length, dy: direction.dy / length)
        adjusted[adjusted.count - 1] = CGPoint(
            x: last.x - unitVector.dx * circleRadius,
            y: last.y - unitVector.dy * circleRadius
        )

        return adjusted
    }

    func drawCurve(with points: [CGPoint], color: UIColor) {
        let config = BezierConfiguration()
        let controlPoints = config.configureControlPoints(data: self.points)

        for (index, point) in points.enumerated() {
            if index == 0 {
                bezierPath.move(to: point)
            } else {
                let segment = controlPoints[index - 1]
                bezierPath.addCurve(to: point, controlPoint1: segment.firstControlPoint, controlPoint2: segment.secondControlPoint)
            }
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = .none
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)

        animateCurveDrawing(layer: shapeLayer, color: color)
    }

    func animateCurveDrawing(layer: CAShapeLayer, color: UIColor) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.addCircleMarker(color: color)
            self?.fadeInCircle()
        }
        layer.add(animation, forKey: "drawCurve")
        CATransaction.commit()
    }

    func fadeInCircle() {
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        fade.duration = 0.3
        circleLayer.add(fade, forKey: "fadeIn")
    }

    func addCircleMarker(color: UIColor) {
        guard let point = points.last else { return }

        circleLayer.bounds = CGRect(x: 0, y: 0, width: circleRadius * 2, height: circleRadius * 2)
        circleLayer.cornerRadius = circleRadius
        circleLayer.borderWidth = 3
        circleLayer.borderColor = color.cgColor
        circleLayer.backgroundColor = UIColor.clear.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.position = point

        layer.addSublayer(circleLayer)
    }

}
