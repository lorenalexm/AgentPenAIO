//
//  Request+Stripe.swift
//
//
//  Created by Alex Loren on 12/13/23.
//

import Vapor
import StripeKit

extension Request {
    // MARK: - Properties
    private struct StripeKey: StorageKey {
        typealias Value = StripeClient
    }
    
    /// Provides a `StripeClient` object from `Storage` or newly initialized with the `STRIPE_KEY` environmental variable.
    public var stripe: StripeClient {
        if let existing = application.storage[StripeKey.self] {
            return existing
        } else {
            guard let key = Environment.get("STRIPE_KEY") else {
                fatalError("STIPE_KEY environmental variable not set!")
            }
            
            let client = StripeClient(httpClient: self.application.http.client.shared, apiKey: key)
            self.application.storage[StripeKey.self] = client
            return client
        }
    }
}
