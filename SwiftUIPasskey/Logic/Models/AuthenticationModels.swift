//
//  AuthenticationModels.swift
//  SwiftUIPasskey
//
//  Data models for authentication
//

import Foundation

/// Challenge data for authentication
struct ChallengeData {
    let challenge: Data
    let userID: Data
    let username: String
}

/// Credential data for verification
struct CredentialData {
    let credentialID: Data
    let authenticatorData: Data
    let signature: Data
    let clientDataJSON: Data
    let userID: Data?
}

/// Verification result
struct VerificationResult {
    let success: Bool
    let username: String
    let userID: String
}

/// User information
struct UserInfo {
    let username: String
    let userID: String
}
