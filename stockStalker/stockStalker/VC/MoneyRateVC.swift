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
    
    
    @IBOutlet weak var nationFlagLabel: UILabel!
    @IBOutlet weak var currentRateLabel: UILabel!
    @IBOutlet weak var currnetRateUPDown: UILabel!
    @IBOutlet weak var currentRateRatio: UILabel!
    @IBOutlet weak var currentRatePercent: UILabel!
    @IBOutlet weak var standardTime: UILabel!
    
    
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: MoneyRateViewModel) {
        
    }
}
