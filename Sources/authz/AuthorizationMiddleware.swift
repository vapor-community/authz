//
//  AuthorizationMiddleware.swift
//  
//
//  Created by Jimmy McDermott on 11/3/19.
//

import Foundation
import Vapor

final class AuthorizationMiddleware<A>: Middleware
    where A: AuthorizationPolicy
{
    public let policy: A

    public init(policy: A) {
        self.policy = policy
    }

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return self.policy.isAuthorized(req: request).flatMap { isAuthed in
            if isAuthed {
                request.authorize(self.policy)
            }
            
            return next.respond(to: request)
        }
    }
}
