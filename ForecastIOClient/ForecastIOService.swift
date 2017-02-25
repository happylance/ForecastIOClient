//
//  ForecastIOService.swift
//  ForecastIOClient
//
//  Created by Liu Liang on 24/02/2017.
//  Copyright © 2017 Liu Liang. All rights reserved.
//

import Foundation
import RxSwift

private let urlPrefix = "https://api.darksky.net/forecast/"

enum ForecastIOError: Error {
    case invalidUrl(String), noData, failedToParseJson, serverError(Error)
}

class ForecastIOService {
    
    private func getUrlPrefixWithKey(_ key: String) -> String {
        return "\(urlPrefix)\(key)/"
    }
    
    func getForecastJson$(_ key: String, location:String) -> Observable<[String:Any]> {
        let urlPrefix = getUrlPrefixWithKey(key)
        
        return Observable.create{ observer in
            guard let url = "\(urlPrefix)\(location)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let request = URL(string:url) else {
                observer.onError(ForecastIOError.invalidUrl(location))
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(ForecastIOError.serverError(error))
                    return
                }
                
                guard let data = data else {
                    observer.onError(ForecastIOError.noData)
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    dlog(response)
                    print(response.statusCode)
                }
                
                guard let parsedData = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any] else {
                    observer.onError(ForecastIOError.failedToParseJson)
                    return
                }
                observer.onNext(parsedData)
                observer.onCompleted()
            }
            .resume()
            
            return Disposables.create()
        }
        
    }

}

@discardableResult func dlog<T>(_ arg: T) -> T {
    return debugLog(arg)
}

@discardableResult func dlog(_ arg: String) -> String {
    return debugLog(arg)
}

private func debugLog<T>(_ arg: T) -> T {
    #if DEBUG
        print(arg)
    #endif
    return arg
}
