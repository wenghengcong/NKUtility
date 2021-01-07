//
//  MigrationLog.swift
//  TMLPersistentContainer
//
//  Distributed under the ISC license, see LICENSE.
//

import Foundation

/// The category of message being logged, in descending order of importance.
/// Clients should normally be interested in recording `error` and `warning` and
/// may also be interested in `info`.
public enum LogLevel: String {
    /// A message describing a condition that will eventually lead to a persistent store not being loaded.
    /// For example being unable to find an appropriate model for a persistent store.
    /// Rare, does not occur at all during normal operations.
    case error

    /// A message describing a condition that is unusual but does not immediately lead to a problem
    /// for the app.
    /// For example being unable to load a model from a file on disk.
    /// Rare, does not occur at all during normal operations.
    case warning

    /// A message describing normal progress of the library that may be of interest to
    /// an app developer.
    /// For example listing all discovered models and their relations.
    /// Occurs fairly often during normal operations (<1KiB for a complex migration).
    case info

    /// A message describing normal progress of the library that is probably only interesting
    /// when attempting to debug the library internals.
    /// Occurs often during normal operations.
    case debug
}

/// A log message generated by the library for the client to include in their logs.
/// These messages are intended to be human-readable although the audience is primarily
/// app developers; these are not intended for end users.
public struct LogMessage: CustomStringConvertible {

    /// The category of the log message.
    public let level: LogLevel

    /// A closure that vends the text of the log message.
    public let body: () -> String

    /// Create a new instance of a log messge.
    init(_ level: LogLevel, _ body: @autoclosure @escaping () -> String) {
        self.level = level
        self.body  = body
    }

    /// A string combining `level` and `body`.
    public var description: String {
        return level.rawValue + ": " + body()
    }

    /// A log message handler callback that can be passed to `NKPersistentContainer.init(...)`
    /// or `NKPersistentCloudKitContainer.init(...)` to receive various informational messages
    /// that may be of interest to clients for their own logs.
    public typealias Handler = (LogMessage) -> Void
}

/// Identifies a type that is able to send log messages.
protocol LogMessageEmitter {
    var logMessageHandler: LogMessage.Handler? { get }
}

/// Provide a low-typing routine to log a message.
extension LogMessageEmitter {
    func log(_ level: LogLevel, _ body: @autoclosure @escaping () -> String) {
        logMessageHandler?(LogMessage(level, body()))
    }
}