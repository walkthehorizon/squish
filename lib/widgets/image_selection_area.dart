import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../utils/theme.dart';

// 图片选择区域组件
class ImageSelectionArea extends StatelessWidget {
  const ImageSelectionArea({super.key});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Consumer<app_provider.ImageProvider>(
            builder: (context, provider, child) {
              
              // 计算有图片时的高度（两行，每行高度 + 间距 + padding）
              final imageAreaHeight = provider.hasImages 
                  ? (MediaQuery.of(context).size.width - 48 - 24) / 3 * 2 + 16 +12 // 两行高度 + 间距 + padding
                  : 160.0;
              
              return InkWell(
                onTap: () => _pickImages(context, provider),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: imageAreaHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: provider.hasImages
                      ? _buildImagePreview(context, provider)
                      : _buildEmptyState(),
                ),
              );
            },
          ),
        );
      },
    );
  }
  
  // 构建空状态
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFE5D9), Color(0xFFFFCCBC)],
            ),
          ),
          child: const Icon(
            Icons.add,
            size: 40,
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '请选取图片',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
  
  // 构建图片预览
  Widget _buildImagePreview(BuildContext context, app_provider.ImageProvider provider) {
    final imageCount = provider.images.length;
    final maxDisplay = 6; // 最多显示6个（两行）
    
    // 计算要显示的item数量
    int itemCount;
    if (imageCount < maxDisplay) {
      // 不满6个时，显示所有图片 + 一个"+"占位
      itemCount = imageCount + 1;
    } else {
      // 超过6个时，显示前5个 + 第6个显示"+N"
      itemCount = maxDisplay;
    }
    
    return Stack(
      children: [
        // 图片网格
        GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0, // 确保宽高一致（正方形）
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // 如果不满6个，最后一个位置显示"+"占位
            if (imageCount < maxDisplay && index == imageCount) {
              return _buildAddPlaceholder();
            }
            
            // 如果超过6个，第6个位置显示"+N"
            if (imageCount >= maxDisplay && index == 5) {
              return _buildMorePlaceholder(imageCount - 5);
            }
            
            // 显示图片（带删除按钮）
            return _buildImageItem(context, provider, index);
          },
        ),
        
      ],
    );
  }
  
  // 构建"+"占位符
  Widget _buildAddPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.add,
          size: 32,
          color: AppTheme.primaryOrange,
        ),
      ),
    );
  }
  
  // 构建"+N"占位符
  Widget _buildMorePlaceholder(int moreCount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '+$moreCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  // 构建图片项（带删除按钮）
  Widget _buildImageItem(
    BuildContext context,
    app_provider.ImageProvider provider,
    int index,
  ) {
    return Stack(
      children: [
        // 图片
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            provider.images[index].originalFile,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              );
            },
          ),
        ),
        
        // 删除按钮
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(context, provider, index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // 移除单张图片
  void _removeImage(
    BuildContext context,
    app_provider.ImageProvider provider,
    int index,
  ) {
    if (index < provider.images.length) {
      provider.removeImage(provider.images[index].id);
    }
  }
  
  // 选择图片
  Future<void> _pickImages(
    BuildContext context,
    app_provider.ImageProvider provider,
  ) async {
    try {
      await provider.addImages();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('选择图片失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
