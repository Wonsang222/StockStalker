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
        
        
        
        reactor.pulse(\.$error)
            .compactMap {$0}
            .bind(to: rx.error)
            .disposed(by: disposeBag)
    }
}
