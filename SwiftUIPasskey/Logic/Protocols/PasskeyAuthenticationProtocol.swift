//
//  PasskeyAuthenticationProtocol.swift
//  SwiftUIPasskey
//
//  Protocol for Passkey authentication operations
//

import Foundation

/// Protocol defining Passkey authentication operations
protocol PasskeyAuthenticationProtocol {
    /// Register a new passkey for the given username
    /// - Parameter username: The username to register
    /// - Returns: UserInfo on successful registration
    /// - Throws: PasskeyError if registration fails
    func register(username: String) async throws -> UserInfo

    /// Sign in using passkey only (no password option)
    /// - Returns: UserInfo on successful authentication
    /// - Throws: PasskeyError if authentication fails
    /// - Note: System will present available passkeys for user to choose from
    func signInWithPasskeyOnly() async throws -> UserInfo

    /// Sign in with passkey and password option
    /// - Parameter username: The username to authenticate (optional, can be empty for discoverable credentials)
    /// - Returns: UserInfo on successful authentication
    /// - Throws: PasskeyError if authentication fails
    /// - Note: System will present both passkey and password options for user to choose
    func signInWithPasskeyAndPasswordOption(username: String) async throws -> UserInfo

    /// Await for user to select a passkey from AutoFill QuickType bar
    /// - Parameter username: Optional username for context
    /// - Returns: UserInfo when user selects a passkey
    /// - Throws: PasskeyError or CancellationError if task is cancelled
    /// - Note: This operation waits passively for user selection from QuickType bar.
    ///         Only passkey credentials are supported (password autofill is handled by iOS system).
    ///         Cancel the task (e.g., using SwiftUI's .task modifier) to clean up resources.
    func awaitAutoFillSignIn(username: String?) async throws -> UserInfo

    /// Sign in with preferImmediatelyAvailableCredentials option
    /// - Returns: UserInfo on successful authentication
    /// - Throws: PasskeyError if authentication fails
    /// - Note: Only shows immediately available credentials without requiring user interaction
    func signInWithImmediateCredentials() async throws -> UserInfo
}
