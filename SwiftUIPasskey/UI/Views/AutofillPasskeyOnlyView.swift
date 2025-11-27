//
//  AutofillPasskeyOnlyView.swift
//  SwiftUIPasskey
//
//  View for autofill passkey-only login
//

import SwiftUI

struct AutofillPasskeyOnlyView: View {
    @State private var viewModel = AutofillPasskeyOnlyViewModel()

    var body: some View {
        VStack(spacing: 24) {
            if let userInfo = viewModel.userInfo {
                SuccessView(userInfo: userInfo)
            } else {
                authenticationForm
            }
        }
        .padding()
        .navigationTitle("AutoFill Passkey 登入")
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
            Image(systemName: "keyboard.badge.ellipsis")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("AutoFill Passkey 登入")
                .font(.title2)
                .fontWeight(.semibold)

            Text("點擊輸入框時，QuickType bar 會顯示可用的 Passkey")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                TextField("使用者名稱（選填）", text: $viewModel.username)
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

                Text("提示：直接從鍵盤上方的 QuickType bar 選擇 Passkey 登入")
                    .font(.caption2)
                    .foregroundStyle(.blue)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        AutofillPasskeyOnlyView()
    }
}
