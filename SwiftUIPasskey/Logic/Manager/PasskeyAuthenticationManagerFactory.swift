//
//  PasskeyAuthenticationManagerFactory.swift
//  SwiftUIPasskey
//
//  Factory for creating PasskeyAuthenticationManager instances
//

import Foundation

/// Factory for creating authentication manager instances with appropriate configuration
@MainActor
class PasskeyAuthenticationManagerFactory {
    /// Create authentication manager with mock dependencies for demo/testing
    /// - Returns: Configured authentication manager with mock services
    static func makeMockManager() -> PasskeyAuthenticationProtocol {
        let challengeService = MockChallengeService()
        let verificationService = MockVerificationService()
        let windowProvider = DefaultWindowProvider()

        return PasskeyAuthenticationManager(
            challengeService: challengeService,
            verificationService: verificationService,
            windowProvider: windowProvider
        )
    }

    /// Create authentication manager with production dependencies
    /// - Returns: Configured authentication manager with real services
    /// - Note: For this demo, this returns the same as makeMockManager
    ///         In production, this would use real service implementations
    static func makeProductionManager() -> PasskeyAuthenticationProtocol {
        // In a real app, you would inject real service implementations here
        // For this demo, we use mock services
        return makeMockManager()
    }
}
