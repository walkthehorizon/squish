import '../utils/constants.dart';

// 压缩配置数据模型
class CompressConfig {
  final CompressMode mode; // 压缩模式
  final double quality; // 压缩质量 0-100
  final double scaleRatio; // 缩放比例 0-1
  final int targetWidth; // 目标宽度
  final int targetHeight; // 目标高度
  final ImageFormat outputFormat; // 输出格式
  final FitMode fitMode; // 填充模式
  final bool showPreview; // 是否显示预览
  
  CompressConfig({
    this.mode = CompressMode.scale,
    this.quality = AppConstants.defaultQuality,
    this.scaleRatio = AppConstants.defaultScaleRatio,
    this.targetWidth = AppConstants.defaultWidth,
    this.targetHeight = AppConstants.defaultHeight,
    this.outputFormat = ImageFormat.jpg,
    this.fitMode = FitMode.contain,
    this.showPreview = true,
  });
  
  // 创建副本
  CompressConfig copyWith({
    CompressMode? mode,
    double? quality,
    double? scaleRatio,
    int? targetWidth,
    int? targetHeight,
    ImageFormat? outputFormat,
    FitMode? fitMode,
    bool? showPreview,
  }) {
    return CompressConfig(
      mode: mode ?? this.mode,
      quality: quality ?? this.quality,
      scaleRatio: scaleRatio ?? this.scaleRatio,
      targetWidth: targetWidth ?? this.targetWidth,
      targetHeight: targetHeight ?? this.targetHeight,
      outputFormat: outputFormat ?? this.outputFormat,
      fitMode: fitMode ?? this.fitMode,
      showPreview: showPreview ?? this.showPreview,
    );
  }
  
  // 获取压缩模式名称
  String get modeName {
    switch (mode) {
      case CompressMode.scale:
        return '等比压缩';
      case CompressMode.resize:
        return '指定尺寸';
      case CompressMode.smart:
        return '智能压缩';
    }
  }
  
  // 获取格式名称
  String get formatName {
    switch (outputFormat) {
      case ImageFormat.jpg:
        return 'JPG';
      case ImageFormat.png:
        return 'PNG';
      case ImageFormat.webp:
        return 'WebP';
    }
  }
  
  // 获取格式扩展名
  String get formatExtension {
    switch (outputFormat) {
      case ImageFormat.jpg:
        return 'jpg';
      case ImageFormat.png:
        return 'png';
      case ImageFormat.webp:
        return 'webp';
    }
  }
  
  // 获取填充模式名称
  String get fitModeName {
    switch (fitMode) {
      case FitMode.contain:
        return '包含（留白）';
      case FitMode.cover:
        return '覆盖（裁剪）';
      case FitMode.fill:
        return '拉伸填充';
    }
  }
  
  @override
  String toString() {
    return 'CompressConfig(mode: $modeName, quality: $quality, format: $formatName)';
  }
}
