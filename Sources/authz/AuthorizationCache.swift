//
//  AuthorizationCache.swift
//  
//
//  Created by Jimmy McDermott on 11/3/19.
//

import Foundation

internal final class AuthorizationCache {
    /// The internal storage.
    private var storage: [ObjectIdentifier: Any]

    /// Create a new authentication cache.
    init() {
        self.storage = [:]
    }

    /// Access the cache using types.
    internal subscript<A>(_ type: A.Type) -> A?
        where A: AuthorizationPolicy
        {
        get { return storage[ObjectIdentifier(A.self)] as? A }
        set { storage[ObjectIdentifier(A.self)] = newValue }
    }
}
