# Proposal: Add Passkey Demo App

## Why

Create a comprehensive demo application to research and showcase iOS Passkey authentication capabilities. This will provide a practical implementation reference for Passkey APIs including registration, login (with various modes), and autofill functionality.

## What Changes

- Add a logic layer that provides interfaces for Passkey operations (registration, login, autofill)
- Implement ASAuthorization framework integration with proper protocol conformance
- Design the logic layer using modern Swift concurrency (async/await, Actor)
- Implement dependency injection for testability with mock server support
- Create a factory pattern for logic layer instantiation
- Add SwiftUI-based demonstration interface showing all Passkey scenarios
- Implement multiple authentication flows: registration, passkey-only login, passkey + password option, autofill, and preferImmediatelyAvailableCredentials mode
- Create viewModels for each flow with unified error handling
- Add success screens and navigation flow between features

## Impact

- Affected specs:
  - New: `passkey-logic` (authentication logic layer)
  - New: `passkey-ui` (demonstration interface)
- Affected code:
  - New files for Passkey authentication manager
  - New files for dependency injection and factory pattern
  - New SwiftUI views and viewModels for each authentication scenario
  - Minimal changes to existing ContentView.swift to integrate feature list
