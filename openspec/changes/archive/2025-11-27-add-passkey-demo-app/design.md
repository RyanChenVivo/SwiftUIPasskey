# Design Document: Passkey Demo App

## Context

This project aims to create a comprehensive iOS demo application for researching and showcasing Passkey authentication capabilities. The app serves as both a learning tool and reference implementation for integrating Apple's AuthenticationServices framework with modern Swift patterns.

**Constraints:**
- Must support iOS 16+ (for Passkey APIs)
- SwiftUI-based UI implementation
- No real backend server required (demo/mock mode)
- Must demonstrate all major Passkey authentication scenarios

**Stakeholders:**
- Developer (for learning and reference)
- Potential users reviewing Passkey implementation patterns

## Goals / Non-Goals

### Goals
- Create a clean separation between authentication logic and UI presentation
- Demonstrate all major Passkey authentication flows (registration, login variants, autofill)
- Implement testable architecture using dependency injection
- Provide mock implementations for standalone operation
- Use modern Swift concurrency patterns (async/await, Actor)
- Show proper error handling and logging

### Non-Goals
- Real server-side implementation (mocks are sufficient)
- Production-ready security measures
- Multi-user account management
- Persistent storage of credentials
- Comprehensive test coverage (demo focused)

## Decisions

### Decision: Two-Layer Architecture

**What:** Separate authentication logic layer from UI presentation layer

**Why:**
- Clear separation of concerns
- Logic layer can be reused independently of UI
- Easier testing with mock dependencies
- Follows iOS best practices for framework integration

**Implementation:**
- Logic layer: Protocols, authentication manager, dependency injection
- UI layer: SwiftUI views, viewModels, navigation

### Decision: Protocol-Based Dependency Injection

**What:** Use protocols to define dependencies (challenge service, verification service, window provider) and inject them into authentication manager

**Why:**
- Enables testing without real server
- Allows easy swapping between mock and real implementations
- Reduces coupling between components
- Standard iOS pattern for testability

**Implementation:**
```swift
protocol ChallengeService {
    func getChallenge(for username: String) async throws -> ChallengeData
}

protocol VerificationService {
    func verify(credential: Credential) async throws -> VerificationResult
}

protocol WindowProvider {
    func getWindow() -> UIWindow?
}
```

### Decision: Factory Pattern for Instantiation

**What:** Provide factory class to create configured authentication manager instances

**Why:**
- Centralizes dependency configuration
- Simplifies viewModel initialization
- Easy to provide mock vs. production configurations
- Common pattern in iOS development

**Implementation:**
```swift
class AuthenticationManagerFactory {
    static func makeMockManager() -> AuthenticationManager
    static func makeProductionManager() -> AuthenticationManager
}
```

### Decision: Async/Await for ASAuthorization Bridge

**What:** Bridge ASAuthorizationController delegate callbacks to async/await using continuations

**Why:**
- Modern Swift concurrency pattern
- Cleaner caller code compared to delegate callbacks
- Better error propagation
- Natural fit for viewModel usage

**Alternatives considered:**
- Combine publishers: More complex, not needed for one-shot operations
- Callback closures: Less type-safe, harder to compose

### Decision: Custom Error Types

**What:** Define custom error enum wrapping ASAuthorization errors and application errors

**Why:**
- Provides context for error sources
- Enables user-friendly error messages
- Allows consistent error handling across UI layer
- Can add debugging information

**Implementation:**
```swift
enum PasskeyError: Error {
    case authorizationFailed(ASAuthorizationError)
    case windowUnavailable
    case challengeRequestFailed(Error)
    case verificationFailed(Error)
}
```

### Decision: Window Provider Abstraction

**What:** Abstract UIWindow lookup into injectable WindowProvider dependency

**Why:**
- ASAuthorizationControllerPresentationContextProviding requires window
- Window lookup involves UIApplication.shared.connectedScenes (hard to test)
- Abstraction enables mock window provider for tests
- Single responsibility principle

### Decision: Actor for Authentication Manager

**What:** Consider using Actor for authentication manager if shared mutable state exists

**Why:**
- Ensures thread-safety for concurrent access
- Prevents data races
- Modern Swift concurrency best practice

**Note:** May not be needed if authentication operations are inherently sequential per manager instance. Evaluate during implementation.

### Decision: Unified Screen Layout Pattern

**What:** All authentication flow screens follow same layout: input field + action button

**Why:**
- Consistent user experience
- Reduces code duplication
- Focus is on demonstrating API differences, not UI variety
- Simpler implementation and maintenance

### Decision: Mock Services with Hardcoded Responses

**What:** Mock services return hardcoded success responses after short delay

**Why:**
- No server required for demo
- Simulates async network behavior
- Sufficient for demonstration purposes
- Can be enhanced later if needed

## Risks / Trade-offs

### Risk: Passkey requires physical device or simulator with proper entitlements
- **Mitigation:** Document setup requirements clearly; ensure proper entitlements in Xcode project

### Risk: Mock implementation may diverge from real server behavior
- **Mitigation:** Document that mocks are for demo only; structure makes replacing mocks straightforward

### Trade-off: No persistent storage
- **Benefit:** Simpler implementation for demo
- **Downside:** User must re-register each app launch
- **Acceptable:** Demo purpose makes this trade-off reasonable

### Trade-off: Actor usage decision deferred
- **Benefit:** Avoid premature optimization
- **Risk:** May need refactoring if concurrency issues emerge
- **Mitigation:** Evaluate during implementation; Swift will warn about data races

## Migration Plan

N/A - This is a new application with no existing users or data to migrate.

## Open Questions

1. **Should we implement actual server endpoints or keep mocks only?**
   - For now: Mocks only. Can extend later if needed.

2. **What should mock verification responses include?**
   - For now: Simple success/failure with hardcoded user data.

3. **Should we persist any demo state between launches?**
   - For now: No persistence. Each launch starts fresh.

4. **Do we need to demonstrate error scenarios explicitly?**
   - For now: Focus on happy paths; error handling is present but not showcased as separate flows.

5. **Should logging be configurable or always enabled?**
   - For now: Always enabled with OSLog; can be filtered by subsystem in Console.app.
