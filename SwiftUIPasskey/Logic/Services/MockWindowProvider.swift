//
//  MockWindowProvider.swift
//  SwiftUIPasskey
//
//  Mock implementation of WindowProvider for testing
//

import UIKit

/// Mock window provider for testing purposes
class MockWindowProvider: WindowProvider {
    var mockWindow: UIWindow?

    init(mockWindow: UIWindow? = nil) {
        self.mockWindow = mockWindow
    }

    func getWindow() -> UIWindow? {
        return mockWindow
    }
}
