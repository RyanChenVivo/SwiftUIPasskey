//
//  ImmediateCredentialsViewModel.swift
//  SwiftUIPasskey
//
//  ViewModel for immediate credentials login flow
//

import Foundation

@MainActor
@Observable
class ImmediateCredentialsViewModel {
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
            let result = try await authManager.signInWithImmediateCredentials()
            userInfo = result
        } catch {
            if let passkeyError = error as? PasskeyError {
                if case .userCancelled = passkeyError {
                    // For immediate credentials, userCancelled usually means no credentials available
                    errorMessage = "沒有可用的 Passkey，請先註冊"
                } else {
                    errorMessage = passkeyError.errorDescription
                }
            } else {
                errorMessage = error.localizedDescription
            }
        }

        isLoading = false
    }
}
