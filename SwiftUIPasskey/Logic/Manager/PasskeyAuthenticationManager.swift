//
//  PasskeyAuthenticationManager.swift
//  SwiftUIPasskey
//
//  Main authentication manager implementing Passkey operations
//

import Foundation
import AuthenticationServices
import OSLog

/// Main authentication manager for Passkey operations
@MainActor
class PasskeyAuthenticationManager: NSObject, PasskeyAuthenticationProtocol {
    // MARK: - Constants
    /// Relying Party Identifier for Passkey authentication
    private static let relyingPartyIdentifier = "portal.dev.vortexcloud.com"

    // MARK: - Dependencies
    private let challengeService: ChallengeService
    private let verificationService: VerificationService
    private let windowProvider: WindowProvider

    // MARK: - State
    private var currentAuthController: ASAuthorizationController?
    private var authenticationContinuation: CheckedContinuation<ASAuthorization, Error>?

    // MARK: - Initialization
    init(
        challengeService: ChallengeService,
        verificationService: VerificationService,
        windowProvider: WindowProvider
    ) {
        self.challengeService = challengeService
        self.verificationService = verificationService
        self.windowProvider = windowProvider
        super.init()
    }

    // MARK: - PasskeyAuthenticationProtocol

    func register(username: String) async throws -> UserInfo {
        PasskeyLogger.auth.info("Starting registration for username: \(username)")

        do {
            // Get challenge from server
            let challengeData = try await challengeService.getChallenge(for: username)

            // Create platform key credential provider
            let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: Self.relyingPartyIdentifier
            )

            // Create registration request
            let registrationRequest = platformProvider.createCredentialRegistrationRequest(
                challenge: challengeData.challenge,
                name: username,
                userID: challengeData.userID
            )

            // Perform authorization
            let authorization = try await performAuthorization(requests: [registrationRequest])

            // Process credential
            guard let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration else {
                throw PasskeyError.authorizationFailed(NSError(domain: "PasskeyAuth", code: -1))
            }

            // In a real app, you would send the credential to the server for verification
            // For this demo, we just log the successful registration
            PasskeyLogger.auth.info("Registration successful for username: \(username)")
            PasskeyLogger.auth.debug("Credential ID: \(credential.credentialID.base64EncodedString())")

            // Return user info without server verification
            return UserInfo(username: username, userID: String(data: challengeData.userID, encoding: .utf8) ?? "")

        } catch {
            PasskeyLogger.auth.error("Registration failed: \(error.localizedDescription)")
            throw mapError(error)
        }
    }

    func signInWithPasskeyOnly() async throws -> UserInfo {
        PasskeyLogger.auth.info("Starting passkey-only sign in (discoverable credentials)")

        do {
            // Get general challenge from server (no username needed)
            // For discoverable credentials, userID will be retrieved from the credential itself
            let challengeData = try await challengeService.getGeneralChallenge()

            // Create platform key credential provider
            let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: Self.relyingPartyIdentifier
            )

            // Create assertion request
            let assertionRequest = platformProvider.createCredentialAssertionRequest(
                challenge: challengeData.challenge
            )

            // Perform authorization
            let authorization = try await performAuthorization(requests: [assertionRequest])

            // Process credential
            guard let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion else {
                throw PasskeyError.authorizationFailed(NSError(domain: "PasskeyAuth", code: -1))
            }

            // Verify with server
            let credentialData = CredentialData(
                credentialID: credential.credentialID,
                authenticatorData: credential.rawAuthenticatorData,
                signature: credential.signature,
                clientDataJSON: credential.rawClientDataJSON,
                userID: credential.userID
            )

            let result = try await verificationService.verify(credential: credentialData)

            PasskeyLogger.auth.info("Passkey-only sign in successful for user: \(result.username)")

            return UserInfo(username: result.username, userID: result.userID)

        } catch {
            PasskeyLogger.auth.error("Passkey-only sign in failed: \(error.localizedDescription)")
            throw mapError(error)
        }
    }

    func signInWithPasskeyAndPasswordOption(username: String) async throws -> UserInfo {
        PasskeyLogger.auth.info("Starting hybrid sign in (passkey + password)")

        do {
            // Get challenge from server
            // Use general challenge for discoverable credentials (empty username)
            let challengeData: ChallengeData
            if username.isEmpty {
                challengeData = try await challengeService.getGeneralChallenge()
            } else {
                challengeData = try await challengeService.getChallenge(for: username)
            }

            // Create platform key credential provider
            let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: Self.relyingPartyIdentifier
            )

            // Create assertion request
            let assertionRequest = platformProvider.createCredentialAssertionRequest(
                challenge: challengeData.challenge
            )

            // Create password provider (for hybrid mode)
            let passwordProvider = ASAuthorizationPasswordProvider()
            let passwordRequest = passwordProvider.createRequest()

            // Perform authorization with both requests
            let authorization = try await performAuthorization(requests: [assertionRequest, passwordRequest])

            // Check credential type
            if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
                // Passkey credential
                let credentialData = CredentialData(
                    credentialID: credential.credentialID,
                    authenticatorData: credential.rawAuthenticatorData,
                    signature: credential.signature,
                    clientDataJSON: credential.rawClientDataJSON,
                    userID: credential.userID
                )

                let result = try await verificationService.verify(credential: credentialData)
                PasskeyLogger.auth.info("Hybrid sign in successful (passkey) for user: \(result.username)")

                return UserInfo(username: result.username, userID: result.userID)

            } else if let credential = authorization.credential as? ASPasswordCredential {
                // Password credential (mock verification)
                PasskeyLogger.auth.info("Hybrid sign in successful (password) for user: \(credential.user)")

                return UserInfo(username: credential.user, userID: UUID().uuidString)
            } else {
                throw PasskeyError.authorizationFailed(NSError(domain: "PasskeyAuth", code: -1))
            }

        } catch {
            PasskeyLogger.auth.error("Hybrid sign in failed: \(error.localizedDescription)")
            throw mapError(error)
        }
    }

    func awaitAutoFillSignIn(username: String?) async throws -> UserInfo {
        PasskeyLogger.auth.info("Awaiting AutoFill sign in")

        do {
            // Get challenge from server
            let challengeData: ChallengeData
            if let username = username, !username.isEmpty {
                // User provided username, get specific challenge
                challengeData = try await challengeService.getChallenge(for: username)
                PasskeyLogger.auth.info("Autofill with username: \(username)")
            } else {
                // No username, use general challenge
                challengeData = try await challengeService.getGeneralChallenge()
                PasskeyLogger.auth.info("Autofill without username (discoverable)")
            }

            // Create platform key credential provider
            let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: Self.relyingPartyIdentifier
            )

            // Create assertion request
            let assertionRequest = platformProvider.createCredentialAssertionRequest(
                challenge: challengeData.challenge
            )

            // Note: performAutoFillAssistedRequests only supports passkey requests
            // Password autofill is handled by iOS system (via .textContentType(.password))
            let authorization = try await performAutoFillAssistedAuthorization(requests: [assertionRequest])

            // Process credential
            guard let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion else {
                throw PasskeyError.authorizationFailed(NSError(domain: "PasskeyAuth", code: -1))
            }

            // Verify with server
            let credentialData = CredentialData(
                credentialID: credential.credentialID,
                authenticatorData: credential.rawAuthenticatorData,
                signature: credential.signature,
                clientDataJSON: credential.rawClientDataJSON,
                userID: credential.userID
            )

            let result = try await verificationService.verify(credential: credentialData)
            PasskeyLogger.auth.info("Autofill sign in successful for user: \(result.username)")

            return UserInfo(username: result.username, userID: result.userID)

        } catch {
            PasskeyLogger.auth.error("Autofill sign in failed: \(error.localizedDescription)")
            throw mapError(error)
        }
    }

    func signInWithImmediateCredentials() async throws -> UserInfo {
        PasskeyLogger.auth.info("Starting immediate credentials sign in (discoverable)")

        do {
            // Get general challenge from server (no username needed for discoverable)
            let challengeData = try await challengeService.getGeneralChallenge()

            // Create platform key credential provider
            let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: Self.relyingPartyIdentifier
            )

            // Create assertion request
            let assertionRequest = platformProvider.createCredentialAssertionRequest(
                challenge: challengeData.challenge
            )

            // Perform authorization with preferImmediatelyAvailableCredentials
            let authorization = try await performAuthorization(
                requests: [assertionRequest],
                preferImmediatelyAvailableCredentials: true
            )

            // Process credential
            guard let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion else {
                throw PasskeyError.authorizationFailed(NSError(domain: "PasskeyAuth", code: -1))
            }

            // Verify with server
            let credentialData = CredentialData(
                credentialID: credential.credentialID,
                authenticatorData: credential.rawAuthenticatorData,
                signature: credential.signature,
                clientDataJSON: credential.rawClientDataJSON,
                userID: credential.userID
            )

            let result = try await verificationService.verify(credential: credentialData)

            PasskeyLogger.auth.info("Immediate credentials sign in successful for user: \(result.username)")

            return UserInfo(username: result.username, userID: result.userID)

        } catch {
            PasskeyLogger.auth.error("Immediate credentials sign in failed: \(error.localizedDescription)")
            throw mapError(error)
        }
    }

    // MARK: - Private Helpers

    private func performAuthorization(
        requests: [ASAuthorizationRequest],
        preferImmediatelyAvailableCredentials: Bool = false
    ) async throws -> ASAuthorization {
        return try await withCheckedThrowingContinuation { continuation in
            authenticationContinuation = continuation

            let controller = ASAuthorizationController(authorizationRequests: requests)
            controller.delegate = self
            controller.presentationContextProvider = self

            // Save controller reference to keep it alive during async operation
            currentAuthController = controller

            if preferImmediatelyAvailableCredentials {
                controller.performRequests(options: .preferImmediatelyAvailableCredentials)
            } else {
                controller.performRequests()
            }
        }
    }

    private func performAutoFillAssistedAuthorization(
        requests: [ASAuthorizationRequest]
    ) async throws -> ASAuthorization {
        // Check if a modal request is in progress
        // AutoFill should not interrupt modal requests
        guard currentAuthController == nil else {
            PasskeyLogger.auth.info("Modal request in progress, skipping AutoFill request")
            throw PasskeyError.userCancelled  // Silent failure for AutoFill
        }

        // Use withTaskCancellationHandler to automatically clean up on cancellation
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let controller = ASAuthorizationController(authorizationRequests: requests)
                controller.delegate = self
                controller.presentationContextProvider = self

                // Save references BEFORE performing the request
                authenticationContinuation = continuation
                currentAuthController = controller

                // Use AutoFill-assisted requests for QuickType bar integration
                controller.performAutoFillAssistedRequests()
            }
        } onCancel: {
            // onCancel executes synchronously when Task.cancel() is called
            // Clean up immediately to prevent affecting subsequent requests
            Task { @MainActor in
                PasskeyLogger.auth.info("AutoFill task cancelled, cleaning up resources")
                self.currentAuthController?.cancel()
                self.currentAuthController = nil
                self.authenticationContinuation?.resume(throwing: PasskeyError.userCancelled)
                self.authenticationContinuation = nil
            }
        }
    }

    private func mapError(_ error: Error) -> PasskeyError {
        if let passkeyError = error as? PasskeyError {
            return passkeyError
        }

        if let asError = error as? ASAuthorizationError {
            if asError.code == .canceled {
                return .userCancelled
            }
            return .authorizationFailed(asError)
        }

        return .unknown(error)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension PasskeyAuthenticationManager: ASAuthorizationControllerDelegate {
    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task { @MainActor in
            authenticationContinuation?.resume(returning: authorization)
            authenticationContinuation = nil
            currentAuthController = nil
        }
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            authenticationContinuation?.resume(throwing: error)
            authenticationContinuation = nil
            currentAuthController = nil
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension PasskeyAuthenticationManager: ASAuthorizationControllerPresentationContextProviding {
    nonisolated func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return windowProvider.getWindow() ?? ASPresentationAnchor()
    }
}
