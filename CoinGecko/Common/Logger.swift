//
//  Logger.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 05.08.2025.
//

import Foundation

func DLog(
    _ message: @autoclosure () -> Any,
    function: String = #function,
    file: String = #file,
    line: Int = #line
) {
    #if DEBUG
        let filename = (file as NSString).lastPathComponent
        print("📍[\(filename):\(line)] \(function) → \(message())")
    #endif
}
