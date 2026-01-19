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
        format: _getCompressFormat(config.outputFormat, imageFile),
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
      
      // 确定输出格式
      final targetFormat = config.outputFormat ?? _getFormatFromFile(imageFile);
      
      List<int> encoded;
      if (targetFormat == ImageFormat.jpg) {
        encoded = img.encodeJpg(resized, quality: config.quality.toInt());
      } else if (targetFormat == ImageFormat.png) {
        encoded = img.encodePng(resized, level: 6);
      } else if (targetFormat == ImageFormat.webp) {
        encoded = img.encodeJpg(resized, quality: config.quality.toInt());
      } else {
        // 默认使用jpg
        encoded = img.encodeJpg(resized, quality: config.quality.toInt());
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
        format: _getCompressFormat(config.outputFormat, imageFile),
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
    
    // 如果保持原格式，使用原图扩展名
    String extension;
    if (config.keepOriginalFormat) {
      extension = path.extension(imageFile.path).replaceFirst('.', '');
      if (extension.isEmpty) extension = 'jpg'; // 默认
    } else {
      extension = config.formatExtension;
    }
    
    return path.join(
      tempDir.path,
      'compressed_${originalName}_$timestamp.$extension',
    );
  }
  
  // 获取压缩格式（如果为null，根据原图格式判断）
  CompressFormat _getCompressFormat(ImageFormat? format, File? imageFile) {
    if (format != null) {
      switch (format) {
        case ImageFormat.jpg:
          return CompressFormat.jpeg;
        case ImageFormat.png:
          return CompressFormat.png;
        case ImageFormat.webp:
          return CompressFormat.webp;
      }
    }
    
    // 如果为null，根据原图格式判断
    if (imageFile != null) {
      final ext = path.extension(imageFile.path).toLowerCase();
      if (ext == '.png') {
        return CompressFormat.png;
      } else if (ext == '.webp') {
        return CompressFormat.webp;
      }
    }
    
    // 默认使用jpg
    return CompressFormat.jpeg;
  }
  
  // 根据文件路径获取格式
  ImageFormat? _getFormatFromFile(File imageFile) {
    final ext = path.extension(imageFile.path).toLowerCase();
    if (ext == '.png') {
      return ImageFormat.png;
    } else if (ext == '.webp') {
      return ImageFormat.webp;
    } else if (ext == '.jpg' || ext == '.jpeg') {
      return ImageFormat.jpg;
    }
    return ImageFormat.jpg; // 默认
  }
  
  // 获取图片尺寸
  static Future<Map<String, int>?> getImagePixelDimensions(File file) async {
    try {
      final bytes = await file.readAsBytes();
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
