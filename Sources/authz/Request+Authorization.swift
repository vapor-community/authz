//
//  File.swift
//  
//
//  Created by Jimmy McDermott on 11/3/19.
//

import Foundation
import Vapor

private let _authorizationCacheKey = "authz"

extension Request {
    /// Returns an instance of the supplied type. Throws if no
    /// instance of that type has been authorized or if there
    /// was a problem.
    public func requireAuthorized<A>(_ type: A.Type = A.self) throws -> A
        where A: AuthorizationPolicy
    {
        guard let a = authorized(A.self) else {
            self.logger.error("\(A.self) has not been authorized")
            throw Abort(.unauthorized)
        }
        return a
    }

    /// Authorizes the supplied instance for this request.
    public func authorize<A>(_ instance: A)
        where A: AuthorizationPolicy
    {
        self._authorizationCache[A.self] = instance
    }

    /// Returns the authorized instance of the supplied type.
    /// note: nil if no type has been authed.
    public func authorized<A>(_ type: A.Type = A.self) -> A?
        where A: AuthorizationPolicy
    {
        return self._authorizationCache[A.self]
    }
    
    /// Returns true if the type has been authorized.
    public func isAuthorized<A>(_ type: A.Type = A.self) -> Bool
        where A: AuthorizationPolicy
    {
        return self.authorized(A.self) != nil
    }

    internal var _authorizationCache: AuthorizationCache {
        get {
            if let existing = self.userInfo[_authorizationCacheKey] as? AuthorizationCache {
                return existing
            } else {
                let new = AuthorizationCache()
                self.userInfo[_authorizationCacheKey] = new
                return new
            }
        }
        set {
            self.userInfo[_authorizationCacheKey] = newValue
        }
    }
}
