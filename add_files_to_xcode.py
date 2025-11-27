#!/usr/bin/env python3
"""
Script to add Swift files to Xcode project
"""
import subprocess
import os

# Change to project directory
os.chdir('/Users/ryanchen/code/SwiftPractice/SwiftUIPasskey')

# List of all new Swift files relative to the project root
new_files = [
    'SwiftUIPasskey/Logic/Manager/PasskeyAuthenticationManager.swift',
    'SwiftUIPasskey/Logic/Manager/PasskeyAuthenticationManagerFactory.swift',
    'SwiftUIPasskey/Logic/Models/AuthenticationModels.swift',
    'SwiftUIPasskey/Logic/Models/PasskeyError.swift',
    'SwiftUIPasskey/Logic/Protocols/DependencyProtocols.swift',
    'SwiftUIPasskey/Logic/Protocols/PasskeyAuthenticationProtocol.swift',
    'SwiftUIPasskey/Logic/Services/DefaultWindowProvider.swift',
    'SwiftUIPasskey/Logic/Services/MockChallengeService.swift',
    'SwiftUIPasskey/Logic/Services/MockVerificationService.swift',
    'SwiftUIPasskey/Logic/Services/MockWindowProvider.swift',
    'SwiftUIPasskey/Logic/Services/PasskeyLogger.swift',
    'SwiftUIPasskey/UI/Models/AuthenticationFeature.swift',
    'SwiftUIPasskey/UI/ViewModels/AutofillLoginViewModel.swift',
    'SwiftUIPasskey/UI/ViewModels/HybridLoginViewModel.swift',
    'SwiftUIPasskey/UI/ViewModels/ImmediateCredentialsViewModel.swift',
    'SwiftUIPasskey/UI/ViewModels/PasskeyOnlyLoginViewModel.swift',
    'SwiftUIPasskey/UI/ViewModels/RegistrationViewModel.swift',
    'SwiftUIPasskey/UI/Views/AutofillLoginView.swift',
    'SwiftUIPasskey/UI/Views/FeatureListView.swift',
    'SwiftUIPasskey/UI/Views/HybridLoginView.swift',
    'SwiftUIPasskey/UI/Views/ImmediateCredentialsView.swift',
    'SwiftUIPasskey/UI/Views/PasskeyOnlyLoginView.swift',
    'SwiftUIPasskey/UI/Views/RegistrationView.swift',
    'SwiftUIPasskey/UI/Views/SuccessView.swift',
]

print("Files need to be added to Xcode project manually or via Xcode.")
print("Please open the project in Xcode and add the following files:")
for f in new_files:
    print(f"  - {f}")
