//
//  AuthenticationFeature.swift
//  SwiftUIPasskey
//
//  Model for authentication feature items
//

import Foundation

/// Represents an authentication feature that can be demonstrated
enum AuthenticationFeature: String, CaseIterable, Identifiable {
    case registration = "註冊 (Registration)"
    case passkeyOnly = "Passkey 登入 (Passkey Only)"
    case passkeyWithPassword = "Passkey + 密碼登入 (Hybrid)"
    case autofillPasskeyOnly = "AutoFill Passkey 登入"
    case immediateCredentials = "立即可用憑證 (Immediate Credentials)"
    case autofillHybrid = "AutoFill 完整體驗"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .registration:
            return "建立新的 Passkey 憑證"
        case .passkeyOnly:
            return "僅使用 Passkey 進行驗證"
        case .passkeyWithPassword:
            return "可選擇 Passkey 或密碼"
        case .autofillPasskeyOnly:
            return "純 AutoFill - 從 QuickType bar 選擇 Passkey"
        case .autofillHybrid:
            return "AutoFill + 備用按鈕的完整登入體驗"
        case .immediateCredentials:
            return "僅顯示立即可用的憑證"
        }
    }

    var icon: String {
        switch self {
        case .registration:
            return "person.badge.plus"
        case .passkeyOnly:
            return "key.fill"
        case .passkeyWithPassword:
            return "key.horizontal"
        case .autofillPasskeyOnly:
            return "keyboard.badge.ellipsis"
        case .autofillHybrid:
            return "keyboard"
        case .immediateCredentials:
            return "bolt.fill"
        }
    }
}
