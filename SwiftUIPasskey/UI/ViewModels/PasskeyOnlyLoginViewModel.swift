//
//  PasskeyOnlyLoginViewModel.swift
//  SwiftUIPasskey
//
//  ViewModel for passkey-only login flow
//

import Foundation

@MainActor
@Observable
class PasskeyOnlyLoginViewModel {
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
            let result = try await authManager.signInWithPasskeyOnly()
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
