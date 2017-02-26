//
//  ForecastIOService.swift
//  ForecastIOClient
//
//  Created by Liu Liang on 24/02/2017.
//  Copyright © 2017 Liu Liang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private let urlPrefix = "https://api.darksky.net/forecast/"

enum ForecastIOError: Error {
    case invalidUrl(String), failedToParseJson
}

class ForecastIOService {
    
    private func getUrlPrefixWithKey(_ key: String) -> String {
        return "\(urlPrefix)\(key)/"
    }
    
    func getForecastJson$(_ key: String, location:String) -> Observable<[String:Any]> {
        let urlPrefix = getUrlPrefixWithKey(key)
        
        guard let urlString = "\(urlPrefix)\(location)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string:urlString)else {
                return .error(ForecastIOError.invalidUrl(location))
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .flatMap { json -> Observable<[String:Any]> in
                guard let json = json as? [String:Any] else {
                    return .error(ForecastIOError.failedToParseJson)
                }
                return .just(json)
            }        
    }

}
