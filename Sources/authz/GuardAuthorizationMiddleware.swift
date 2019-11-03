//
//  GuardAuthorizationMiddleware.swift
//  
//
//  Created by Jimmy McDermott on 11/3/19.
//

import Foundation
import Vapor

extension AuthorizationPolicy {
    /// Creates a new `GuardAuthorizationMiddleware` for self.
    ///
    /// - parameters:
    ///     - error: `Error` to throw if the type is not authed.
    public static func guardMiddleware(
        throwing error: Error = Abort(.unauthorized, reason: "\(Self.self) not authorized.")
    ) -> Middleware {
        return GuardAuthenticationMiddleware<Self>(throwing: error)
    }
}


/// This middleware ensures that an `AuthorizationPolicy` type `A` has been authorized
/// by a previous `Middleware` or throws an `Error`. The middlewares that actually perform
/// authorization will _not_ throw errors if they fail to authorize the user (except in
/// some exceptional cases like malformed data). This allows the middlewares to be composed
/// together to create chains of authorization for multiple types.
///
/// Use this middleware to protect routes that might not otherwise attempt to access the
/// authorized object (which always requires prior authorization).
///
/// Use `AuthorizationPolicy.guardMiddleware(...)` to create an instance.
private final class GuardAuthenticationMiddleware<A>: Middleware
    where A: AuthorizationPolicy
{
    /// Error to throw when guard fails.
    private let error: Error

    /// Creates a new `GuardAuthorizationMiddleware`.
    ///
    /// - parameters:
    ///     - type: `AuthorizationPolicy` type to ensure is authed.
    ///     - error: `Error` to throw if the type is not authed.
    internal init(_ type: A.Type = A.self, throwing error: Error) {
        self.error = error
    }

    /// See `Middleware`.
    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard req.isAuthorized(A.self) else {
            return req.eventLoop.makeFailedFuture(self.error)
        }
        return next.respond(to: req)
    }
}
