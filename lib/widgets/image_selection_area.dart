import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../utils/theme.dart';

// 图片选择区域组件
class ImageSelectionArea extends StatelessWidget {
  const ImageSelectionArea({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Consumer<app_provider.ImageProvider>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () => _pickImages(context, provider),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 200,
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
    return Stack(
      children: [
        // 图片网格
        GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: provider.images.length > 6 ? 6 : provider.images.length,
          itemBuilder: (context, index) {
            if (index == 5 && provider.images.length > 6) {
              // 显示更多
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '+${provider.images.length - 5}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                provider.images[index].originalFile,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              ),
            );
          },
        ),
        
        // 重新选择按钮
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: AppTheme.primaryOrange,
              ),
              onPressed: () => _pickImages(context, provider),
            ),
          ),
        ),
      ],
    );
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
