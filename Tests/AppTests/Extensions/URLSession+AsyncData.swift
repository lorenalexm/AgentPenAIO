//
//  URLSession+AsyncData.swift
//
//
//  Created by Alex Loren on 1/24/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum URLSessionAsyncErrors: Error {
    case invalidUrlResponse
    case missingResponseData
}

public extension URLSession {
    // MARK: - Functions.
    
    /// A reimplementation of `URLSession.shared.data(from: url)` required for Linux
    /// - Parameter request: The `URLRequest` object to use within this task.
    /// - Returns: The `Data` and a `HTTPURLResponse` from the request.
    func asyncData(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation() { continuation in
            let task = dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(throwing: URLSessionAsyncErrors.invalidUrlResponse)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: URLSessionAsyncErrors.missingResponseData)
                    return
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}
