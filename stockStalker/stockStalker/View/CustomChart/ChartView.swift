//
//  ChartView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 2/24/25.
//

import UIKit

final class ChartView: UIView {
    
    private let _beizierPath = UIBezierPath()
    
    private var _chartInfo: ChartEntities? {
        didSet {
            guard let _entities = _chartInfo else { return }
            var rates = [CGFloat]()
            
            for chartInfo in _entities.chart {
                rates.append(chartInfo.rate.makeCGFloat)
            }
            _rates = rates
        }
    }
    
    private var _rates = [CGFloat]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setEntities(_ entities: ChartEntities?) {
        self._chartInfo = entities
    }
    
    private func removeExistingLayer(tagNum: Int) {
        self.layer.sublayers?.forEach { layer in
            if let taggedLayer = layer as? TaggedLayer {
                if taggedLayer.tag == tagNum {
                    taggedLayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    private func calculateLocationX(rect: CGRect) -> [CGFloat] {
        var positionX = [CGFloat]()
        let width = rect.size.width
        let x = width / _rates.count.makeCGFloat
        
        for (idx, _) in _rates.enumerated() {
            let spotX = x * idx.makeCGFloat
            positionX.append(spotX)
        }
        
        return positionX
    }
    
    private func calculateLocationY(rect: CGRect) -> [CGFloat] {
        let height = rect.size.height
        var positionY = [CGFloat]()
        let firstYValue = _rates[0]
        let maxminY = _rates.reduce((firstYValue, firstYValue)) { partialResult, currentValue in
            let max = currentValue > partialResult.0 ? currentValue : partialResult.0
            let min = currentValue < partialResult.1 ? currentValue : partialResult.1
            return (max,min)
        }
        
        let minY = maxminY.1
        let range = maxminY.0 - minY
        
        _rates.forEach {
            let spotY = $0 - minY
            let yLocation = height * spotY / range
            positionY.append(yLocation)
        }
        
        return positionY
    }
    
    override func draw(_ rect: CGRect) {
        guard !_rates.isEmpty else { return }
        let tag  = 100
        removeExistingLayer(tagNum: tag)

        let taggedLayer = TaggedLayer(tag: tag)
        let positionY = calculateLocationY(rect: rect)
        let positionX = calculateLocationX(rect: rect)
       
        var locationXY = [CGPoint]()
        
        zip(positionX, positionY).forEach { locationXY.append(CGPoint(x: $0, y: $1)) }
        
        for (idx,location) in locationXY.enumerated() {
            if idx == 0 {
                _beizierPath.move(to: location)
                continue
            }
            if idx == locationXY.count - 1 {
                _beizierPath.addLine(to: location)
                _beizierPath.close()
                break
            }
            _beizierPath.addLine(to: location)
        }
        
        taggedLayer.path = _beizierPath.cgPath
        taggedLayer.strokeColor = UIColor.red.cgColor
        taggedLayer.lineWidth = 3
        taggedLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(taggedLayer)
    }
}
