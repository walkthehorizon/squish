import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/compress_config.dart';
import '../utils/constants.dart';

// 图片压缩服务
class ImageCompressService {
  
  // 压缩图片（根据配置）
  Future<File?> compressImage(File imageFile, CompressConfig config) async {
    try {
      switch (config.mode) {
        case CompressMode.scale:
          return await _compressWithScale(imageFile, config);
        case CompressMode.resize:
          return await _compressWithResize(imageFile, config);
        case CompressMode.smart:
          return await _compressWithSmart(imageFile, config);
      }
    } catch (e) {
      throw Exception('压缩失败: $e');
    }
  }
  
  // 等比压缩
  Future<File?> _compressWithScale(File imageFile, CompressConfig config) async {
    try {
      // 读取图片获取原始尺寸
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception('无法解析图片');
      
      // 计算新的尺寸
      final newWidth = (image.width * config.scaleRatio).round();
      final newHeight = (image.height * config.scaleRatio).round();
      
      // 生成输出路径
      final outputPath = await _generateOutputPath(imageFile, config);
      
      // 使用 flutter_image_compress 压缩
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        outputPath,
        quality: config.quality.toInt(),
        minWidth: newWidth,
        minHeight: newHeight,
        format: _getCompressFormat(config.outputFormat),
      );
      
      return result != null ? File(result.path) : null;
    } catch (e) {
      throw Exception('等比压缩失败: $e');
    }
  }
  
  // 指定尺寸压缩
  Future<File?> _compressWithResize(File imageFile, CompressConfig config) async {
    try {
      // 读取图片
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception('无法解析图片');
      
      img.Image resized;
      
      // 根据填充模式处理
      switch (config.fitMode) {
        case FitMode.contain:
          // 保持比例，留白
          resized = img.copyResize(
            image,
            width: config.targetWidth,
            height: config.targetHeight,
            maintainAspect: true,
          );
          break;
        case FitMode.cover:
          // 覆盖，裁剪
          resized = img.copyResizeCropSquare(image, size: config.targetWidth);
          break;
        case FitMode.fill:
          // 拉伸填充
          resized = img.copyResize(
            image,
            width: config.targetWidth,
            height: config.targetHeight,
            maintainAspect: false,
          );
          break;
      }
      
      // 保存图片
      final outputPath = await _generateOutputPath(imageFile, config);
      final outputFile = File(outputPath);
      
      List<int> encoded;
      switch (config.outputFormat) {
        case ImageFormat.jpg:
          encoded = img.encodeJpg(resized, quality: config.quality.toInt());
          break;
        case ImageFormat.png:
          encoded = img.encodePng(resized, level: 6);
          break;
        case ImageFormat.webp:
          encoded = img.encodeJpg(resized, quality: config.quality.toInt());
          break;
      }
      
      await outputFile.writeAsBytes(encoded);
      return outputFile;
    } catch (e) {
      throw Exception('指定尺寸压缩失败: $e');
    }
  }
  
  // 智能压缩
  Future<File?> _compressWithSmart(File imageFile, CompressConfig config) async {
    try {
      // 读取图片获取原始信息
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception('无法解析图片');
      
      final originalSize = await imageFile.length();
      
      // 智能计算压缩参数
      int quality = config.quality.toInt();
      int newWidth = image.width;
      int newHeight = image.height;
      
      // 如果图片太大，自动缩小
      if (image.width > 2048 || image.height > 2048) {
        final ratio = 2048 / (image.width > image.height ? image.width : image.height);
        newWidth = (image.width * ratio).round();
        newHeight = (image.height * ratio).round();
      }
      
      // 如果文件太大，降低质量
      if (originalSize > 5 * AppConstants.bytesPerMB) {
        quality = 75;
      } else if (originalSize > 2 * AppConstants.bytesPerMB) {
        quality = 85;
      }
      
      // 生成输出路径
      final outputPath = await _generateOutputPath(imageFile, config);
      
      // 压缩
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        outputPath,
        quality: quality,
        minWidth: newWidth,
        minHeight: newHeight,
        format: _getCompressFormat(config.outputFormat),
      );
      
      return result != null ? File(result.path) : null;
    } catch (e) {
      throw Exception('智能压缩失败: $e');
    }
  }
  
  // 生成输出文件路径
  Future<String> _generateOutputPath(File imageFile, CompressConfig config) async {
    final tempDir = await getTemporaryDirectory();
    final originalName = path.basenameWithoutExtension(imageFile.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = config.formatExtension;
    
    return path.join(
      tempDir.path,
      'compressed_${originalName}_$timestamp.$extension',
    );
  }
  
  // 获取压缩格式
  CompressFormat _getCompressFormat(ImageFormat format) {
    switch (format) {
      case ImageFormat.jpg:
        return CompressFormat.jpeg;
      case ImageFormat.png:
        return CompressFormat.png;
      case ImageFormat.webp:
        return CompressFormat.webp;
    }
  }
  
  // 获取图片尺寸
  Future<Map<String, int>?> getImageDimensions(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;
      
      return {
        'width': image.width,
        'height': image.height,
      };
    } catch (e) {
      return null;
    }
  }
  
  // 批量压缩图片
  Stream<Map<String, dynamic>> compressBatch(
    List<File> imageFiles,
    CompressConfig config,
  ) async* {
    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final compressed = await compressImage(imageFiles[i], config);
        yield {
          'index': i,
          'success': true,
          'file': compressed,
          'error': null,
        };
      } catch (e) {
        yield {
          'index': i,
          'success': false,
          'file': null,
          'error': e.toString(),
        };
      }
    }
  }
}
