//
//  YahooAPI.swift
//  stockStalker
//
//  Created by Wonsang HWang on 2/27/25.
//

import Foundation
import RxSwift
import WebKit

protocol AsyncNetworkService {
    func fetchAPI(endpoint: Requestable) async throws -> Data
}

protocol AsyncSessionManager {
    func request(req: URLRequest, config: URLSessionConfiguration) async throws -> (Data, URLResponse)
}

final class LegacyNetworkSessionManagerWrapper: AsyncSessionManager {
    private let webViewSession: WKWebViewSessionManager = WKWebViewSessionManager()
    
    func request(req: URLRequest, config: URLSessionConfiguration) async throws -> (Data, URLResponse) {
        
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                webViewSession.fetchHTML(req: req) { result in
                    switch result {
                    case .success(let resultString):
                        guard let data = resultString.data(using: .utf8) else {
                            continuation.resume(throwing: NetworkError.dataParse)
                            return
                        }
                        let resp = HTTPURLResponse(url: URL(string: CitiBankAPI.url)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        continuation.resume(returning: (data, resp))
                    case .failure:
                        continuation.resume(throwing: NetworkError.dataParse)
                    }
                }
            }
        }
    }
}

final class DefaultAsyncSessionManager: AsyncSessionManager {
    func request(req: URLRequest, config: URLSessionConfiguration) async throws -> (Data, URLResponse) {
        return try await URLSession(configuration: config).data(for: req)
    }
}

final class WKWebViewSessionManager: NSObject, WKNavigationDelegate {
    
    private let _wkWebView = WKWebView(frame: .zero)
    private var handler: ((Result<String, NetworkError>) -> Void)?
    
    override init() {
        super.init()
        _wkWebView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard let handler = handler else { return }
        
        DispatchQueue.main.async {
            
            let fetcher = """
            (function () {
                const infoObj = {
                    info: []
                };
            
                // 시간 정보 가져오기
                const time = document.querySelector('span.small').textContent;
                infoObj['time'] = time;
            
                // 현재 환율 값 가져오기
                const current = Array.from(document.querySelectorAll('.green')).map((v) => v.textContent);
            
                // 상승/하락 값 가져오기
                const updown = Array.from(document.querySelectorAll('.exchangeList li'))
                    .filter(v => v.querySelector('div.tit'))
                    .map((v) => {
                        if (v.querySelector('span.icoIncrease')) {
                            return v.querySelector('span.icoIncrease').textContent;
                        }
                        if (v.querySelector('span.icoDecrease')) {
                            return v.querySelector('span.icoDecrease').textContent;
                        }
                        return null; 
                    });
            
                // 국가 정보 가져오기
                const countries = Array.from(document.querySelector('.exchangeList').querySelectorAll('div.tit'))
                    .map((v) => v.querySelector('div span').textContent);
            
                // 현찰 살 때/팔 때 값 가져오기
                const sell = [];
                const buy = [];
                Array.from(document.querySelector('.exchangeList').querySelectorAll('li ul li')).forEach((v) => {
                    if (v.querySelector('span').textContent === '현찰 살 때') {
                        buy.push(v.querySelector('em').textContent);
                    }
                    if (v.querySelector('span').textContent === '현찰 팔 때') {
                        sell.push(v.querySelector('em').textContent);
                    }
                });
            
                for (let i = 0; i < countries.length; i++) {
                    const obj = {};
            
                    const currentSell = sell[i];
                    const currentBuy = buy[i];
                    const currentUpdown = updown[i];
                    const currentPrice = current[i];
                    const country = countries[i];
            
                    obj['country'] = country;
                    obj['buy'] = currentBuy;
                    obj['sell'] = currentSell;
                    obj['updown'] = currentUpdown;
                    obj['currentRate'] = currentPrice;
            
                    infoObj['info'].push(obj);
                }
            
                return JSON.stringify(infoObj);
            })();
            """
            self._wkWebView.evaluateJavaScript(fetcher) { result, error in
                
                if error != nil {
                    handler(.failure(.dataParse))
                    return
                }
                
                if let resultString = result as? String {
                    handler(.success(resultString))
                    
                }
            }
        }
    }
    
    func fetchHTML(req: URLRequest, completion: @escaping (Result<String, NetworkError>) -> Void) {
        DispatchQueue.main.async {
            self.handler = completion
            self._wkWebView.load(req)
        }
    }
}

final class DefaultAsyncNetworkService {
    
    private let _session: AsyncSessionManager
    private let _configuration: NetworkConfigurable
    
    init(_session: AsyncSessionManager, _configuration: NetworkConfigurable) {
        self._session = _session
        self._configuration = _configuration
    }
    
    private func getRequest(_ endpoint: Requestable) throws -> URLRequest  {
        return try endpoint.urlRequest(_configuration)
    }
    
    private func getConfig(_ endpoint: Requestable) -> URLSessionConfiguration {
        return endpoint.urlSessionConfiguration(_configuration)
    }
    
    private func handleHttpResponse(_ reponse: URLResponse) throws {
        guard let response = reponse as? HTTPURLResponse else {
            throw NetworkError.wrongResponse
        }
        
        if !(200...299).contains(response.statusCode) {
            throw NetworkError.wrongResponse
        }
    }
}

extension DefaultAsyncNetworkService: AsyncNetworkService {
    func fetchAPI(endpoint: any Requestable) async throws -> Data {
        do {
            let (data, response) = try await _session.request(req: getRequest(endpoint), config: getConfig(endpoint))
            try handleHttpResponse(response)
            return data
        } catch let error {
            if let _ = error as? CancellationError {
                throw NetworkError.cancellation
            }
            throw NetworkError.wrongResponse
        }
    }
}

protocol AsyncDataTransferService {
    func request<T: ResponseRequestable, F: Decodable>(_ endpoint: T) async throws -> F where T.Response == F
}

final class AsyncDataTransferServiceImplementaion {
    
    private let _networkService: AsyncNetworkService
    
    init(_networkService: AsyncNetworkService) {
        self._networkService = _networkService
    }
    
    private func convertToEntitity<T: Decodable>(with decoder: ResponseDecoder, data: Data) throws -> T {
        do {
            let successData: T = try decoder.decode(data)
            return successData
        } catch {
            throw NetworkError.dataParse
        }    }
    
}

extension AsyncDataTransferServiceImplementaion: AsyncDataTransferService {
    func request<T, F>(_ endpoint: T) async throws -> F where T : ResponseRequestable, F == T.Response, F: Decodable {
        let data = try await _networkService.fetchAPI(endpoint: endpoint)
        let dto: F = try convertToEntitity(with: endpoint.responseDecoder, data: data)
        return dto
    }
}

protocol RxDataTransferWrapperType {
    func request<T: ResponseRequestable, F: Decodable>(_ endpoint: T) -> Single<F> where F == T.Response
}

final class RxDataTransferWrapper: RxDataTransferWrapperType {
    let _asyncDataTransferService: AsyncDataTransferService
    
    init(_asyncDataTransferService: AsyncDataTransferService) {
        self._asyncDataTransferService = _asyncDataTransferService
    }
    
    func request<T, F>(_ endpoint: T) -> Single<F> where T : ResponseRequestable, F : Decodable, F == T.Response {
        return Single.create { single in
            let task =  Task {
                do {
                    let data = try await self._asyncDataTransferService.request(endpoint)
                    single(.success(data))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
