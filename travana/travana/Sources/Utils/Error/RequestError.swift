//
//  RequestError.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

/// Describes errors thet happen when interacting with easydriver services
enum RequestError : Error {
    case AuthenticationFailed(_ message: String)
    case RequestFailedException(_ message: String, error: Error? = nil)
    case IllegalArgumentException(_ message: String)
    case IllegalStateException(_ message: String)
    case AsyncTimeoutException(_ message: String)
    case BluetoothRequestFailedException(_ status: Int)
    case UnreachableException(_ message: String)
    case MalformedMessageException(_ message: String)
}
