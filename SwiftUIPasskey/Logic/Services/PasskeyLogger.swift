//
//  PasskeyLogger.swift
//  SwiftUIPasskey
//
//  Logging configuration for Passkey operations
//

import Foundation
import OSLog

/// Logger for Passkey authentication operations
struct PasskeyLogger {
    /// Subsystem identifier for logging
    static let subsystem = "com.swiftuipasskey.demo"

    /// Logger instance for authentication operations
    static let auth = Logger(subsystem: subsystem, category: "Authentication")

    /// Logger instance for challenges
    static let challenge = Logger(subsystem: subsystem, category: "Challenge")

    /// Logger instance for verification
    static let verification = Logger(subsystem: subsystem, category: "Verification")
}
