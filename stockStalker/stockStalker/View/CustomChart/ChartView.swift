//
//  ChartView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 2/24/25.
//

import UIKit
import AVFoundation

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
    
    private var locations: [CGPoint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        addTouchLine(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        addTouchLine(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        removeExistingLayer(tagNum: 200)
    }
    
    private func addTouchLine(_ touches: Set<UITouch>) {
        guard let touchXY = touches.first?.location(in: self),
              !locations.isEmpty
        else {
            return
        }
        
        removeExistingLayer(tagNum: 200)
        
        let touchX = touchXY.x
        // 보정
        for location in locations {
            if touchX <= location.x {
                let x = location.x
                let y = location.y
                let height = self.bounds.height
                let width = self.bounds.width
                
                // (0, y) -> (width, y)
                // (x, 0) -> (x, height)
                
                let path = UIBezierPath()
                // 라인 세로
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: width, y: y))
                // 라인 가로
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: height))
                
                let taglayer = TaggedLayer(tag: 200)
                taglayer.path = path.cgPath
                taglayer.strokeColor = UIColor.gray.cgColor
                taglayer.fillColor = UIColor.clear.cgColor
                taglayer.lineWidth = 1
                // 진동
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.layer.addSublayer(taglayer)
                
                break
            }
        }
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
        let height = rect.height
        var positionY = [CGFloat]()
        let firstYValue = _rates[0]
        let maxminY = _rates.reduce((firstYValue, firstYValue)) { partialResult, currentValue in
            let max = currentValue > partialResult.0 ? currentValue : partialResult.0
            let min = currentValue < partialResult.1 ? currentValue : partialResult.1
            return (max,min)
        }
        
        let maxY = maxminY.0
        let minY = maxminY.1
        let range = maxY - minY
        
        // height : range = x : spotY
        // x  = spotyY * hegiht / range
        // CGPoint -> 반전
        
        _rates.forEach {
            let spotY = $0 - minY
            let yLocation = height * (1 - (spotY / range))
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

        zip(positionX, positionY).forEach { locations.append(CGPoint(x: $0, y: $1)) }
        
        for (idx,location) in locations.enumerated() {

            if idx == 0 {
                _beizierPath.move(to: location)
                continue
            }
            if idx == locations.count - 1 {
                _beizierPath.addLine(to: location)
                break
            }
            _beizierPath.addLine(to: location)
        }
        
        taggedLayer.path = _beizierPath.cgPath
        taggedLayer.strokeColor = UIColor.red.cgColor
        taggedLayer.lineWidth = 2
        taggedLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(taggedLayer)
    }
}
