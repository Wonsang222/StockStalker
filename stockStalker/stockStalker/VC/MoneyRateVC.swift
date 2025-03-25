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

final class MoneyRateVC: UIViewController, StoryboardView {
    // MARK: - Current Rate
    
    @IBOutlet weak var nationalFlag: UILabel!
    @IBOutlet weak var currentRate: UILabel!
    @IBOutlet weak var updownIcon: UILabel!
    @IBOutlet weak var updownRate: UILabel!
    
    // MARK: - Time Standard
    @IBOutlet weak var timeLabel: UILabel!

    // MARK: - Time Standard
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    
    // MARK: - Graph
    @IBOutlet weak var chartContainer: UIView!
    private let _chartView = ChartMainView()

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

fileprivate extension Reactive where Base: MoneyRateVC {
    var citiBankApiHandler: Binder<CitiBankEntity> {
        return Binder(base) { vc, entitiy in
            vc.timeLabel.text = entitiy.date
            vc.buyLabel.text = entitiy.buy
            vc.sellLabel.text = entitiy.sell
            vc.currentRate.text = entitiy.currentRate
            vc.updownIcon.text = entitiy.updownIcon
            vc.updownRate.text = entitiy.updownString
        }
    }
}

