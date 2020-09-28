//
//  Logger.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import Willow

/// - Produces custom logger instances that utilize a single dispatch queue
class LoggerFactory {
    
    private static let sharedLogQueue = DispatchQueue(label: "LoggerFactory", qos: .utility)
    private static let writers = [ConsoleWriter()]
    
    static func getLogger(name: String, logLevels: LogLevel = .all) -> ConsoleLogger {
        return ConsoleLogger(name:name, rawLogger: Logger(logLevels: logLevels,
                      writers: self.writers,
                      executionMethod: .asynchronous(queue: sharedLogQueue)))
    }
}

/// - https://medium.com/joshtastic-blog/convenient-logging-in-swift-75e1adf6ba7c
class ConsoleLogger {
    let name: String
    let log: Logger
    
    init(name: String, rawLogger: Logger) {
        self.name = name
        self.log = rawLogger
    }
    
    private func modifyMessage(_ message: String, with logLevel: LogLevel, error: NSError? = nil) -> String {
        return "[\(String(describing: logLevel).uppercased())] - \(name) - \(message) \(error?.localizedDescription ?? "")"
    }
    
    func debug(_ message: String) {
        self.log.debugMessage(self.modifyMessage(message, with: .debug))
    }
    
    func info(_ message: String) {
        self.log.infoMessage(self.modifyMessage(message, with: .info))
    }
    
    func event(_ message: String) {
        self.log.eventMessage(self.modifyMessage(message, with: .event))
    }
    
    func warn(_ message: String) {
        self.log.warnMessage(self.modifyMessage(message, with: .warn))
    }
    
    func error(_ message: String) {
        self.log.errorMessage(self.modifyMessage(message, with: .error))
    }
    
    func error(_ message: String, e: Error) {
        let nsErr = e as NSError
        self.log.errorMessage(self.modifyMessage(message, with: .error, error: nsErr))
    }
}
