import 'dart:io';

// 图片项数据模型
class ImageItem {
  final String id; // 唯一标识
  final File originalFile; // 原始文件
  final String name; // 文件名
  final int originalSize; // 原始文件大小（字节）
  
  File? compressedFile; // 压缩后的文件
  int? compressedSize; // 压缩后的文件大小（字节）
  
  bool isProcessing; // 是否正在处理
  bool isCompleted; // 是否已完成
  String? errorMessage; // 错误信息
  
  ImageItem({
    required this.id,
    required this.originalFile,
    required this.name,
    required this.originalSize,
    this.compressedFile,
    this.compressedSize,
    this.isProcessing = false,
    this.isCompleted = false,
    this.errorMessage,
  });
  
  // 获取压缩率（百分比）
  double get compressionRatio {
    if (compressedSize == null || originalSize == 0) return 0;
    return ((originalSize - compressedSize!) / originalSize * 100);
  }
  
  // 是否压缩成功
  bool get isSuccess => isCompleted && compressedFile != null && errorMessage == null;
  
  // 格式化文件大小显示
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
  
  // 获取原始大小显示文本
  String get originalSizeText => formatFileSize(originalSize);
  
  // 获取压缩后大小显示文本
  String get compressedSizeText {
    if (compressedSize == null) return '--';
    return formatFileSize(compressedSize!);
  }
  
  // 创建副本
  ImageItem copyWith({
    String? id,
    File? originalFile,
    String? name,
    int? originalSize,
    File? compressedFile,
    int? compressedSize,
    bool? isProcessing,
    bool? isCompleted,
    String? errorMessage,
  }) {
    return ImageItem(
      id: id ?? this.id,
      originalFile: originalFile ?? this.originalFile,
      name: name ?? this.name,
      originalSize: originalSize ?? this.originalSize,
      compressedFile: compressedFile ?? this.compressedFile,
      compressedSize: compressedSize ?? this.compressedSize,
      isProcessing: isProcessing ?? this.isProcessing,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
