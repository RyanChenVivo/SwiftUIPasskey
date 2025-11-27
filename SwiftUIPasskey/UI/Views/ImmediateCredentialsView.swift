//
//  ImmediateCredentialsView.swift
//  SwiftUIPasskey
//
//  View for immediate credentials login
//

import SwiftUI

struct ImmediateCredentialsView: View {
    @State private var viewModel = ImmediateCredentialsViewModel()

    var body: some View {
        VStack(spacing: 24) {
            if let userInfo = viewModel.userInfo {
                SuccessView(userInfo: userInfo)
            } else {
                authenticationForm
            }
        }
        .padding()
        .navigationTitle("立即可用憑證")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var authenticationForm: some View {
        VStack(spacing: 24) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("立即可用憑證登入")
                .font(.title2)
                .fontWeight(.semibold)

            Text("只顯示立即可用的憑證，不需使用者互動")
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
                    Text("使用立即可用憑證登入")
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
        ImmediateCredentialsView()
    }
}
