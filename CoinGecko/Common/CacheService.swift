//
//  CacheService.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 19.08.2025.
//

import Foundation

enum CacheError: Error, LocalizedError {
    case saveCacheError(Error)
    case loadCacheError(Error)
    case isRelevantError(Error)
    case noData
    var errorDescription: String? {
        switch self {
        case .noData: return "No data found"
        case .saveCacheError(let error): return "Save cache \(error.localizedDescription)"
        case .loadCacheError(let error): return "Load cache \(error.localizedDescription)"
        case .isRelevantError(let error): return "Is relevant cache \(error.localizedDescription)"
        }
    }
}

protocol CacheServiceProtocol {
    func save<T: Encodable>(value: T, dataKey: NSString, dateKey: NSString) throws
    func load<T: Decodable>(dataKey: NSString) throws -> T
    func isRelevant(cacheKey: NSString, timeInterval: TimeInterval) throws -> Bool
}

final class CacheService: CacheServiceProtocol {
    private let cache = NSCache<NSString, NSData>()

    func save<T: Encodable>(value: T, dataKey: NSString, dateKey: NSString) throws {
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(value)
            let date = try encoder.encode(Date())

            cache.setObject(data as NSData, forKey: dataKey)
            cache.setObject(date as NSData, forKey: dateKey)
        } catch {
            throw CacheError.saveCacheError(error)
        }
    }

    func load<T: Decodable>(dataKey: NSString) throws -> T {
        let decoder = JSONDecoder()

        do {
            if let nsData = cache.object(forKey: dataKey) {
                return try decoder.decode(T.self, from: nsData as Data)
            } else {
                throw CacheError.noData
            }
        } catch {
            throw CacheError.loadCacheError(error)
        }
    }

    func isRelevant(cacheKey: NSString, timeInterval: TimeInterval) throws -> Bool {
        let decoder = JSONDecoder()

        guard let nsData = cache.object(forKey: cacheKey) else {
            return false
        }

        do {
            let date = try decoder.decode(Date.self, from: nsData as Data)
            return Date() < date + TimeInterval(timeInterval)
        } catch {
            throw CacheError.isRelevantError(error)
        }
    }
}
