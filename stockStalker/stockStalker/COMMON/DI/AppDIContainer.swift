//
//  AppDIContainer.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/26/25.
//

import Foundation

final class AppDIContainer {
    
    lazy var yahooNetworkService: RxDataTransferWrapperType = {
        let config = NetworkConfig(baseURL: YahooAPI.baseURL, header: [ : ])
        let session = DefaultAsyncSessionManager()
        let serviceLayer: AsyncNetworkService = DefaultAsyncNetworkService(_session: session, _configuration: config)
        let dataLayer: AsyncDataTransferService = AsyncDataTransferServiceImplementaion(_networkService: serviceLayer)
        return RxDataTransferWrapper(_asyncDataTransferService: dataLayer)
    }()
    
    lazy var citiBankNetworkService: RxDataTransferWrapperType = {
        let config = NetworkConfig(baseURL: CitiBankAPI.url, header: [:])
        let wrapper = LegacyNetworkSessionManagerWrapper()
        let serviceLayer = DefaultAsyncNetworkService(_session: wrapper, _configuration: config)
        let dataLayer = AsyncDataTransferServiceImplementaion(_networkService: serviceLayer)
        return RxDataTransferWrapper(_asyncDataTransferService: dataLayer)
    }()
}
