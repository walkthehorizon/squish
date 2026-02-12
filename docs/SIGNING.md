# 应用签名配置说明

## 一、Android 签名（Google Play / 国内应用商店）

### 1. 生成上传密钥（仅需做一次）

在项目 **android** 目录下打开终端，执行：

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

按提示输入密钥库密码、密钥密码、姓名/组织等信息。会生成 `upload-keystore.jks`，请**妥善备份**（丢失后无法用同一签名更新应用）。

### 2. 配置 key.properties

在 **android** 目录下：

1. 复制示例文件：
   ```bash
   cp key.properties.example key.properties
   ```
2. 编辑 `key.properties`，填入真实值（与生成 keystore 时一致）：

   ```properties
   storePassword=你设置的密钥库密码
   keyPassword=你设置的 key 密码
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

`storeFile` 若写相对路径，相对于 **android** 目录（例如 `upload-keystore.jks` 表示 android/upload-keystore.jks）。

### 3. 构建 release 包

配置完成后，执行：

```bash
flutter build appbundle
```

生成的 `build/app/outputs/bundle/release/app-release.aab` 即可用于 Google Play 上传。

**说明**：未配置 `key.properties` 时，release 会使用 debug 签名，仅适合本地测试，**上架必须使用自己的 release 密钥**。

---

## 二、iOS 签名（App Store）

工程已开启 **自动签名**（`CODE_SIGN_STYLE = Automatic`），按下面步骤即可。

### 1. 前置条件

- 已加入 [Apple Developer Program](https://developer.apple.com/programs/)（付费账号）
- 本机已安装 Xcode，并已登录该 Apple ID

### 2. 在 Xcode 中设置 Team

1. 先确保已生成 CocoaPods 工程（在项目根目录执行）：
   ```bash
   flutter pub get && cd ios && pod install && cd ..
   ```
2. 用 Xcode 打开 **ios/Runner.xcworkspace**（路径：项目根目录下的 `ios/Runner.xcworkspace`，**不要**打开 `Runner.xcodeproj`）
   - 若在 Finder 里看不到该文件，可在终端执行：`open ios/Runner.xcworkspace`（在项目根目录下）
2. 左侧选中 **Runner** 工程 → 选中 **Runner** target
3. 顶部打开 **Signing & Capabilities**
4. 勾选 **Automatically manage signing**
5. **Team** 下拉选择你的开发团队（个人或公司）
6. 若提示 “Failed to register bundle identifier”，说明该 Bundle ID 尚未在开发者后台注册：到 [App Store Connect](https://appstoreconnect.apple.com) 或 [developer.apple.com](https://developer.apple.com/account) 用该 Apple ID 登录，确认该账号下已有 `com.pumpkin.image.compress` 的 App ID 或先创建再回 Xcode 重试

Xcode 会自动下载/创建描述文件，无需手动管理证书和 Provisioning Profile。

### 3. 打包上传

- **Product → Archive** 打出归档
- 在 **Window → Organizer** 中选中该归档 → **Distribute App** → 选择 **App Store Connect** 上传

首次使用该 Mac 上传时，可能需要在 **Xcode → Settings → Accounts** 里为该 Apple ID 下载 “Manage Certificates” 中的 **Apple Distribution** 证书。

---

## 三、安全提醒

- **不要**将 `key.properties`、`*.jks`、`*.keystore` 提交到 Git（已写入 .gitignore）
- **不要**把密钥库密码、key 密码写进代码或公开文档
- Android 密钥库和 iOS 证书/描述文件请本地与云端**多处备份**，丢失后无法以同一应用身份更新已上架应用
