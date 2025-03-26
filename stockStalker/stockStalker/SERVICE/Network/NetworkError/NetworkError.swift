//
//  NetworkError.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/25/25.
//

import Foundation

enum NetworkError: Error {
    case urlComponent
    case url
    case wrongResponse
    case dataParse
    case cancellation
    case api
}

extension NetworkError {
    var message: String {
        switch self {
        case .api, .dataParse, .wrongResponse:
            return "현재 Yahoo 서버가 불안정합니다. \n잠시 후 다시 시도해주세요."
        default:
            return "서버의 주소가 변경되었습니다. \n신속히 조치하겠습니다."
        }
    }
}
