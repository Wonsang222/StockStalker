# StockStalker

## RxSwift
1. Type Erasure Pattern -> Method Chaining
2. Sink Disposer & Sink 객체의 Retain cycle -> Disposable 객체의 라이프 사이클 관리 (dispose bag에서 일괄적으로 메모리 관리)
3. asObservable() -> AnonymousObsrvable을 만들어 해당 옵저버블의 subscribe(observer) 함수 주소를 강하게 캡쳐해서, 같은 라이프 사이클을 갖게 만듦.   

## Reactor Kit
1. Action Subject -> Observable, Observer 타입. createStreams()에서 변형되는 과정에서 연쇄 구독이 일어남 (Action Subject는 subscribe에서 옵저버를 등록하는데.. 왜 여기에서는 다수의 옵저버를 설정가능하게 했는지는 의문..)
2. Pulse -> State는 이벤트가 발생할때 마다 Emit. distincuntilchanged를 매번 실행하는것은 에러 리스크가 큼 -> 내부적으로 비교하는 프로퍼티를 둬서, 변화가 있으면 이벤트를 방출
  
