//
//  SuccessView.swift
//  SwiftUIPasskey
//
//  View for successful authentication
//

import SwiftUI

struct SuccessView: View {
    let userInfo: UserInfo
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)

            Text("驗證成功！")
                .font(.title)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                InfoRow(label: "使用者名稱", value: userInfo.username)
                InfoRow(label: "使用者 ID", value: userInfo.userID)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            Spacer()

            Button(action: {
                dismiss()
            }) {
                Text("登出")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    SuccessView(userInfo: UserInfo(username: "demo_user", userID: "12345"))
}
