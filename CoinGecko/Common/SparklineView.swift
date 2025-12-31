//
//  SparklineView.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 08.08.2025.
//

import UIKit

final class SparklineView: UIView {

    var prices: [Double] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    func reset() {
        prices = []
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard rect.width > 0, rect.height > 0 else { return }

        context.setFillColor(UIColor.white.cgColor)
        context.fill(bounds)

        let width = rect.width
        let height = rect.height
        let lineColor = prices.first ?? 0 >= prices.last ?? 0 ? UIColor.red : UIColor.green

        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(1)

        let points = calculatePoints(prices: prices, width: width, height: height)

        if points.count > 2 {
            context.move(to: points[0])

            points.indices.forEach { index in
                if index == 0 {
                    return
                } else {
                    let prevPoint = points[points.index(before: index)]
                    let actualPoint = points[index]
                    let midPoint = CGPoint(x: (prevPoint.x + actualPoint.x) / 2, y: (prevPoint.y + actualPoint.y) / 2)
                    context.addQuadCurve(to: midPoint, control: prevPoint)
                }
            }
        }
        context.strokePath()
    }

    private func calculatePoints(prices: [Double], width: Double, height: Double) -> [CGPoint] {
        let minPrice = prices.min() ?? 0
        let maxPrice = prices.max() ?? 0

        let stepX = width / Double(max(self.prices.count - 2, 2))
        let stepY = maxPrice == minPrice ? 0 : Double(height) / Double(maxPrice - minPrice)

        let points = prices.enumerated().compactMap { index, price in
            CGPoint(x: stepX * Double(index), y: height - ((price - minPrice) * stepY))
        }
        return points
    }
}
