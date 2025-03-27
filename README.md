# StockStalker 개인 프로젝트 정리

---

## 목표

- 프레임워크: Reactor Kit, RxSwift가 어떻게 동작하는지 공부하면서 코드를 작성했습니다.

- Swift Concurrency : 네트워크 통신을 Async/Await 을 사용해 작성하며 에러처리, 네트워크 레이어 구성을 고민했고, 이를 Rx로 Wrapping 해서 사용했습니다.

- 웹 크롤링 : 라이브러리를 사용하지 않고, WKWebView로 직접 페이지에서 해당 데이터를 가지고 옵니다.

- 테스트 : 각 레이어마다 의존성 주입(DI)를 사용하여 Testable한 코드를 작성했습니다.

- UIBeizierPath : 차트 라이브러리를 사용하지 않고, 앱에서 사용되는 차트를 직접 작성했습니다. 레퍼런스는 토스 주식 탭에 사용된 차트입니다.

- 디자인 : UIKit 베이스입니다. VC의 프레임은 스토리보드를 사용하고, 컴포넌트들은 코드로 작성 했습니다.

- React-Native : React Native 모듈을 추가할 예정입니다.

---

# 앱의구성

## 차트
![Image](https://github.com/user-attachments/assets/fb77c704-a5e3-41ee-9d86-76532f9770df)

~~~swift
// UIView를 상속하여, draw 메서드를 아래와 같이 정의했습니다.
    override func draw(_ rect: CGRect) {
        guard !_rates.isEmpty else { return }
        removeAll()
        let _beizierPath = UIBezierPath()
        let taggedLayer = TaggedLayer()
        taggedLayer.tag = _chartTag
        
        let positionY = calculateLocationY(rect: rect)
        let positionX = calculateLocationX(rect: rect)
    
		// X(뷰 넓이 /데이터 개수) Y(전달된 데이터 값에 따른 상대적 높이)
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
        taggedLayer.strokeColor = UIColor.systemRed.cgColor
        taggedLayer.lineWidth = 2
        taggedLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(taggedLayer)
        drawDot()
    }

    private func calculateLocationY(rect: CGRect) -> [CGFloat] {
        let height = rect.height
        var positionY = [CGFloat]()
        let firstYValue = _rates[0]
		// 배열 순회 -> 최대 최소 값을 구하는 로직
        let maxminY = _rates.reduce((firstYValue, firstYValue)){ partialResult, currentValue in
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
                maxMinYTuple.0 = yLocation
            }
            // 최소값 -> 가장 처음에 들어오는 최소값만 사용
            if spotY == 0 {
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
            let circleLayer = TaggedLayer()
            circleLayer.tag = _circleTag
            let circlePath = UIBezierPath()
            if location.y == maxPoint {
                circlePath.addArc(withCenter: CGPoint(x: location.x,
                                                      y: maxPoint!),
                                                      radius: 5,
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
        
        // 최소값은 가장 앞의 값을 사용
        for location in locations {
            let circleLayer = TaggedLayer()
            circleLayer.tag = _circleTag
            let circlePath = UIBezierPath()
            if location.y == minPoint {
                circlePath.addArc(withCenter: CGPoint(x: location.x,
                                                      y: minPoint!),
                                                      radius: 5,
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

~~~

## 시티은행 웹 크롤링

```swift
해당 웹페이지로 이동 후, 로드가 완료되면, 해당 페이지의 HTML 태그를 자바스크립트로
필터링하여 데이터를 문자열로 반환합니다.

   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard let handler = handler else { return }
        
        DispatchQueue.main.async {
            
            let fetcher = """
            (function () {
                const infoObj = {
                    info: []
                };
            
                // 시간 정보 가져오기
                const time = document.querySelector('span.small').textContent;
                infoObj['time'] = time;
            
                // 현재 환율 값 가져오기
                const current = Array.from(document.querySelectorAll('.green')).map((v) => v.textContent);
            
                // 상승/하락 값 가져오기
                const updown = Array.from(document.querySelectorAll('.exchangeList li'))
                    .filter(v => v.querySelector('div.tit'))
                    .map((v) => {
                        if (v.querySelector('span.icoIncrease')) {
                            return v.querySelector('span.icoIncrease').textContent;
                        }
                        if (v.querySelector('span.icoDecrease')) {
                            return v.querySelector('span.icoDecrease').textContent;
                        }
                        return null; 
                    });
            
                // 국가 정보 가져오기
                const countries = Array.from(document.querySelector('.exchangeList').querySelectorAll('div.tit'))
                    .map((v) => v.querySelector('div span').textContent);
            
                // 현찰 살 때/팔 때 값 가져오기
                const sell = [];
                const buy = [];
                Array.from(document.querySelector('.exchangeList').querySelectorAll('li ul li')).forEach((v) => {
                    if (v.querySelector('span').textContent === '현찰 살 때') {
                        buy.push(v.querySelector('em').textContent);
                    }
                    if (v.querySelector('span').textContent === '현찰 팔 때') {
                        sell.push(v.querySelector('em').textContent);
                    }
                });
            
                for (let i = 0; i < countries.length; i++) {
                    const obj = {};
            
                    const currentSell = sell[i];
                    const currentBuy = buy[i];
                    const currentUpdown = updown[i];
                    const currentPrice = current[i];
                    const country = countries[i];
            
                    obj['country'] = country;
                    obj['buy'] = currentBuy;
                    obj['sell'] = currentSell;
                    obj['updown'] = currentUpdown;
                    obj['currentRate'] = currentPrice;
            
                    infoObj['info'].push(obj);
                }
            
                return JSON.stringify(infoObj);
            })();
            """
            self._wkWebView.evaluateJavaScript(fetcher) { result, error in
                
                if error != nil {
                    handler(.failure(.dataParse))
                    return
                }
                
                if let resultString = result as? String {
                    handler(.success(resultString))
                    
                }
            }
        }
    }
}
```

​	

