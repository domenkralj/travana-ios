//
//  HttpError.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

/// Describes HTTP errors when making requests
enum HttpError: Error {
    case NoDataError
    case ObjectIsNotResponse
    case InvalidUrl(url: String)
    case CustomError(message: String, statusCode: Int)
    case NoInternectConnection
}

