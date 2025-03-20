//
//  ChartView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 2/24/25.
//

import UIKit
import AVFoundation

// Model 만들것 -> tuple x
// chartEntities를 몰라야한다.

final class ChartView: UIView {
    
    private var _infoView: UIView?
    private let circleTag = 99
    private let _beizierPath = UIBezierPath()
    private var maxMinYTuple: (CGFloat?, CGFloat, CGFloat?, CGFloat) = (nil,0,nil,0)
    
    private let _formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
        
        maxMinYTuple.1 = maxminY.0
        maxMinYTuple.3 = maxminY.1
        
        let maxY = maxminY.0
        let minY = maxminY.1
        let range = maxY - minY
        
        // height : range = x : spotY
        // x  = spotyY * hegiht / range
        // CGPoint -> 반전
        
        _rates.forEach {
            let spotY = $0 - minY
            let yLocation = height * (1 - (spotY / range))
            
            // 최대값  ( point, rate ) -> 갱신
            if spotY == range {
                print("spotY is maximum")
                maxMinYTuple.0 = yLocation
            }
            // 최소값 -> 가장 처음에 들어오는 최소값만 사용
            if spotY == 0 {
                print("spotY is minimum")
                if maxMinYTuple.2 == nil {
                    maxMinYTuple.2 = yLocation
                }
            }
            
            positionY.append(yLocation)
        }
        return positionY
    }
    
    private func drawDot() {
        
        let maxPoint = maxMinYTuple.0
        let minPoint = maxMinYTuple.2
        
        // 최대값 은 가장 최신의 값만 사용
        for location in locations.reversed() {
            let circleLayer = TaggedLayer(tag: circleTag)
            let circlePath = UIBezierPath()
            if location.y == maxPoint {
                circlePath.addArc(withCenter: CGPoint(x: location.x,
                                                      y: maxPoint!),
                                                      radius: 3,
                                                      startAngle: 0,
                                                      endAngle: .pi * 2,
                                                      clockwise: true)
                circleLayer.path = circlePath.cgPath
                circleLayer.lineWidth = 2
                circleLayer.strokeColor = UIColor.clear.cgColor
                circleLayer.fillColor = UIColor.blue.cgColor
                self.layer.addSublayer(circleLayer)
                break
            }
        }
        
        // 최소값은 가장 늦은 값을 사용
        for location in locations {
            let circleLayer = TaggedLayer(tag: circleTag)
            let circlePath = UIBezierPath()
            if location.y == minPoint {
                print("in2")
                circlePath.addArc(withCenter: CGPoint(x: location.x,
                                                      y: minPoint! - 5),
                                                      radius: 3,
                                                      startAngle: 0,
                                                      endAngle: .pi * 2,
                                                      clockwise: true)
                circleLayer.path = circlePath.cgPath
                circleLayer.lineWidth = 2
                circleLayer.strokeColor = UIColor.clear.cgColor
                circleLayer.fillColor = UIColor.blue.cgColor
                self.layer.addSublayer(circleLayer)
                break
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard !_rates.isEmpty else { return }
        let tag  = 100
       
        removeExistingLayer(tagNum: tag)
        removeExistingLayer(tagNum: circleTag)
        
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
        drawDot()
    }
    
    private func convertDate(_ interval: Int) -> String {
        return _formatter.convertUNIXStamp(interval)
    }
}

extension ChartView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        addTouchLine(touches)
        addInfoLabel(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        addTouchLine(touches)
        addInfoLabel(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        removeExistingLayer(tagNum: 200)
        _infoView?.removeFromSuperview()
    }
    
    
    private func addInfoLabel(_ touches: Set<UITouch>) {
        
        guard let touchXY = touches.first?.location(in: self),
              !locations.isEmpty,
              let chartInfo = _chartInfo
        else {
            return
        }
        
        _infoView?.removeFromSuperview()
        let _label = { UINib(nibName: "ChartLabel", bundle: nil).instantiate(withOwner: self).first as! UIView }()
        let touchX = touchXY.x
        // 보정
        for (idx,location) in locations.enumerated() {
            if touchX <= location.x {
                
                _infoView = _label
                let sv = _infoView?.viewWithTag(3) as! UIStackView
                let dateLabel = sv.viewWithTag(1) as! UILabel
                let rateLabel = sv.viewWithTag(2) as! UILabel
                let currentInfo = chartInfo.chart[idx]
                dateLabel.text = "\(self.convertDate(currentInfo.timestamp))"
                rateLabel.text = "\(currentInfo.rate)"
                let size = _infoView!.intrinsicContentSize
                
                var x:CGFloat = idx.makeCGFloat + (dateLabel.intrinsicContentSize.width / 2)
                let y = location.y
                
                var infoViewY = self.bounds.height - 10
                let midHeight = self.bounds.height / 2
            
                // info Label 위치는 중간 이상일때 기준선 왼쪽에 위치
                // rate가 midY 높을때 맨 아래에 info
            
                if y > midHeight {
                    // y축의 값이 절반 보다 높을때 label위치는 아래
                    infoViewY = 0
                }

                // x의 값이 차트 중간을 넘어가면, 위치를 이동
                if idx > locations.count / 2 {
                    x = idx.makeCGFloat - (dateLabel.intrinsicContentSize.width / 2)
                }
    
                _infoView!.frame = CGRect(origin: CGPoint(x: x, y: infoViewY), size: size)
                addSubview(_infoView!)
                break
            }
        }
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
}
