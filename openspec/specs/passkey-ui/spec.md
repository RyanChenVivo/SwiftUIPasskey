# passkey-ui Specification

## Purpose
TBD - created by archiving change add-passkey-demo-app. Update Purpose after archive.
## Requirements
### Requirement: Feature List Navigation

The application SHALL display a main list screen showing all available Passkey authentication scenarios.

#### Scenario: Main feature list

- **WHEN** user launches the application
- **THEN** a list SHALL display with options for: Registration, Passkey-only login, Passkey login with password option, AutoFill Passkey-only, preferImmediatelyAvailableCredentials mode, and AutoFill Hybrid (complete experience)

#### Scenario: Feature selection

- **WHEN** user taps a feature from the list
- **THEN** application SHALL navigate to the corresponding authentication flow screen

### Requirement: Registration Flow UI

The system SHALL provide a registration screen that demonstrates passkey registration functionality.

#### Scenario: Registration screen layout

- **WHEN** user navigates to registration flow
- **THEN** screen SHALL display an input field for username and a registration action button

#### Scenario: Registration initiation

- **WHEN** user enters username and taps registration button
- **THEN** viewModel SHALL invoke passkey registration logic and handle the result

#### Scenario: Registration error display

- **WHEN** registration fails with an error
- **THEN** error message SHALL be displayed to the user

### Requirement: Passkey-Only Login UI

The system SHALL provide a login screen for passkey-only authentication without password fallback.

#### Scenario: Passkey-only screen layout

- **WHEN** user navigates to passkey-only login flow
- **THEN** screen SHALL display a login action button without input fields (for discoverable credentials)

#### Scenario: Passkey authentication

- **WHEN** user initiates passkey-only login
- **THEN** viewModel SHALL invoke passkey authentication logic without password option

### Requirement: Passkey with Password Option UI

The system SHALL provide a login screen that supports both passkey and password authentication options.

#### Scenario: Hybrid login screen

- **WHEN** user navigates to passkey with password option flow
- **THEN** screen SHALL display a login action button that triggers modal with passkey and password options (no input fields for discoverable credentials)

#### Scenario: Authentication mode selection

- **WHEN** user selects authentication mode
- **THEN** viewModel SHALL invoke appropriate authentication logic

### Requirement: Autofill Flow UI

The system SHALL provide two separate screens demonstrating different autofill patterns: Passkey-only AutoFill and Hybrid AutoFill with backup button.

#### Scenario: AutoFill Passkey-only screen

- **WHEN** user navigates to AutoFill Passkey-only flow
- **THEN** screen SHALL display only a username input field (optional) with textContentType(.username) and NO action button

#### Scenario: AutoFill Passkey-only behavior

- **WHEN** user taps the username field
- **THEN** QuickType bar SHALL show available Passkeys for selection via performAutoFillAssistedRequests

#### Scenario: AutoFill Hybrid screen

- **WHEN** user navigates to AutoFill Hybrid (complete experience) flow
- **THEN** screen SHALL display username and password input fields with textContentType configured AND a backup login button

#### Scenario: AutoFill Hybrid - QuickType selection

- **WHEN** user selects Passkey from QuickType bar in AutoFill Hybrid mode
- **THEN** AutoFill authentication SHALL complete using awaitAutoFillSignIn method

#### Scenario: AutoFill Hybrid - Password autofill

- **WHEN** user selects password from QuickType bar in AutoFill Hybrid mode
- **THEN** username and password fields SHALL be automatically filled by iOS system (not via performAutoFillAssistedRequests)

#### Scenario: AutoFill Hybrid - Backup button with autofilled password

- **WHEN** user has autofilled password credentials and clicks backup login button
- **THEN** ViewModel SHALL detect filled credentials and use VerificationService.verifyPassword directly instead of showing modal

#### Scenario: AutoFill Hybrid - Backup button without credentials

- **WHEN** user clicks backup login button without autofilled credentials
- **THEN** ViewModel SHALL show modal with Passkey and password options via signInWithPasskeyAndPasswordOption

### Requirement: PreferImmediatelyAvailableCredentials Mode UI

The system SHALL provide a screen demonstrating the preferImmediatelyAvailableCredentials option for passkey authentication.

#### Scenario: Immediate credentials screen

- **WHEN** user navigates to preferImmediatelyAvailableCredentials flow
- **THEN** screen SHALL display interface that requests immediately available credentials

#### Scenario: Immediate mode authentication

- **WHEN** authentication is initiated with preferImmediatelyAvailableCredentials
- **THEN** system SHALL only show immediately available passkeys without requiring user interaction for discovery

### Requirement: Unified Screen Layout

All authentication flow screens SHALL follow a consistent layout pattern with input field and action button.

#### Scenario: Consistent layout

- **WHEN** user views any authentication flow screen
- **THEN** screens SHALL present similar visual structure with input area and action button

### Requirement: ViewModel Architecture

Each authentication flow screen SHALL have a dedicated viewModel that uses the factory pattern to obtain the authentication logic layer.

#### Scenario: ViewModel instantiation

- **WHEN** authentication screen is created
- **THEN** viewModel SHALL use factory to instantiate authentication manager with mock dependencies for demo

#### Scenario: Logic layer interaction

- **WHEN** viewModel needs to perform authentication
- **THEN** it SHALL call async methods on the authentication logic layer

### Requirement: Unified Error Handling

The UI layer SHALL handle all errors from the authentication logic layer and display them consistently.

#### Scenario: Error presentation

- **WHEN** authentication logic throws an error
- **THEN** viewModel SHALL catch the error and update UI state to display error message

#### Scenario: Error message format

- **WHEN** error is displayed
- **THEN** message SHALL be user-friendly and derived from the custom error types

### Requirement: Success Screen

The system SHALL display a success screen after successful authentication.

#### Scenario: Success navigation

- **WHEN** authentication completes successfully
- **THEN** application SHALL navigate to success screen

#### Scenario: Success screen content

- **WHEN** user views success screen
- **THEN** screen SHALL display success message and user information

#### Scenario: Sign out action

- **WHEN** user taps sign out button on success screen
- **THEN** application SHALL navigate back to main feature list

### Requirement: AutoFill Lifecycle Management

AutoFill-enabled ViewModels SHALL implement proper lifecycle management for AutoFill tasks to prevent resource leaks and race conditions.

#### Scenario: AutoFill start on view appear

- **WHEN** AutoFill view appears
- **THEN** ViewModel SHALL call startAutoFillSignIn() to begin waiting for QuickType selection

#### Scenario: AutoFill stop on view disappear

- **WHEN** AutoFill view disappears
- **THEN** ViewModel SHALL call stopAutoFillSignIn() and await cleanup completion

#### Scenario: AutoFill cancellation before modal

- **WHEN** user clicks backup button in AutoFill Hybrid mode
- **THEN** ViewModel SHALL cancel AutoFill task and await cleanup before showing modal to prevent race conditions

#### Scenario: Task-based cancellation

- **WHEN** AutoFill operation needs to be cancelled
- **THEN** implementation SHALL use Task.cancel() and await task.result for proper cleanup

### Requirement: Navigation Flow

The application SHALL implement complete navigation flow from feature list through authentication to success screen and back.

#### Scenario: Forward navigation

- **WHEN** user progresses through authentication flow
- **THEN** appropriate screens SHALL be pushed onto navigation stack

#### Scenario: Backward navigation

- **WHEN** user completes flow or signs out
- **THEN** navigation SHALL return to feature list screen

