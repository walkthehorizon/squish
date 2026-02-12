# iOS App Store 上架检查清单

本文档列出 PhotoSquish（照片压缩）上架 Apple App Store 前需要确认与补充的配置。

---

## 一、已在工程内完成的配置

- **应用显示名称**：Info.plist 中 `CFBundleDisplayName` = `PhotoSquish`，`CFBundleName` = `PhotoSquish`
- **版本号**：由 `pubspec.yaml` 的 `version: 1.0.0+1` 决定（build name = 1.0.0，build number = 1）
- **最低系统版本**：iOS 12.0（Podfile 与 Xcode 已设为 12.0）
- **相册权限说明**：已配置 `NSPhotoLibraryUsageDescription`、`NSPhotoLibraryAddUsageDescription`（中文）
- **出口合规**：已添加 `ITSAppUsesNonExemptEncryption = false`（仅使用系统标准加密，无需单独申报）

---

## 二、需要您提供或确认的信息

### 1. Bundle ID（包名）

当前为：`com.pumpkin.image.compress`

- 若已用该 ID 在 App Store Connect 创建应用，请保持不变。
- 若需更换（例如改为公司域名）：在 Xcode 中打开 `Runner.xcodeproj` → 选中 **Runner** target → **Signing & Capabilities** → 修改 **Bundle Identifier**，并确保与 App Store Connect 中创建的应用一致。

### 2. 开发者账号与签名

- 使用 **Apple Developer Program** 账号（付费）。
- 在 Xcode 中：**Signing & Capabilities** → 选择您的 **Team**，勾选 **Automatically manage signing**（或手动配置证书与描述文件）。

### 3. 隐私政策 URL（必填）

App Store 要求提供可公开访问的隐私政策链接。

- 若已有网站：请提供隐私政策页面的完整 URL，在 App Store Connect 填写。
- 若暂无网站：可考虑使用 GitHub Pages、公司官网子页面、或第三方「隐私政策生成页」并得到可访问的 URL。

当前应用内「隐私政策」为本地 HTML，仅用于应用内展示；**Store 后台必须填的是可被苹果和用户打开的在线 URL**。

### 4. 应用名称本地化（可选）

若希望系统语言为中文时，主屏幕下显示「照片压缩」而非「PhotoSquish」：

1. 在 Xcode 中右键 **Runner** 组 → **New File** → **Strings File**，命名为 `InfoPlist.strings`。
2. 选中 `InfoPlist.strings` → 右侧 **File Inspector** → **Localization** → 添加 **English** 和 **Chinese, Simplified**。
3. 在 **en** 的 `InfoPlist.strings` 中添加：  
   `CFBundleDisplayName = "PhotoSquish";`
4. 在 **zh-Hans** 的 `InfoPlist.strings` 中添加：  
   `CFBundleDisplayName = "照片压缩";`

保存后重新编译即可。

---

## 三、App Store Connect 后台需填写的内容

| 项 | 说明 |
|----|------|
| **App 名称** | 例如：PhotoSquish（可与副标题一起展示） |
| **副标题** | 简短描述，如：Compress photos & images |
| **隐私政策 URL** | 见上文，必填且需可访问 |
| **类别** | 建议：**Photo & Video** 或 **Utilities** |
| **分级** | 选「无不良内容」相应选项即可 |
| **版权** | 例如：© 2026 您的名字或公司名 |
| **联系邮箱 / 电话** | 用户可用的支持联系方式 |
| **截图** | 6.7"、6.5"、5.5" 等所需尺寸（按当前要求准备） |
| **应用描述与关键词** | 英文/中文按需填写，便于搜索 |

若在 App Store Connect 为应用添加了「简体中文」本地化，可在该语言下填写中文名称「照片压缩」、中文描述等，用于商店展示。

---

## 四、打包与上传步骤简述

1. **清理并获取依赖**  
   ```bash
   flutter clean && flutter pub get
   cd ios && pod install && cd ..
   ```
   完成后，用 Xcode 打开 **ios/Runner.xcworkspace**（在项目根目录下，不要打开 .xcodeproj）。若在 Finder 中看不到，可在项目根目录执行：`open ios/Runner.xcworkspace`。

2. **构建 Release**  
   ```bash
   flutter build ios --release
   ```
   或使用 Xcode：**Product → Archive**。

3. **上传**  
   - 在 Xcode **Window → Organizer** 中选中刚生成的 Archive，点击 **Distribute App**。  
   - 选择 **App Store Connect** → **Upload**，按提示选择签名与选项即可。

4. **在 App Store Connect 提交审核**  
   上传完成后，在对应 App 的「TestFlight / App Store」版本中提交审核，并完成上述所有必填项与截图。

---

## 五、若需要修改的内容

- **版本号**：改 `pubspec.yaml` 中的 `version`（如 `1.0.1+2`），再重新 build/archive。
- **应用名（仅主屏）**：改 `ios/Runner/Info.plist` 中的 `CFBundleDisplayName`，或按上文用 `InfoPlist.strings` 做多语言。
- **相册权限文案**：改 `Info.plist` 中 `NSPhotoLibraryUsageDescription` / `NSPhotoLibraryAddUsageDescription` 的字符串；若做了 InfoPlist.strings 本地化，也可在对应语言文件中覆盖这些 key。

如有具体项（例如 Bundle ID、隐私政策 URL、截图尺寸）需要按你的实际情况写死到文档或工程里，可以把最终决定发给我，我帮你改成可直接用的配置说明或占位符。
