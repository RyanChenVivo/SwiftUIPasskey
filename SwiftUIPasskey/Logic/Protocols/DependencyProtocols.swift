//
//  DependencyProtocols.swift
//  SwiftUIPasskey
//
//  Protocols for injectable dependencies
//

import Foundation
import UIKit

/// Protocol for challenge service
protocol ChallengeService {
    /// Get authentication challenge for specific username (non-discoverable)
    /// - Parameter username: The username to get challenge for
    /// - Returns: Challenge data
    /// - Throws: Error if challenge request fails
    func getChallenge(for username: String) async throws -> ChallengeData

    /// Get general authentication challenge (for discoverable credentials)
    /// - Returns: Challenge data without user-specific information
    /// - Throws: Error if challenge request fails
    /// - Note: Used for Passkey-only login where userID is retrieved from the credential
    func getGeneralChallenge() async throws -> ChallengeData
}

/// Protocol for verification service
protocol VerificationService {
    /// Verify credential data
    /// - Parameter credential: The credential data to verify
    /// - Returns: Verification result
    /// - Throws: Error if verification fails
    func verify(credential: CredentialData) async throws -> VerificationResult

    /// Verify password-based authentication
    /// - Parameters:
    ///   - username: The username
    ///   - password: The password
    /// - Returns: Verification result
    /// - Throws: Error if verification fails
    func verifyPassword(username: String, password: String) async throws -> VerificationResult
}

/// Protocol for window provider
protocol WindowProvider {
    /// Get the current window for presentation
    /// - Returns: UIWindow if available, nil otherwise
    func getWindow() -> UIWindow?
}
