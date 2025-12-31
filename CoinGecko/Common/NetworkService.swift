//
//  NetworkService.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 12.08.2025.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidRequest
    case requestFailed
    case badStatusCode(Data?)
    case emptyData
    case decoding(Error)

    var errorDescription: String {
        switch self {
        case .invalidRequest: return "Invalid request"
        case .requestFailed: return "Request failed"
        case .badStatusCode(let code): return "Bad status code: \(String(describing: code))"
        case .emptyData: return "Empty data"
        case .decoding(let error): return "Decoding error \(error.localizedDescription)"
        }
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endPoint: EndPointProtocol) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(endPoint: EndPointProtocol) async throws -> T {
        let request = try endPoint.makeRequest()
        print(request)
        let (data, response): (Data, URLResponse)

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            //throw NetworkError.requestFailed
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(data)
        }

        guard !data.isEmpty else {
            throw NetworkError.emptyData
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw error
        }
    }
}
