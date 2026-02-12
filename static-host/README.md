# 照片压缩 PhotoSquish - 用户协议与隐私政策（静态站点）

本目录为**腾讯云 CloudBase 静态网站托管**可部署的静态站点，包含用户协议与隐私政策的中英文页面，适用于 App Store / 应用内 WebView 链接。

参考文档：[腾讯云 - 静态网站托管](https://cloud.tencent.com/document/product/876/123943)

## 目录结构

```
static-host/
├── index.html              # 首页（导航到各协议/隐私页）
├── user-agreement.html     # 用户协议（中文）
├── user-agreement-en.html  # 用户协议（英文）
├── privacy-policy.html     # 隐私政策（中文）
├── privacy-policy-en.html  # 隐私政策（英文）
└── README.md               # 本说明
```

## 部署到腾讯云静态网站托管

### 方式一：控制台上传

1. 登录 [腾讯云 CloudBase 控制台](https://console.cloud.tencent.com/tcb)。
2. 进入对应环境的 **静态网站托管**。
3. 将本目录下所有文件（或整个 `static-host` 文件夹内所有文件）上传到托管根目录。
4. 确保根目录存在 **index.html**（索引文档默认为 index.html）。

### 方式二：CloudBase CLI 部署

1. 安装 CloudBase CLI：
   ```bash
   npm install -g @cloudbase/cli
   ```
2. 登录：
   ```bash
   tcb login
   ```
3. 在**本目录**下执行部署（将 `static-host` 目录内容部署到静态托管根目录）：
   ```bash
   cd static-host
   tcb hosting deploy . -e <环境ID>
   ```
   或从项目根目录部署该子目录：
   ```bash
   tcb hosting deploy ./static-host -e <环境ID>
   ```

### 部署后 URL 示例

假设你的静态托管访问域名为 `https://xxx.tcloudbaseapp.com` 或已绑定自定义域名 `https://legal.yourdomain.com`，则：

| 页面       | 中文 URL | 英文 URL |
|------------|----------|----------|
| 首页       | `https://xxx.tcloudbaseapp.com/` 或 `https://xxx.tcloudbaseapp.com/index.html` | 同上 |
| 用户协议   | `https://xxx.tcloudbaseapp.com/user-agreement.html` | `https://xxx.tcloudbaseapp.com/user-agreement-en.html` |
| 隐私政策   | `https://xxx.tcloudbaseapp.com/privacy-policy.html` | `https://xxx.tcloudbaseapp.com/privacy-policy-en.html` |

**App Store / 应用内使用建议：**

- 隐私政策链接（必填）：使用 **隐私政策** 的 URL，例如  
  `https://你的域名/privacy-policy.html`（中文）、  
  `https://你的域名/privacy-policy-en.html`（英文）；或根据应用语言在 WebView 中加载对应 URL。
- 用户协议链接：同上，使用 `user-agreement.html` / `user-agreement-en.html`。

## 索引文档说明

根据腾讯云静态托管规则，根目录及子目录的默认索引文档为 **index.html**。访问根路径时会返回 index.html，无需在 URL 后加 `/index.html`。

## 更新内容

若修改了 `assets/html/` 下的协议或隐私政策源文件，请同步更新本目录中对应 HTML 文件后再重新部署，以保持线上与应用内展示一致。
