//
//  Response.swift
//  travana
//
//  Created by Domen Kralj on 08/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class Response<T> {
    
    public var success: Bool = false
    public var error: Error?
    public var data: T?
    
    public static func success(data: T) -> Response<T> {
        let response = Response<T>()
        response.data = data
        response.success = true
    
        return response
    }
    
    public static func failure(error: Error) -> Response<T> {
        let response = Response<T>()
        response.error = error
        response.success = false
        return response
    }
}
