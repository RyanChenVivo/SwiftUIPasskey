# 我想要做一個研究passkey的結果demo app
我想分兩個部分來實作，一個是控制passkey相關的API及驗證方法的邏輯層，一個是套用這個邏輯層來呈現的UI介面實作。

## 邏輯層這邊我希望有以下需求
1. 提供一個介面關於passKey的，例如我要有註冊，登入，autofill的相關介面。
    1. 我們有assertionRequest, passwordRequest, 這些都是重要的參數，要demo使用
    2. 我們可以討論怎麼樣開好
2. 實作然後要confirm "ASAuthorizationControllerPresentationContextProviding", "ASAuthorizationControllerDelegate"
3. 介面以async/await、Actor等等來設計，throw的error我們自己定義，但要把系統會給我們的都包含到
4. 我們應該會有依賴項目，用依賴注入的方式實作，可能會依賴的比如說是query challenge的，我們簽完名之後要驗證的，這邊若有遺漏的我們可以討論
    1. 可以實作mocker來傳入，不用實作真實的server端。
    2. 用工廠模式統一產生邏輯層物件，然後我們提供一個已注入mock物件的邏輯層物件方法
5. 官方API要提供ASPresentationAnchor，我認為這應該也是一個依賴項目
    1. 我們先注入一個統一找window的物件，實作類似```
       ```
       guard let window = UIApplication.shared.connectedScenes

            .compactMap({ $0 as? UIWindowScene })

            .flatMap({ $0.windows })

            .first else {

            return

        }
       ```
6. log帶入SubSystem方便debug

## UI介面，我希望能夠好好的呈現出各種passkey api(我們設計的邏輯層)的各種可能
1. 進入頁面後有一個list, 裡面有各項功能
    1. 註冊
    2. passkey 登入，passkey only
    3. passkey 登入，搭配可以選擇密碼
    4. autofill
    5. preferImmediatelyAvailableCredentials = true的樣式
2. 每個功能點進去之後會是一樣的登入頁面樣式，有一個輸入筐以及按鈕
    1. 頁面各自有viewModel，統一使用工廠方法來產生邏輯層，依據各自的功能來使用。
    2. 錯誤處理可以統一吃邏輯層提供的error並顯示
3. 登入成功後會顯示成功頁面，最下面有signOut按鈕，按了之後回到list頁面
