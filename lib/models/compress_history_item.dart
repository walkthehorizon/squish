// 压缩历史记录数据模型（用于持久化）
class CompressHistoryItem {
  final String id;
  final String name;
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final String compressedFilePath; // 压缩后文件的路径
  final DateTime timestamp;
  
  CompressHistoryItem({
    required this.id,
    required this.name,
    required this.originalSize,
    required this.compressedSize,
    required this.compressionRatio,
    required this.compressedFilePath,
    required this.timestamp,
  });
  
  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originalSize': originalSize,
      'compressedSize': compressedSize,
      'compressionRatio': compressionRatio,
      'compressedFilePath': compressedFilePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  // 从JSON创建
  factory CompressHistoryItem.fromJson(Map<String, dynamic> json) {
    return CompressHistoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      originalSize: json['originalSize'] as int,
      compressedSize: json['compressedSize'] as int,
      compressionRatio: (json['compressionRatio'] as num).toDouble(),
      compressedFilePath: json['compressedFilePath'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
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
  
  String get originalSizeText => formatFileSize(originalSize);
  String get compressedSizeText => formatFileSize(compressedSize);
  
  // 获取格式化的日期时间
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return '刚刚';
        }
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
    }
  }
  
  // 获取文件格式
  String get format {
    final extension = name.split('.').last.toUpperCase();
    return extension;
  }
}
