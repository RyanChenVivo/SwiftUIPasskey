//
//  MockChallengeService.swift
//  SwiftUIPasskey
//
//  Mock implementation of ChallengeService for testing and demo
//

import Foundation
import OSLog

/// Mock challenge service that returns simulated challenge data
class MockChallengeService: ChallengeService {
    func getChallenge(for username: String) async throws -> ChallengeData {
        PasskeyLogger.challenge.info("Mock: Getting challenge for username: \(username)")

        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Generate mock challenge data
        let challenge = UUID().uuidString.data(using: .utf8) ?? Data()
        let userID = username.data(using: .utf8) ?? Data()

        PasskeyLogger.challenge.info("Mock: Challenge generated successfully")

        return ChallengeData(
            challenge: challenge,
            userID: userID,
            username: username
        )
    }

    func getGeneralChallenge() async throws -> ChallengeData {
        PasskeyLogger.challenge.info("Mock: Getting general challenge (discoverable)")

        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Generate general challenge (not user-specific)
        let challenge = UUID().uuidString.data(using: .utf8) ?? Data()

        // For discoverable credentials, userID and username are not known yet
        // They will be retrieved from the credential itself
        let emptyData = Data()

        PasskeyLogger.challenge.info("Mock: General challenge generated successfully")

        return ChallengeData(
            challenge: challenge,
            userID: emptyData,  // Empty because user is unknown
            username: ""  // Empty because user is unknown
        )
    }
}
