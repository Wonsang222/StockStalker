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
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        _chartView.frame = chartContainer.frame
        chartContainer.addSubview(_chartView)
    }
    
    func bind(reactor: MoneyRateViewModel) {
        
        _chartView.rx.segment
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { YahooServices(rawValue: $0)! }
            .map { Reactor.Action.tapBtn($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        
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

#if DEBUG
struct Preview: PreviewProvider {
    
    static var previews: some View {
        UIViewControllerPreview {
            return MoneyRateVC()
        }
    }
}

#endif

