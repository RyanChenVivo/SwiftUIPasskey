//
//  PasskeyOnlyLoginView.swift
//  SwiftUIPasskey
//
//  View for passkey-only login
//

import SwiftUI

struct PasskeyOnlyLoginView: View {
    @State private var viewModel = PasskeyOnlyLoginViewModel()

    var body: some View {
        VStack(spacing: 24) {
            if let userInfo = viewModel.userInfo {
                SuccessView(userInfo: userInfo)
            } else {
                authenticationForm
            }
        }
        .padding()
        .navigationTitle("Passkey 登入")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var authenticationForm: some View {
        VStack(spacing: 24) {
            Image(systemName: "key.fill")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("僅使用 Passkey 登入")
                .font(.title2)
                .fontWeight(.semibold)

            Text("無需輸入使用者名稱，系統會顯示您的可用 Passkey")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }

            Button(action: {
                Task {
                    await viewModel.signIn()
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("使用 Passkey 登入")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .cornerRadius(12)
            .disabled(viewModel.isLoading)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        PasskeyOnlyLoginView()
    }
}
