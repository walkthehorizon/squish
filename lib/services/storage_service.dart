import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/compress_history_item.dart';
import '../models/image_item.dart';

// 本地存储服务
class StorageService {
  static const String _historyKey = 'compress_history';
  static const int _maxHistoryItems = 100; // 最多保存100条历史记录
  
  // 保存压缩历史记录
  static Future<void> saveCompressHistory(List<ImageItem> images) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 读取现有历史记录
      List<CompressHistoryItem> historyList = await getCompressHistory();
      
      // 将成功的压缩记录转换为历史项
      for (final image in images) {
        if (image.isSuccess && image.compressedFile != null) {
          final historyItem = CompressHistoryItem(
            id: image.id,
            name: image.name,
            originalSize: image.originalSize,
            compressedSize: image.compressedSize!,
            compressionRatio: image.compressionRatio,
            compressedFilePath: image.compressedFile!.path,
            timestamp: DateTime.now(),
          );
          
          // 添加到列表开头（最新的在前面）
          historyList.insert(0, historyItem);
        }
      }
      
      // 限制历史记录数量
      if (historyList.length > _maxHistoryItems) {
        historyList = historyList.sublist(0, _maxHistoryItems);
      }
      
      // 转换为JSON字符串列表
      final jsonList = historyList.map((item) => jsonEncode(item.toJson())).toList();
      
      // 保存到本地
      await prefs.setStringList(_historyKey, jsonList);
    } catch (e) {
      print('保存历史记录失败: $e');
    }
  }
  
  // 获取压缩历史记录
  static Future<List<CompressHistoryItem>> getCompressHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_historyKey) ?? [];
      
      // 转换为历史项列表，并过滤掉文件不存在的记录
      final historyList = <CompressHistoryItem>[];
      for (final jsonString in jsonList) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final item = CompressHistoryItem.fromJson(json);
          
          // 检查文件是否还存在
          if (await File(item.compressedFilePath).exists()) {
            historyList.add(item);
          }
        } catch (e) {
          print('解析历史记录项失败: $e');
        }
      }
      
      return historyList;
    } catch (e) {
      print('读取历史记录失败: $e');
      return [];
    }
  }
  
  // 清除历史记录
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('清除历史记录失败: $e');
    }
  }
  
  // 删除单条历史记录
  static Future<void> deleteHistoryItem(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<CompressHistoryItem> historyList = await getCompressHistory();
      
      // 移除指定ID的记录
      historyList.removeWhere((item) => item.id == id);
      
      // 转换为JSON字符串列表
      final jsonList = historyList.map((item) => jsonEncode(item.toJson())).toList();
      
      // 保存到本地
      await prefs.setStringList(_historyKey, jsonList);
    } catch (e) {
      print('删除历史记录失败: $e');
    }
  }
}
