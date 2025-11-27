//
//  RegistrationView.swift
//  SwiftUIPasskey
//
//  View for passkey registration
//

import SwiftUI

struct RegistrationView: View {
    @State private var viewModel = RegistrationViewModel()

    var body: some View {
        VStack(spacing: 24) {
            if let userInfo = viewModel.userInfo {
                SuccessView(userInfo: userInfo)
            } else {
                authenticationForm
            }
        }
        .padding()
        .navigationTitle("註冊")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var authenticationForm: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("建立 Passkey 憑證")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(spacing: 16) {
                TextField("使用者名稱", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .disabled(viewModel.isLoading)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: {
                    Task {
                        await viewModel.register()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text("註冊")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .cornerRadius(12)
                .disabled(viewModel.isLoading)
            }

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
    }
}
