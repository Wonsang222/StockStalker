# StockStalker 개인 프로젝트 정리

---

## 목표

- 프레임워크: Reactor Kit, RxSwift가 어떻게 동작하는지 공부하면서 코드를 작성했습니다.

- Swift Concurrency : 네트워크 통신을 Async/Await 을 사용해 작성하며 에러처리, 네트워크 레이어 구성을 고민했고, 이를 Rx로 Wrapping 해서 사용했습니다.

- 테스트 : 각 레이어마다 의존성 주입(DI)를 사용하여 Testable한 코드를 작성했습니다.

- UIBeizierPath : 차트 라이브러리를 사용하지 않고, 앱에서 사용되는 차트를 직접 작성했습니다. 레퍼런스는 토스 주식 탭에 사용된 차트입니다.

- 디자인 : UIKit 베이스입니다. VC의 프레임은 스토리보드를 사용하고, 컴포넌트들은 코드로 작성 했습니다.

- React-Native : React Native 모듈을 추가할 예정입니다.

---

# 앱의 구성

## 차트

## 하나은행 웹 크롤링
