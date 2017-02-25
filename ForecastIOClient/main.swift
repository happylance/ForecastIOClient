//
//  main.swift
//  ForecastIOClient
//
//  Created by Liu Liang on 24/02/2017.
//  Copyright © 2017 Liu Liang. All rights reserved.
//

import Foundation
import RxSwift
import RxBlocking

do {
    _ = try Observable.of(defaultLocation)
        .flatMap {
            ForecastIOService()
                .getForecastJson$(apiKey, location:$0)
                .catchError({
                    guard let serverError = $0 as? ForecastIOError else {
                        print("Error: \($0)")
                        return .empty()
                    }
                    switch serverError {
                    case .invalidUrl(let location):
                        print("Could not create URL request for \(location)")
                    case .noData:
                        print("data is nil")
                    case .failedToParseJson:
                        print("Failed to parse JSON")
                    case .serverError(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                    return .empty()
                })
        }
        .do(onNext: { forecastJson in
            forecastJson.forEach {
                print($0.0)
                if ($0.0 == "timezone" || $0.0 == "offset") {
                    print($0.1)
                }
            }
            print("")
        })
        .toBlocking()
        .last()
}
catch {
    print(error)
}
