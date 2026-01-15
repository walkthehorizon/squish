// 应用常量配置
class AppConstants {
  // 应用名称
  static const String appName = '南瓜压缩';
  
  // 图片选择
  static const int maxImageCount = 20; // 最大选择图片数量
  
  // 压缩配置默认值
  static const double defaultQuality = 80.0; // 默认压缩质量
  static const double defaultScaleRatio = 0.8; // 默认缩放比例
  static const int defaultWidth = 1920; // 默认宽度
  static const int defaultHeight = 1080; // 默认高度
  
  // 文件大小单位
  static const int bytesPerKB = 1024;
  static const int bytesPerMB = 1024 * 1024;
  
  // 支持的图片格式
  static const List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'webp'];
}

// 压缩模式枚举
enum CompressMode {
  scale, // 等比压缩
  resize, // 指定尺寸
  smart, // 智能压缩
}

// 图片格式枚举
enum ImageFormat {
  jpg,
  png,
  webp,
}

// 填充模式枚举
enum FitMode {
  contain, // 包含（留白）
  cover, // 覆盖（裁剪）
  fill, // 拉伸填充
}
