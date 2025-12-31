//
//  EndPoint.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 13.08.2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPointProtocol {
    var headers: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }

    func makeRequest() throws -> URLRequest
}

extension EndPointProtocol {
    func makeRequest() throws -> URLRequest {
        let urlConst = "https://api.coingecko.com/api/v3"
        let timeoutInterval = 20.0

        guard let baseUrl: URL = URL(string: urlConst) else {
            throw NetworkError.invalidRequest
        }

        let url = baseUrl.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        if let queryItems, !queryItems.isEmpty {
            components?.queryItems = queryItems
        }

        guard let finalUrl = components?.url else {
            throw NetworkError.invalidRequest
        }

        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        request.allHTTPHeaderFields = headers

        return request
    }
}
