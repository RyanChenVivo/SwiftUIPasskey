//
//  MockVerificationService.swift
//  SwiftUIPasskey
//
//  Mock implementation of VerificationService for testing and demo
//

import Foundation
internal import os
import OSLog

/// Mock verification service that simulates credential verification
class MockVerificationService: VerificationService {
    func verify(credential: CredentialData) async throws -> VerificationResult {
        PasskeyLogger.verification.info("Mock: Verifying credential")

        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Extract username from userID if available
        let username: String
        if let userID = credential.userID,
           let usernameString = String(data: userID, encoding: .utf8) {
            username = usernameString
        } else {
            username = "demo_user"
        }

        PasskeyLogger.verification.info("Mock: Verification successful for user: \(username)")

        return VerificationResult(
            success: true,
            username: username,
            userID: UUID().uuidString
        )
    }

    func verifyPassword(username: String, password: String) async throws -> VerificationResult {
        PasskeyLogger.verification.info("Mock: Verifying password for user: \(username)")

        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // In a real app, you would:
        // 1. Send username + password to server
        // 2. Server validates against stored hash
        // 3. Return user data if valid, error if invalid

        // For demo purposes, we accept any non-empty password
        guard !password.isEmpty else {
            PasskeyLogger.verification.error("Mock: Password verification failed - empty password")
            throw NSError(domain: "PasswordVerification", code: 401, userInfo: [
                NSLocalizedDescriptionKey: "密碼不能為空"
            ])
        }

        PasskeyLogger.verification.info("Mock: Password verification successful for user: \(username)")

        return VerificationResult(
            success: true,
            username: username,
            userID: UUID().uuidString
        )
    }
}
