//
//  AuthorizationPolicy.swift
//  
//
//  Created by Jimmy McDermott on 11/3/19.
//

import Foundation
import Vapor
import NIO

public protocol AuthorizationPolicy {
    func isAuthorized(req: Request) -> EventLoopFuture<Bool>
}

extension AuthorizationPolicy {
    public func middleware() -> Middleware {
        return AuthorizationMiddleware<Self>(policy: self)
    }
}
