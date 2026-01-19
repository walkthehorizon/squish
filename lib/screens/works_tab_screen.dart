import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../utils/theme.dart';
import '../models/image_item.dart';
import 'preview_screen.dart';

// 作品Tab - 压缩记录
class WorksTabScreen extends StatelessWidget {
  const WorksTabScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('压缩记录'),
        centerTitle: true,
        actions: [
          Consumer<app_provider.ImageProvider>(
            builder: (context, provider, child) {
              if (!provider.hasImages) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _showClearDialog(context, provider),
                child: const Text(
                  '清除',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<app_provider.ImageProvider>(
        builder: (context, provider, child) {
          if (!provider.hasImages) {
            return _buildEmptyState();
          }
          
          // 只显示已完成的图片
          final completedImages = provider.images
              .where((img) => img.isCompleted)
              .toList()
              .reversed
              .toList();
          
          if (completedImages.isEmpty) {
            return _buildEmptyState();
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedImages.length,
            itemBuilder: (context, index) {
              return _buildRecordItem(context, completedImages[index]);
            },
          );
        },
      ),
    );
  }
  
  // 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无压缩记录',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
  
  // 构建记录项
  Widget _buildRecordItem(BuildContext context, ImageItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: item.isSuccess
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewScreen(imageId: item.id),
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 缩略图
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  item.originalFile,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 时间
                    Text(
                      _formatDate(item.id),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 格式
                    Text(
                      '格式: ${_getFileExtension(item.name)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 大小
                    Row(
                      children: [
                        Text(
                          '大小: ${item.originalSizeText}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (item.isSuccess) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.compressedSizeText,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // 状态标识
              if (item.isSuccess)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '-${item.compressionRatio.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (item.errorMessage != null)
                const Icon(
                  Icons.error_outline,
                  color: AppTheme.errorColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 格式化日期
  String _formatDate(String id) {
    try {
      final timestamp = int.parse(id.substring(0, 13));
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
             '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return '未知时间';
    }
  }
  
  // 获取文件扩展名
  String _getFileExtension(String filename) {
    return filename.split('.').last.toUpperCase();
  }
  
  // 显示清空对话框
  void _showClearDialog(BuildContext context, app_provider.ImageProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空记录'),
        content: const Text('确定要清空所有压缩记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
