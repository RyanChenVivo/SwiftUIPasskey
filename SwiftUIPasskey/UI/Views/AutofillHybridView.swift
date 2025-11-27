//
//  AutofillHybridView.swift
//  SwiftUIPasskey
//
//  View for autofill hybrid login (Passkey + Password)
//

import SwiftUI

struct AutofillHybridView: View {
    @State private var viewModel = AutofillHybridViewModel()

    var body: some View {
        VStack(spacing: 24) {
            if let userInfo = viewModel.userInfo {
                SuccessView(userInfo: userInfo)
            } else {
                authenticationForm
            }
        }
        .padding()
        .navigationTitle("AutoFill 混合登入")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startAutoFillSignIn()
        }
        .onDisappear {
            Task {
                await viewModel.stopAutoFillSignIn()
            }
        }
    }

    private var authenticationForm: some View {
        VStack(spacing: 24) {
            Image(systemName: "keyboard")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("AutoFill 完整體驗")
                .font(.title2)
                .fontWeight(.semibold)

            Text("可從 QuickType bar 選擇 Passkey，或使用按鈕登入")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                TextField("使用者名稱", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .disabled(viewModel.isLoading)

                SecureField("密碼", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)
                    .disabled(viewModel.isLoading)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: {
                    Task {
                        await viewModel.signInWithHybrid()
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

                Text("提示：點擊輸入框從 QuickType bar 選擇 Passkey，或點擊按鈕使用 Modal 登入")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        AutofillHybridView()
    }
}
