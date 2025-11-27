# Passkey Logic Spec Delta

## ADDED Requirements

### Requirement: Passkey Authentication Interface

The system SHALL provide a protocol-based interface for Passkey authentication operations including registration, login, and autofill functionality.

#### Scenario: Registration flow interface

- **WHEN** caller requests passkey registration with assertionRequest parameters
- **THEN** the interface SHALL expose an async method that returns registration result or throws an error

#### Scenario: Login flow interface

- **WHEN** caller requests passkey authentication with passwordRequest parameters
- **THEN** the interface SHALL expose an async method that returns authentication result or throws an error

#### Scenario: Autofill interface

- **WHEN** caller requests autofill-enabled authentication
- **THEN** the interface SHALL provide an async method supporting autofill context

### Requirement: ASAuthorization Protocol Conformance

The authentication manager SHALL conform to ASAuthorizationControllerPresentationContextProviding and ASAuthorizationControllerDelegate protocols.

#### Scenario: Presentation anchor provider

- **WHEN** ASAuthorization controller requests presentation anchor
- **THEN** the manager SHALL provide a valid ASPresentationAnchor (window)

#### Scenario: Authorization completion

- **WHEN** authorization completes successfully or with error
- **THEN** the delegate methods SHALL handle the result and propagate to async callers

### Requirement: Swift Concurrency Design

The authentication logic layer SHALL be designed using modern Swift concurrency patterns including async/await and Actor where appropriate.

#### Scenario: Async authentication methods

- **WHEN** authentication operations are called
- **THEN** methods SHALL use async/await for asynchronous execution

#### Scenario: Thread-safe state management

- **WHEN** multiple authentication operations may occur
- **THEN** shared mutable state SHALL be protected using Actor or appropriate synchronization

### Requirement: Custom Error Handling

The system SHALL define custom error types that encapsulate both system-provided ASAuthorization errors and application-specific error cases.

#### Scenario: System error wrapping

- **WHEN** ASAuthorization APIs throw errors
- **THEN** errors SHALL be wrapped in custom error types with descriptive context

#### Scenario: Application error cases

- **WHEN** application-level failures occur (e.g., invalid state, missing dependencies)
- **THEN** custom error types SHALL represent these cases

### Requirement: Dependency Injection Architecture

The authentication manager SHALL use dependency injection for external dependencies including challenge query services, credential verification services, and window provider.

#### Scenario: Challenge service injection

- **WHEN** authentication manager is initialized
- **THEN** a challenge query service dependency SHALL be injectable

#### Scenario: Verification service injection

- **WHEN** authentication manager is initialized
- **THEN** a credential verification service dependency SHALL be injectable

#### Scenario: ViewModel verification service injection

- **WHEN** ViewModel needs to verify password credentials directly
- **THEN** VerificationService SHALL be injectable to ViewModel for password authentication path

#### Scenario: Window provider injection

- **WHEN** authentication manager needs presentation anchor
- **THEN** a window provider dependency SHALL be injectable to support testability

### Requirement: Mock Dependency Support

The system SHALL provide mock implementations of dependencies for testing and demonstration purposes without requiring real server implementations.

#### Scenario: Mock challenge service

- **WHEN** testing or demo mode is active
- **THEN** a mock challenge service SHALL provide simulated challenge data

#### Scenario: Mock verification service

- **WHEN** testing or demo mode is active
- **THEN** a mock verification service SHALL simulate credential verification

#### Scenario: Mock password verification

- **WHEN** testing or demo mode requires password verification
- **THEN** mock verification service SHALL provide verifyPassword method that simulates password authentication without PasskeyError types

### Requirement: Factory Pattern for Instantiation

The system SHALL provide a factory for creating authentication manager instances with appropriate dependency configuration.

#### Scenario: Production configuration

- **WHEN** factory creates production instance
- **THEN** real dependency implementations SHALL be injected

#### Scenario: Mock configuration

- **WHEN** factory creates mock/demo instance
- **THEN** mock dependency implementations SHALL be injected

### Requirement: Window Provider Dependency

The system SHALL abstract window retrieval logic into an injectable dependency that finds the active UIWindow from connected scenes.

#### Scenario: Active window lookup

- **WHEN** window provider is queried for presentation anchor
- **THEN** it SHALL search UIApplication.shared.connectedScenes for UIWindowScene and return first available window

#### Scenario: Window unavailable

- **WHEN** no valid window is found
- **THEN** window provider SHALL throw or return nil appropriately

### Requirement: Logging with Subsystem

The authentication logic layer SHALL implement logging using OSLog with a dedicated subsystem identifier for debugging and monitoring.

#### Scenario: Operation logging

- **WHEN** authentication operations are performed
- **THEN** significant events SHALL be logged with appropriate log levels

#### Scenario: Error logging

- **WHEN** errors occur during authentication
- **THEN** error details SHALL be logged for debugging purposes

### Requirement: Dual Verification Paths

The VerificationService SHALL support both Passkey credential verification and password-based verification with appropriate separation of concerns.

#### Scenario: Passkey credential verification

- **WHEN** PasskeyAuthenticationManager completes Passkey authentication
- **THEN** VerificationService.verify(credential:) SHALL be called to verify the Passkey credential data

#### Scenario: Password verification

- **WHEN** ViewModel detects autofilled password credentials
- **THEN** VerificationService.verifyPassword(username:password:) SHALL be called directly from ViewModel

#### Scenario: Error type separation

- **WHEN** password verification fails
- **THEN** errors SHALL NOT use PasskeyError types but standard Error types (e.g., NSError)

#### Scenario: Architectural separation

- **WHEN** implementing authentication flows
- **THEN** PasskeyAuthenticationManager SHALL handle Passkey-specific operations only, ViewModel SHALL orchestrate authentication path decisions, and VerificationService SHALL handle actual credential verification for both types
