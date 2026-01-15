import 'package:flutter/material.dart';
import '../models/image_item.dart';
import '../utils/theme.dart';

// 图片网格项组件
class ImageGridItem extends StatelessWidget {
  final ImageItem imageItem;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  
  const ImageGridItem({
    super.key,
    required this.imageItem,
    this.onRemove,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // 图片预览
            _buildImagePreview(),
            
            // 状态覆盖层
            if (imageItem.isProcessing) _buildProcessingOverlay(),
            if (imageItem.isCompleted && !imageItem.isSuccess) _buildErrorOverlay(),
            if (imageItem.isSuccess) _buildSuccessOverlay(),
            
            // 底部信息栏
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildInfoBar(),
            ),
            
            // 删除按钮
            if (onRemove != null)
              Positioned(
                top: 4,
                right: 4,
                child: _buildRemoveButton(),
              ),
          ],
        ),
      ),
    );
  }
  
  // 构建图片预览
  Widget _buildImagePreview() {
    return Image.file(
      imageItem.originalFile,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
          ),
        );
      },
    );
  }
  
  // 构建处理中覆盖层
  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
  
  // 构建错误覆盖层
  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              imageItem.errorMessage ?? '压缩失败',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建成功覆盖层
  Widget _buildSuccessOverlay() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.successColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              '${imageItem.compressionRatio.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建底部信息栏
  Widget _buildInfoBar() {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 文件名
          Text(
            imageItem.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // 文件大小信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                imageItem.originalSizeText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
              if (imageItem.isSuccess)
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white70,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      imageItem.compressedSizeText,
                      style: const TextStyle(
                        color: AppTheme.lightOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  // 构建删除按钮
  Widget _buildRemoveButton() {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onRemove,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
