//
//  DefaultWindowProvider.swift
//  SwiftUIPasskey
//
//  Default implementation of WindowProvider
//

import UIKit

/// Default window provider that finds active window from connected scenes
class DefaultWindowProvider: WindowProvider {
    func getWindow() -> UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else {
            return nil
        }

        return windowScene.windows.first { $0.isKeyWindow } ?? windowScene.windows.first
    }
}
