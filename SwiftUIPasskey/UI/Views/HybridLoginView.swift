//
//  HybridLoginView.swift
//  SwiftUIPasskey
//
//  View for hybrid login (passkey + password option)
//

import SwiftUI

struct HybridLoginView: View {
    @State private var viewModel = HybridLoginViewModel()

    var body: some View {
        VStack(spacing: 24) {
            if let userInfo = viewModel.userInfo {
                SuccessView(userInfo: userInfo)
            } else {
                authenticationForm
            }
        }
        .padding()
        .navigationTitle("混合登入")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var authenticationForm: some View {
        VStack(spacing: 24) {
            Image(systemName: "key.horizontal")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("Passkey + 密碼登入")
                .font(.title2)
                .fontWeight(.semibold)

            Text("可選擇 Passkey 或已儲存的密碼進行驗證")
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
                    Text("登入")
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
        HybridLoginView()
    }
}
