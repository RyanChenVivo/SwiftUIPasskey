//
//  FeatureListView.swift
//  SwiftUIPasskey
//
//  Main feature list showing all available authentication scenarios
//

import SwiftUI

struct FeatureListView: View {
    var body: some View {
        NavigationStack {
            List(AuthenticationFeature.allCases) { feature in
                NavigationLink(value: feature) {
                    FeatureRow(feature: feature)
                }
            }
            .navigationTitle("Passkey Demo")
            .navigationDestination(for: AuthenticationFeature.self) { feature in
                destinationView(for: feature)
            }
        }
    }

    @ViewBuilder
    private func destinationView(for feature: AuthenticationFeature) -> some View {
        switch feature {
        case .registration:
            RegistrationView()
        case .passkeyOnly:
            PasskeyOnlyLoginView()
        case .passkeyWithPassword:
            HybridLoginView()
        case .autofillPasskeyOnly:
            AutofillPasskeyOnlyView()
        case .autofillHybrid:
            AutofillHybridView()
        case .immediateCredentials:
            ImmediateCredentialsView()
        }
    }
}

struct FeatureRow: View {
    let feature: AuthenticationFeature

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: feature.icon)
                .font(.title2)
                .foregroundStyle(.tint)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(feature.rawValue)
                    .font(.headline)

                Text(feature.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FeatureListView()
}
