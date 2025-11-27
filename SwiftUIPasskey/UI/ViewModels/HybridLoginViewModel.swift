//
//  HybridLoginViewModel.swift
//  SwiftUIPasskey
//
//  ViewModel for hybrid login flow (passkey + password)
//

import Foundation

@MainActor
@Observable
class HybridLoginViewModel {
    var username: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var userInfo: UserInfo?

    private let authManager: PasskeyAuthenticationProtocol

    init() {
        self.authManager = PasskeyAuthenticationManagerFactory.makeMockManager()
    }

    func signIn() async {
        isLoading = true
        errorMessage = nil

        do {
            // Username can be empty for discoverable credentials
            let result = try await authManager.signInWithPasskeyAndPasswordOption(username: username)
            userInfo = result
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
