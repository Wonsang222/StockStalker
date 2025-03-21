//
//  MoneyRateVC.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import SwiftUI
import WebKit

final class MoneyRateVC: UIViewController, StoryboardView {
    
    let bb = WKWebViewSessionManager1()
    
    // MARK: - Current Rate

    @IBOutlet weak var nationalFlagLabel: UILabel!
    @IBOutlet weak var nationalCurrencyLabel: UILabel!
    @IBOutlet weak var currentRateLabel: UILabel!
    @IBOutlet weak var currentUpDown: UILabel!
    @IBOutlet weak var currentRatio: UILabel!
    @IBOutlet weak var currentPercent: UILabel!
    
    // MARK: - Time Standard
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Time Standard
    @IBOutlet weak var hanaBankRate: UILabel!
    @IBOutlet weak var hanaBankUpDown: UILabel!
    @IBOutlet weak var hanaBankRatio: UILabel!
    @IBOutlet weak var hanaBankPercent: UILabel!
    
    // MARK: - Time Standard
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    
    // MARK: - Graph
    @IBOutlet weak var chartContainer: UIView!
    private let _chartView = ChartMainView()
    
    private lazy var hanaAPIViews: [UIView] = [
        sellLabel,
        buyLabel,
        hanaBankRate,
        hanaBankUpDown,
        hanaBankRatio,
        hanaBankPercent
    ]
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureUI() {
        _chartView.frame = chartContainer.bounds
        chartContainer.addSubview(_chartView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
        test()
    }
    
    func bind(reactor: MoneyRateViewModel) {
        
        // bind 타이밍 확인
        _chartView.rx.segment
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { YahooServices(rawValue: $0)! }
            .map { Reactor.Action.tapBtn($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 하나은행 Parsing, yahoo 1일차 로딩. -> view 자리잡고 로드해야함.
        self.rx.viewWillAppear
        // observable maptoVoid
        
        
        reactor.pulse(\.$date)
            .compactMap {$0}
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .bind(to: _chartView.rx.isLoading)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$rates)
            .compactMap {$0}
            .bind(to: _chartView.rx.drawChart)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap {$0}
            .bind(to: rx.error)
            .disposed(by: disposeBag)
    }
}

//fileprivate extension Reactive where Base: MoneyRateVC {
//    var hanaBankViews: Binder<>
//}

extension MoneyRateVC {
    func test() {
       
        bb.req()
    }
}


    final class WKWebViewSessionManager1 {
        private let _wkWebView = WKWebView(frame: .zero)
        
        func req() {
            let url = "https://www.naver.com"
            let urla = URL(string: url)!
            let req = URLRequest(url: urla)
            _wkWebView.load(req)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self!.fetchHTML()
                    }
        }
        
        func fetchHTML() {
            DispatchQueue.main.async { [unowned self] in
                let fetcher = """
                return 5;
                """
                _wkWebView.evaluateJavaScript(fetcher) { result, error in
                    print(result)
                    print(error)
                }
            }
        }
}
