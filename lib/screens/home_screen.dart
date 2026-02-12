import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/image_provider.dart' as app_provider;
import '../models/image_item.dart';
import '../widgets/image_grid_item.dart';
import '../utils/theme.dart';
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
          Text(AppLocalizations.of(context).appName),
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
            if (provider.isProcessing) _buildProgressBar(context, provider),
            
            // 图片网格
            Expanded(
              child: _buildImageGrid(context, provider),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            l10n.noImagesYet,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToAddImages,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar(BuildContext context, app_provider.ImageProvider provider) {
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
                AppLocalizations.of(context).compressingProgress(
                    '${provider.processedCount}', '${provider.images.length}'),
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
          tooltip: AppLocalizations.of(context).addImages,
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
                  tooltip: AppLocalizations.of(context).compressConfig,
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: provider.hasImages && !provider.isProcessing
                      ? () => _confirmClearAll(context, provider)
                      : null,
                  icon: const Icon(Icons.clear_all),
                  label: Text(AppLocalizations.of(context).clear),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: provider.hasImages && !provider.isProcessing
                      ? () => _startCompression(context, provider)
                      : null,
                  icon: const Icon(Icons.compress),
                  label: Text(AppLocalizations.of(context).startCompress),
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
            content: Text(AppLocalizations.of(context).addImagesFailed(e.toString())),
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
          SnackBar(
            content: Text(AppLocalizations.of(context).compressDone),
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
            content: Text(AppLocalizations.of(context).compressFailed(e.toString())),
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
  
  Future<void> _confirmRemove(BuildContext context, app_provider.ImageProvider provider, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      provider.removeImage(id);
    }
  }
  
  Future<void> _confirmClearAll(BuildContext context, app_provider.ImageProvider provider) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmClear),
        content: Text(l10n.confirmClearContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      provider.clearAll();
    }
  }
  
  void _showStatistics(BuildContext context, app_provider.ImageProvider provider) {
    final l10n = AppLocalizations.of(context);
    final stats = provider.getStatistics();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.analytics, color: AppTheme.primaryOrange),
            const SizedBox(width: 8),
            Text(l10n.statistics),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow(l10n.totalCount, '${stats['totalCount']}'),
            _buildStatRow(l10n.successCount, '${stats['successCount']}'),
            _buildStatRow(l10n.failedCount, '${stats['failedCount']}'),
            const Divider(),
            _buildStatRow(l10n.totalOriginalSize,
                ImageItem.formatFileSize(stats['totalOriginalSize'])),
            _buildStatRow(l10n.totalCompressedSize,
                ImageItem.formatFileSize(stats['totalCompressedSize'])),
            _buildStatRow(l10n.totalRatio,
                '${stats['compressionRatio'].toStringAsFixed(1)}%',
                highlight: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
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
