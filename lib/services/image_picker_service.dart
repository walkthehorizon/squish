import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/constants.dart';

// 图片选择服务
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  
  // 检查并请求相册权限
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ 使用 photos 权限
      PermissionStatus status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
      // 如果 photos 权限不可用，尝试 storage 权限
      if (!status.isGranted) {
        status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }
      return status.isGranted;
    } else if (Platform.isIOS) {
      PermissionStatus status = await Permission.photos.status;
      if (!status.isGranted && status != PermissionStatus.limited) {
        status = await Permission.photos.request();
      }
      // iOS 14+：用户选择「选取照片」时为 limited，仍可打开选择器
      return status.isGranted || status == PermissionStatus.limited;
    }
    return true;
  }
  
  // 从相册选择多张图片
  Future<List<File>?> pickMultipleImages() async {
    try {
      bool hasPermission = await requestPermission();
      // iOS：即使 permission 未授予也尝试打开选择器（iOS 14+ PHPicker 可能仍可用）
      if (!hasPermission && !Platform.isIOS) {
        throw Exception('没有相册访问权限');
      }

      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 100, // 选择原图
        limit: AppConstants.maxImageCount, // 限制数量
      );

      if (images.isEmpty) {
        return null;
      }

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      if (e is Exception && e.toString().contains('没有相册访问权限')) {
        rethrow;
      }
      throw Exception('选择图片失败: $e');
    }
  }
  
  // 从相册选择单张图片
  Future<File?> pickSingleImage() async {
    try {
      bool hasPermission = await requestPermission();
      if (!hasPermission && !Platform.isIOS) {
        throw Exception('没有相册访问权限');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) {
        return null;
      }

      return File(image.path);
    } catch (e) {
      if (e is Exception && e.toString().contains('没有相册访问权限')) {
        rethrow;
      }
      throw Exception('选择图片失败: $e');
    }
  }
  
  // 验证文件格式
  bool isSupportedFormat(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return AppConstants.supportedFormats.contains(extension);
  }
  
  // 获取文件大小
  Future<int> getFileSize(File file) async {
    try {
      return await file.length();
    } catch (e) {
      return 0;
    }
  }
}
