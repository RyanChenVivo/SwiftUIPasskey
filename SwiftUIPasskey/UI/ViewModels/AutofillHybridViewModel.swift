//
//  AutofillHybridViewModel.swift
//  SwiftUIPasskey
//
//  ViewModel for autofill hybrid login flow (Passkey + Password)
//

import Foundation
import OSLog

@MainActor
@Observable
class AutofillHybridViewModel {
    var username: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var userInfo: UserInfo?

    private let authManager: PasskeyAuthenticationProtocol
    private let verificationService: VerificationService
    private var autoFillTask: Task<Void, Never>?

    init() {
        self.authManager = PasskeyAuthenticationManagerFactory.makeMockManager()
        self.verificationService = MockVerificationService()
    }

    /// Start AutoFill sign in when view appears (Hybrid mode: Passkey + Password)
    /// This operation waits passively for user selection from QuickType bar
    func startAutoFillSignIn() {
        // Cancel any existing task
        autoFillTask?.cancel()

        autoFillTask = Task {
            do {
                let usernameToUse = username.isEmpty ? nil : username
                let result = try await authManager.awaitAutoFillSignIn(username: usernameToUse)
                userInfo = result
            } catch {
                // Handle errors
                if let passkeyError = error as? PasskeyError {
                    if case .userCancelled = passkeyError {
                        // User cancelled (clicked button, navigated away, or no credentials) - silently ignore
                        PasskeyLogger.auth.info("AutoFill cancelled or no credentials available")
                    } else {
                        errorMessage = passkeyError.errorDescription
                    }
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    /// Stop AutoFill sign in and wait for cleanup to complete
    func stopAutoFillSignIn() async {
        guard let task = autoFillTask else { return }

        task.cancel()
        // Wait for the task to complete (cancellation to finish)
        _ = await task.result
        autoFillTask = nil
    }

    /// Sign in with hybrid mode (passkey + password option)
    /// Should be called when user explicitly clicks the sign-in button
    func signInWithHybrid() async {
        // Cancel autofill task when user decides to use button
        // Wait for cleanup to complete to prevent race condition
        await stopAutoFillSignIn()

        isLoading = true
        errorMessage = nil

        do {
            // Check if user has filled in both username and password
            // (likely from password autofill via QuickType bar)
            if !username.isEmpty && !password.isEmpty {
                // User has credentials filled in, use password authentication directly
                PasskeyLogger.auth.info("Using password authentication with filled credentials")

                // Verify password with VerificationService
                let result = try await verificationService.verifyPassword(username: username, password: password)
                userInfo = UserInfo(username: result.username, userID: result.userID)
            } else {
                // No credentials filled, show modal with passkey + password options
                let result = try await authManager.signInWithPasskeyAndPasswordOption(username: username)
                userInfo = result
            }
        } catch {
            if let passkeyError = error as? PasskeyError {
                errorMessage = passkeyError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }

        isLoading = false
    }
}
