//
//  SceneDIContainer.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/26/25.
//

import UIKit
import ReactorKit

final class SceneDIContainer {
    
    private let dependencies = AppDIContainer()
    
    func makeVC() -> MoneyRateVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MoneyRate") as! MoneyRateVC
        vc.reactor = makeMainVM()
        return vc
    }
    
    private func makeMainVM() -> MoneyRateViewModel {
        return MoneyRateViewModel(_networkService: dependencies.yahooNetworkService, _webViewSession: dependencies.citiBankNetworkService)
    }
    
}
