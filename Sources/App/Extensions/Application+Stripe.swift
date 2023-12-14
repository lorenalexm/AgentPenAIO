//
//  Application+Stripe.swift
//
//
//  Created by Alex Loren on 12/13/23.
//

import Vapor
import StripeKit

extension Application {
    // MARK: - Properties
    
    /// Provides a `StripeClient` object initialized with the `STRIPE_KEY` environmental variable.
    public var stripe: StripeClient {
        guard let key = Environment.get("STRIPE_KEY") else {
            fatalError("STIPE_KEY environmental variable not set!")
        }
        
        return .init(httpClient: self.http.client.shared, apiKey: key)
    }
}
