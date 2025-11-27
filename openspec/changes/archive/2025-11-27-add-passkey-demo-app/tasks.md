# Implementation Tasks

## 1. Logic Layer Foundation

- [x] 1.1 Define custom error types for authentication failures
- [x] 1.2 Create protocol for authentication operations (registration, login, autofill)
- [x] 1.3 Define dependency protocols (ChallengeService, VerificationService, WindowProvider)
- [x] 1.4 Implement WindowProvider to find active UIWindow from connected scenes
- [x] 1.5 Add OSLog subsystem configuration for logging

## 2. Mock Dependencies

- [x] 2.1 Implement MockChallengeService with simulated challenge generation
- [x] 2.2 Implement MockVerificationService with simulated credential verification
- [x] 2.3 Add password verification method to VerificationService protocol
- [x] 2.4 Implement verifyPassword method in MockVerificationService
- [x] 2.5 Implement MockWindowProvider for testing
- [x] 2.6 Create test helpers for mock dependency configuration

## 3. Authentication Manager Implementation

- [x] 3.1 Create authentication manager class conforming to ASAuthorization protocols
- [x] 3.2 Implement async registration method with assertionRequest parameters
- [x] 3.3 Implement async login method with passwordRequest parameters
- [x] 3.4 Implement async autofill-enabled authentication method
- [x] 3.5 Implement ASAuthorizationControllerPresentationContextProviding protocol
- [x] 3.6 Implement ASAuthorizationControllerDelegate methods with continuation-based async bridging
- [x] 3.7 Add appropriate Actor isolation or synchronization for state management
- [x] 3.8 Integrate logging throughout authentication flows

## 4. Factory Pattern

- [x] 4.1 Create factory class for authentication manager instantiation
- [x] 4.2 Implement factory method for production configuration
- [x] 4.3 Implement factory method for mock/demo configuration with injected mocks
- [x] 4.4 Document factory usage patterns

## 5. UI Layer - Feature List

- [x] 5.1 Create FeatureListView with navigation to all authentication scenarios
- [x] 5.2 Add list items: Registration, Passkey-only login, Passkey + password, AutoFill Passkey-only, preferImmediatelyAvailableCredentials, AutoFill Hybrid
- [x] 5.3 Implement navigation infrastructure using NavigationStack
- [x] 5.4 Update ContentView to embed FeatureListView
- [x] 5.5 Add AuthenticationFeature enum to define all feature types with localized names

## 6. UI Layer - Registration Flow

- [x] 6.1 Create RegistrationViewModel using factory for authentication manager
- [x] 6.2 Create RegistrationView with username input and registration button
- [x] 6.3 Implement registration action calling logic layer
- [x] 6.4 Add error handling and display
- [x] 6.5 Implement navigation to success screen on completion

## 7. UI Layer - Passkey-Only Login

- [x] 7.1 Create PasskeyOnlyLoginViewModel using factory
- [x] 7.2 Create PasskeyOnlyLoginView (simplified without input fields for discoverable credentials)
- [x] 7.3 Implement passkey authentication action
- [x] 7.4 Add error handling and display
- [x] 7.5 Implement navigation to success screen

## 8. UI Layer - Passkey with Password Option

- [x] 8.1 Create HybridLoginViewModel using factory
- [x] 8.2 Create HybridLoginView (simplified without input fields for discoverable credentials)
- [x] 8.3 Implement passkey and password authentication actions via modal
- [x] 8.4 Add error handling and display
- [x] 8.5 Implement navigation to success screen

## 9. UI Layer - Autofill Flow

- [x] 9.1 Split autofill into two demos: Passkey-only and Hybrid (complete experience)
- [x] 9.2 Create AutofillPasskeyOnlyViewModel and View for pure AutoFill demo
- [x] 9.3 Create AutofillHybridViewModel and View for AutoFill + backup button demo
- [x] 9.4 Implement lifecycle management with startAutoFillSignIn/stopAutoFillSignIn
- [x] 9.5 Add smart hybrid login logic: detect autofilled password vs. modal login
- [x] 9.6 Implement Task-based autofill cancellation with proper cleanup
- [x] 9.7 Add error handling and display for both autofill modes
- [x] 9.8 Implement navigation to success screen

## 10. UI Layer - PreferImmediatelyAvailableCredentials

- [x] 10.1 Create ImmediateCredentialsViewModel using factory
- [x] 10.2 Create ImmediateCredentialsView
- [x] 10.3 Implement authentication with preferImmediatelyAvailableCredentials option
- [x] 10.4 Add error handling and display
- [x] 10.5 Implement navigation to success screen

## 11. UI Layer - Success Screen

- [x] 11.1 Create SuccessView displaying authentication success
- [x] 11.2 Add user information display
- [x] 11.3 Implement sign out button returning to feature list
- [x] 11.4 Add navigation handling for sign out action

## 12. Testing and Validation

- [x] 12.1 Test registration flow with mock dependencies
- [x] 12.2 Test all login flows with mock dependencies
- [x] 12.3 Verify error handling displays correctly
- [x] 12.4 Test navigation flow through all scenarios
- [x] 12.5 Verify logging output for debugging
- [x] 12.6 Test on physical iOS device with real passkey support

## 13. Documentation

- [x] 13.1 Add code documentation for public APIs
- [x] 13.2 Document dependency injection patterns
- [x] 13.3 Add usage examples for factory pattern
- [x] 13.4 Document error types and handling
