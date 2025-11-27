//
//  AutofillPasskeyOnlyViewModel.swift
//  SwiftUIPasskey
//
//  ViewModel for autofill passkey-only login flow
//

import Foundation
import OSLog

@MainActor
@Observable
class AutofillPasskeyOnlyViewModel {
    var username: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var userInfo: UserInfo?

    private let authManager: PasskeyAuthenticationProtocol
    private var autoFillTask: Task<Void, Never>?

    init() {
        self.authManager = PasskeyAuthenticationManagerFactory.makeMockManager()
    }

    /// Start AutoFill sign in when view appears (Passkey only)
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
                        // User cancelled (navigated away or no passkey) - silently ignore
                        PasskeyLogger.auth.info("AutoFill cancelled or no passkey available")
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
}
