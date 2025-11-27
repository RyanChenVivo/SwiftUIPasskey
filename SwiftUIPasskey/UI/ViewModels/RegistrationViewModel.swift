//
//  RegistrationViewModel.swift
//  SwiftUIPasskey
//
//  ViewModel for registration flow
//

import Foundation

@MainActor
@Observable
class RegistrationViewModel {
    var username: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var userInfo: UserInfo?

    private let authManager: PasskeyAuthenticationProtocol

    init() {
        self.authManager = PasskeyAuthenticationManagerFactory.makeMockManager()
    }

    func register() async {
        guard !username.isEmpty else {
            errorMessage = "請輸入使用者名稱"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await authManager.register(username: username)
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
