import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../models/image_item.dart';
import '../widgets/image_grid_item.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import 'config_screen.dart';
import 'preview_screen.dart';

// 主页面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
  
  // 构建AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icon.png',
            height: 32,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image, size: 32);
            },
          ),
          const SizedBox(width: 8),
          const Text(AppConstants.appName),
        ],
      ),
      actions: [
        // 统计信息按钮
        Consumer<app_provider.ImageProvider>(
          builder: (context, provider, child) {
            if (!provider.hasImages) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showStatistics(context, provider),
            );
          },
        ),
      ],
    );
  }
  
  // 构建主体内容
  Widget _buildBody(BuildContext context) {
    return Consumer<app_provider.ImageProvider>(
      builder: (context, provider, child) {
        if (!provider.hasImages) {
          return _buildEmptyState(context);
        }
        
        return Column(
          children: [
            // 进度条
            if (provider.isProcessing) _buildProgressBar(provider),
            
            // 图片网格
            Expanded(
              child: _buildImageGrid(context, provider),
            ),
          ],
        );
      },
    );
  }
  
  // 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            '还没有图片',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角按钮添加图片',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
        ],
      ),
    );
  }
  
  // 构建进度条
  Widget _buildProgressBar(app_provider.ImageProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.lightOrange.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '正在压缩 ${provider.processedCount}/${provider.images.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryOrange,
                ),
              ),
              Text(
                '${(provider.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: provider.progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
          ),
        ],
      ),
    );
  }
  
  // 构建图片网格
  Widget _buildImageGrid(BuildContext context, app_provider.ImageProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: provider.images.length,
      itemBuilder: (context, index) {
        final image = provider.images[index];
        return ImageGridItem(
          imageItem: image,
          onRemove: () => _confirmRemove(context, provider, image.id),
          onTap: () {
            if (image.isSuccess && provider.config.showPreview) {
              _showPreview(context, image.id);
            }
          },
        );
      },
    );
  }
  
  // 构建悬浮按钮
  Widget _buildFAB(BuildContext context) {
    return Consumer<app_provider.ImageProvider>(
      builder: (context, provider, child) {
        return FloatingActionButton(
          onPressed: provider.isProcessing ? null : () => _addImages(context, provider),
          tooltip: '添加图片',
          child: const Icon(Icons.add_photo_alternate),
        );
      },
    );
  }
  
  // 构建底部栏
  Widget _buildBottomBar(BuildContext context) {
    return Consumer<app_provider.ImageProvider>(
      builder: (context, provider, child) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // 配置按钮
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _openConfig(context),
                  tooltip: '压缩配置',
                ),
                
                const SizedBox(width: 8),
                
                // 清空按钮
                TextButton.icon(
                  onPressed: provider.hasImages && !provider.isProcessing
                      ? () => _confirmClearAll(context, provider)
                      : null,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('清空'),
                ),
                
                const Spacer(),
                
                // 开始压缩按钮
                ElevatedButton.icon(
                  onPressed: provider.hasImages && !provider.isProcessing
                      ? () => _startCompression(context, provider)
                      : null,
                  icon: const Icon(Icons.compress),
                  label: const Text('开始压缩'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // 添加图片
  Future<void> _addImages(BuildContext context, app_provider.ImageProvider provider) async {
    try {
      await provider.addImages();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('添加图片失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  // 打开配置页面
  Future<void> _openConfig(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigScreen(),
      ),
    );
  }
  
  // 开始压缩
  Future<void> _startCompression(BuildContext context, app_provider.ImageProvider provider) async {
    try {
      await provider.startCompression();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('压缩完成！'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // 如果开启了预览，自动跳转到第一张成功的图片
        if (provider.config.showPreview) {
          final firstSuccess = provider.images.firstWhere(
            (img) => img.isSuccess,
            orElse: () => provider.images.first,
          );
          if (firstSuccess.isSuccess) {
            _showPreview(context, firstSuccess.id);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('压缩失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  // 显示预览
  void _showPreview(BuildContext context, String imageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(imageId: imageId),
      ),
    );
  }
  
  // 确认删除图片
  Future<void> _confirmRemove(BuildContext context, app_provider.ImageProvider provider, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这张图片吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      provider.removeImage(id);
    }
  }
  
  // 确认清空所有
  Future<void> _confirmClearAll(BuildContext context, app_provider.ImageProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('确定要清空所有图片吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      provider.clearAll();
    }
  }
  
  // 显示统计信息
  void _showStatistics(BuildContext context, app_provider.ImageProvider provider) {
    final stats = provider.getStatistics();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.analytics, color: AppTheme.primaryOrange),
            SizedBox(width: 8),
            Text('统计信息'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('总图片数', '${stats['totalCount']}'),
            _buildStatRow('成功压缩', '${stats['successCount']}'),
            _buildStatRow('失败数量', '${stats['failedCount']}'),
            const Divider(),
            _buildStatRow('原始总大小', 
                ImageItem.formatFileSize(stats['totalOriginalSize'])),
            _buildStatRow('压缩后大小', 
                ImageItem.formatFileSize(stats['totalCompressedSize'])),
            _buildStatRow('总压缩率', 
                '${stats['compressionRatio'].toStringAsFixed(1)}%',
                highlight: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
  
  // 构建统计行
  Widget _buildStatRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlight ? AppTheme.primaryOrange : null,
            ),
          ),
        ],
      ),
    );
  }
}
