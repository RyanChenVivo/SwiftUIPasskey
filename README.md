# SwiftUI Passkey Demo App

一個展示 iOS Passkey 認證功能的 demo 應用程式。

## 功能特色

此應用程式展示了所有主要的 Passkey 認證場景：

1. **註冊 (Registration)** - 建立新的 Passkey 憑證
2. **Passkey 登入 (Passkey Only)** - 僅使用 Passkey 進行驗證（使用 discoverable credentials）
3. **混合登入 (Hybrid Login)** - Modal 彈窗提供 Passkey 或密碼選項
4. **AutoFill Passkey 登入** - 純 AutoFill，從 QuickType bar 選擇 Passkey
5. **立即可用憑證 (Immediate Credentials)** - 使用 `preferImmediatelyAvailableCredentials` 選項
6. **AutoFill 完整體驗** - AutoFill + 備用登入按鈕的完整實作，支援智能密碼驗證

## 架構設計

### 兩層架構

#### Logic Layer (邏輯層)
- **Protocols**: 定義認證操作和依賴項目的介面
- **Models**: 資料模型和自訂錯誤類型
- **Manager**: PasskeyAuthenticationManager - 實作 ASAuthorization 協議
- **Services**: Mock 服務實作（ChallengeService, VerificationService, WindowProvider）
- **Factory**: 工廠模式用於建立認證管理器實例

#### UI Layer (介面層)
- **Views**: SwiftUI 視圖組件
- **ViewModels**: 使用 `@Observable` 的視圖模型
- **Models**: UI 相關的資料模型

### 設計決策

1. **依賴注入**: 使用協議抽象依賴，便於測試和替換實作
2. **職責分離**:
   - `PasskeyAuthenticationManager` 專注於 Passkey 操作
   - `VerificationService` 處理所有驗證邏輯（Passkey 和 Password）
   - `ViewModel` 根據 UI 狀態決定使用哪個服務
3. **Factory Pattern**: 集中管理依賴配置，簡化初始化
4. **Async/Await**: 使用 Continuation 橋接 ASAuthorization 的 delegate 回呼到現代 async/await
5. **AutoFill 生命週期管理**: Task-based 取消機制，確保正確清理資源
6. **智能登入邏輯**: AutoFill Hybrid 模式偵測密碼自動填充，自動選擇驗證路徑
7. **Mock Services**: 提供模擬實作，無需真實伺服器即可運行
8. **OSLog**: 整合日誌系統，方便調試

## 專案結構

```
SwiftUIPasskey/
├── Logic/
│   ├── Manager/
│   │   ├── PasskeyAuthenticationManager.swift
│   │   └── PasskeyAuthenticationManagerFactory.swift
│   ├── Models/
│   │   ├── AuthenticationModels.swift
│   │   └── PasskeyError.swift
│   ├── Protocols/
│   │   ├── DependencyProtocols.swift
│   │   └── PasskeyAuthenticationProtocol.swift
│   └── Services/
│       ├── DefaultWindowProvider.swift
│       ├── MockChallengeService.swift
│       ├── MockVerificationService.swift
│       ├── MockWindowProvider.swift
│       └── PasskeyLogger.swift
└── UI/
    ├── Models/
    │   ├── AuthenticationFeature.swift
    │   └── UserInfo.swift
    ├── ViewModels/
    │   ├── AutofillPasskeyOnlyViewModel.swift
    │   ├── AutofillHybridViewModel.swift
    │   ├── HybridLoginViewModel.swift
    │   ├── ImmediateCredentialsViewModel.swift
    │   ├── PasskeyOnlyLoginViewModel.swift
    │   └── RegistrationViewModel.swift
    └── Views/
        ├── AutofillPasskeyOnlyView.swift
        ├── AutofillHybridView.swift
        ├── FeatureListView.swift
        ├── HybridLoginView.swift
        ├── ImmediateCredentialsView.swift
        ├── PasskeyOnlyLoginView.swift
        ├── RegistrationView.swift
        └── SuccessView.swift
```

## 使用方式

### Factory Pattern 範例

```swift
// 建立使用 Mock 依賴的認證管理器（用於 demo）
let authManager = PasskeyAuthenticationManagerFactory.makeMockManager()

// 註冊
let userInfo = try await authManager.register(username: "user@example.com")

// Passkey-only 登入（discoverable credentials）
let userInfo = try await authManager.signInWithPasskeyOnly()

// Hybrid 登入（Passkey + Password modal）
let userInfo = try await authManager.signInWithPasskeyAndPasswordOption(username: nil)
```

### AutoFill 實作範例

```swift
@MainActor
class AutofillHybridViewModel: ObservableObject {
    private let authManager: PasskeyAuthenticationProtocol
    private let verificationService: VerificationService
    private var autoFillTask: Task<Void, Never>?

    // 啟動 AutoFill 等待用戶從 QuickType bar 選擇
    func startAutoFillSignIn() {
        autoFillTask = Task {
            let result = try await authManager.awaitAutoFillSignIn(username: nil)
            userInfo = result
        }
    }

    // 智能登入：偵測密碼自動填充
    func signInWithHybrid() async {
        await stopAutoFillSignIn()  // 先取消 AutoFill task

        if !username.isEmpty && !password.isEmpty {
            // 密碼已自動填充，直接驗證
            let result = try await verificationService.verifyPassword(
                username: username,
                password: password
            )
            userInfo = UserInfo(username: result.username, userID: result.userID)
        } else {
            // 顯示 modal 讓用戶選擇 Passkey 或密碼
            let result = try await authManager.signInWithPasskeyAndPasswordOption(username: username)
            userInfo = result
        }
    }
}
```

### 錯誤處理

```swift
do {
    let userInfo = try await authManager.register(username: username)
    // 處理成功
} catch let error as PasskeyError {
    // 處理 Passkey 特定錯誤
    print(error.errorDescription)
} catch {
    // 處理其他錯誤（如密碼驗證失敗）
    print(error.localizedDescription)
}
```

## 需求

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## 重要技術細節

### AutoFill API 限制
- `performAutoFillAssistedRequests()` **只支援** `ASAuthorizationPlatformPublicKeyCredentialAssertionRequest`（Passkey）
- 密碼的自動填充是由 iOS 系統透過 `.textContentType(.password)` 自動處理，不需要也不能透過 `performAutoFillAssistedRequests` 處理

### Discoverable Credentials
- Passkey-only 和 Hybrid login 使用 discoverable credentials（resident keys）
- 不需要提供 username，Passkey 本身包含用戶資訊
- 因此這些流程的 UI 不顯示輸入框

### 驗證服務分離
- `PasskeyError` 只用於 Passkey 相關錯誤
- 密碼驗證失敗使用標準 `NSError` 或其他通用錯誤類型
- `VerificationService` 支援兩種驗證：
  - `verify(credential:)` - Passkey 憑證驗證
  - `verifyPassword(username:password:)` - 密碼驗證

## 注意事項

1. **Mock 實作**: 此專案使用模擬服務，不需要真實的後端伺服器
2. **測試環境**: 要測試真實的 Passkey 功能，需要在實體設備或配置正確的模擬器上運行
3. **無持久化**: Demo 目的，不保存任何認證資料
4. **AutoFill 生命週期**: AutoFill task 必須在 view disappear 時正確取消，避免資源洩漏

## 日誌

使用 OSLog 進行日誌記錄，subsystem: `com.swiftuipasskey.demo`

在 Console.app 中可以過濾查看：
- **Authentication**: 認證操作日誌
- **Challenge**: 挑戰請求日誌
- **Verification**: 憑證驗證日誌

## License

此專案僅供學習和研究使用。
