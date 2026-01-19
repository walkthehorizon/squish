import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../models/image_item.dart';
import '../models/compress_config.dart';
import '../models/compress_history_item.dart';
import '../services/image_picker_service.dart';
import '../services/image_compress_service.dart';
import '../services/storage_service.dart';
import '../utils/works_refresh_notifier.dart';

// 图片状态管理Provider
class ImageProvider extends ChangeNotifier {
  final ImagePickerService _pickerService = ImagePickerService();
  final ImageCompressService _compressService = ImageCompressService();
  
  // 图片列表
  final List<ImageItem> _images = [];
  List<ImageItem> get images => _images;
  
  // 压缩配置
  CompressConfig _config = CompressConfig();
  CompressConfig get config => _config;
  
  // 处理状态
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;
  
  int _processedCount = 0;
  int get processedCount => _processedCount;
  
  double get progress {
    if (_images.isEmpty) return 0;
    return _processedCount / _images.length;
  }
  
  // 是否有图片
  bool get hasImages => _images.isNotEmpty;
  
  // 是否全部完成
  bool get isAllCompleted {
    if (_images.isEmpty) return false;
    return _images.every((img) => img.isCompleted);
  }
  
  // 更新配置
  void updateConfig(CompressConfig newConfig) {
    _config = newConfig;
    notifyListeners();
  }
  
  // 添加图片
  Future<void> addImages() async {
    try {
      final files = await _pickerService.pickMultipleImages();
      if (files == null || files.isEmpty) return;
      await addFiles(files);
    } catch (e) {
      debugPrint('添加图片失败: $e');
      rethrow;
    }
  }

  // 手动添加已选文件
  Future<void> addFiles(List<File> files) async {
    for (final file in files) {
      // 检查格式
      if (!_pickerService.isSupportedFormat(file.path)) {
        continue;
      }
      
      // 获取文件信息
      final name = path.basename(file.path);
      final size = await _pickerService.getFileSize(file);
      
      // 创建图片项
      final imageItem = ImageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString() + _images.length.toString(),
        originalFile: file,
        name: name,
        originalSize: size,
      );
      
      _images.add(imageItem);
    }
    
    notifyListeners();
  }
  
  // 移除图片
  void removeImage(String id) {
    _images.removeWhere((img) => img.id == id);
    notifyListeners();
  }
  
  // 清空所有图片
  void clearAll() {
    _images.clear();
    _processedCount = 0;
    notifyListeners();
  }
  
  // 从历史记录加载图片（用于预览历史压缩记录）
  void loadFromHistory(List<CompressHistoryItem> historyList) {
    _images.clear();
    _processedCount = 0;
    
    for (final history in historyList) {
      final compressedFile = File(history.compressedFilePath);
      // 只加载文件仍然存在的记录
      if (compressedFile.existsSync()) {
        final imageItem = ImageItem(
          id: history.id,
          originalFile: compressedFile, // 历史记录中没有原图，用压缩后的作为原图
          name: history.name,
          originalSize: history.originalSize,
          compressedFile: compressedFile,
          compressedSize: history.compressedSize,
          isProcessing: false,
          isCompleted: true,
        );
        _images.add(imageItem);
      }
    }
    
    notifyListeners();
  }
  
  // 开始批量压缩
  Future<void> startCompression() async {
    if (_images.isEmpty || _isProcessing) return;
    
    _isProcessing = true;
    _processedCount = 0;
    notifyListeners();
    
    try {
      for (int i = 0; i < _images.length; i++) {
        final image = _images[i];
        
        // 更新为处理中状态
        _images[i] = image.copyWith(
          isProcessing: true,
          isCompleted: false,
        );
        notifyListeners();
        
        try {
          // 压缩图片
          final compressedFile = await _compressService.compressImage(
            image.originalFile,
            _config,
          );
          
          if (compressedFile != null) {
            final compressedSize = await compressedFile.length();
            
            // 检查体积是否变大或不变（格式转换除外）
            final isFormatConvert = _isFormatConvert(image.originalFile.path, compressedFile.path);
            if (!isFormatConvert && compressedSize >= image.originalSize) {
              // 体积变大或不变，使用原图
              _images[i] = image.copyWith(
                compressedFile: image.originalFile,
                compressedSize: image.originalSize,
                isProcessing: false,
                isCompleted: true,
              );
            } else {
              // 更新为完成状态
              _images[i] = image.copyWith(
                compressedFile: compressedFile,
                compressedSize: compressedSize,
                isProcessing: false,
                isCompleted: true,
              );
            }
          } else {
            // 压缩失败
            _images[i] = image.copyWith(
              isProcessing: false,
              isCompleted: true,
              errorMessage: '压缩失败',
            );
          }
        } catch (e) {
          // 出现异常
          _images[i] = image.copyWith(
            isProcessing: false,
            isCompleted: true,
            errorMessage: e.toString(),
          );
        }
        
        _processedCount++;
        notifyListeners();
      }
    } finally {
      _isProcessing = false;
      notifyListeners();
      
      // 保存成功的压缩记录到本地
      await StorageService.saveCompressHistory(_images);
      
      // 通知作品页刷新
      WorksRefreshNotifier().notifyRefresh();
    }
  }
  
  // 判断是否为格式转换
  bool _isFormatConvert(String originalPath, String compressedPath) {
    final originalExt = originalPath.split('.').last.toLowerCase();
    final compressedExt = compressedPath.split('.').last.toLowerCase();
    return originalExt != compressedExt;
  }
  
  // 压缩单张图片
  Future<void> compressSingleImage(String id) async {
    final index = _images.indexWhere((img) => img.id == id);
    if (index == -1) return;
    
    final image = _images[index];
    
    // 更新为处理中状态
    _images[index] = image.copyWith(
      isProcessing: true,
      isCompleted: false,
    );
    notifyListeners();
    
    try {
      // 压缩图片
      final compressedFile = await _compressService.compressImage(
        image.originalFile,
        _config,
      );
      
      if (compressedFile != null) {
        final compressedSize = await compressedFile.length();
        
        // 更新为完成状态
        _images[index] = image.copyWith(
          compressedFile: compressedFile,
          compressedSize: compressedSize,
          isProcessing: false,
          isCompleted: true,
        );
      } else {
        // 压缩失败
        _images[index] = image.copyWith(
          isProcessing: false,
          isCompleted: true,
          errorMessage: '压缩失败',
        );
      }
    } catch (e) {
      // 出现异常
      _images[index] = image.copyWith(
        isProcessing: false,
        isCompleted: true,
        errorMessage: e.toString(),
      );
    }
    
    notifyListeners();
  }
  
  // 获取统计信息
  Map<String, dynamic> getStatistics() {
    int totalOriginalSize = 0;
    int totalCompressedSize = 0;
    int successCount = 0;
    
    for (final image in _images) {
      totalOriginalSize += image.originalSize;
      if (image.isSuccess) {
        totalCompressedSize += image.compressedSize ?? 0;
        successCount++;
      }
    }
    
    final compressionRatio = totalOriginalSize > 0
        ? ((totalOriginalSize - totalCompressedSize) / totalOriginalSize * 100)
        : 0.0;
    
    return {
      'totalCount': _images.length,
      'successCount': successCount,
      'failedCount': _images.length - successCount,
      'totalOriginalSize': totalOriginalSize,
      'totalCompressedSize': totalCompressedSize,
      'compressionRatio': compressionRatio,
    };
  }
  
  // 重置图片状态
  void resetImage(String id) {
    final index = _images.indexWhere((img) => img.id == id);
    if (index == -1) return;
    
    final image = _images[index];
    _images[index] = image.copyWith(
      compressedFile: null,
      compressedSize: null,
      isProcessing: false,
      isCompleted: false,
      errorMessage: null,
    );
    notifyListeners();
  }
}
