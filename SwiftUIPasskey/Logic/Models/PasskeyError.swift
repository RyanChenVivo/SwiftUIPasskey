//
//  PasskeyError.swift
//  SwiftUIPasskey
//
//  Custom error types for Passkey authentication
//

import Foundation
import AuthenticationServices

/// Custom error types for Passkey authentication operations
enum PasskeyError: Error, LocalizedError {
    /// ASAuthorization framework error
    case authorizationFailed(Error)

    /// Window not available for presentation
    case windowUnavailable

    /// Failed to request challenge from server
    case challengeRequestFailed(Error)

    /// Credential verification failed
    case verificationFailed(Error)

    /// User cancelled the operation
    case userCancelled

    /// Unknown error occurred
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .authorizationFailed(let error):
            if let asError = error as? ASAuthorizationError {
                switch asError.code {
                case .canceled:
                    return "使用者取消了認證"
                case .failed:
                    return "認證失敗"
                case .invalidResponse:
                    return "收到無效的回應"
                case .notHandled:
                    return "認證請求未被處理"
                case .notInteractive:
                    return "無法進行互動式認證"
                case .unknown:
                    return "發生未知的認證錯誤"
                case .matchedExcludedCredential:
                    return "憑證已被排除"
                default:
                    return "認證錯誤: \(error.localizedDescription)"
                }
            }
            return "認證失敗: \(error.localizedDescription)"

        case .windowUnavailable:
            return "無法取得應用程式視窗"

        case .challengeRequestFailed(let error):
            return "無法取得挑戰: \(error.localizedDescription)"

        case .verificationFailed(let error):
            return "憑證驗證失敗: \(error.localizedDescription)"

        case .userCancelled:
            return "使用者取消了操作"

        case .unknown(let error):
            return "未知錯誤: \(error.localizedDescription)"
        }
    }
}
