import 'package:flutter/material.dart';
import '../models/image_item.dart';
import '../utils/theme.dart';

// 图片对比视图组件
class ImageCompareView extends StatefulWidget {
  final ImageItem imageItem;
  
  const ImageCompareView({
    super.key,
    required this.imageItem,
  });
  
  @override
  State<ImageCompareView> createState() => _ImageCompareViewState();
}

class _ImageCompareViewState extends State<ImageCompareView> {
  double _sliderPosition = 0.5;
  
  @override
  Widget build(BuildContext context) {
    if (!widget.imageItem.isSuccess) {
      return _buildErrorView();
    }
    
    return Column(
      children: [
        // 对比滑块视图
        Expanded(
          child: _buildComparisonSlider(),
        ),
        
        // 信息面板
        _buildInfoPanel(),
      ],
    );
  }
  
  // 构建错误视图
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            widget.imageItem.errorMessage ?? '压缩失败',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
  
  // 构建对比滑块
  Widget _buildComparisonSlider() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sliderPosition += details.delta.dx / context.size!.width;
          _sliderPosition = _sliderPosition.clamp(0.0, 1.0);
        });
      },
      child: Stack(
        children: [
          // 压缩后的图片（底层）
          Positioned.fill(
            child: Image.file(
              widget.imageItem.compressedFile!,
              fit: BoxFit.contain,
            ),
          ),
          
          // 原始图片（顶层，根据滑块位置裁剪）
          ClipRect(
            clipper: _ImageClipper(_sliderPosition),
            child: Image.file(
              widget.imageItem.originalFile,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          // 分割线和标签
          Positioned(
            left: MediaQuery.of(context).size.width * _sliderPosition - 2,
            top: 0,
            bottom: 0,
            child: _buildDivider(),
          ),
        ],
      ),
    );
  }
  
  // 构建分割线
  Widget _buildDivider() {
    return Column(
      children: [
        // 顶部标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '原图',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // 中间分割线
        Expanded(
          child: Container(
            width: 4,
            color: AppTheme.primaryOrange,
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.unfold_more,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        
        // 底部标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.secondaryOrange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '压缩',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  // 构建信息面板
  Widget _buildInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 文件名
          Text(
            widget.imageItem.name,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 16),
          
          // 统计信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.photo,
                label: '原始大小',
                value: widget.imageItem.originalSizeText,
                color: AppTheme.textSecondary,
              ),
              _buildStatItem(
                icon: Icons.compress,
                label: '压缩后',
                value: widget.imageItem.compressedSizeText,
                color: AppTheme.primaryOrange,
              ),
              _buildStatItem(
                icon: Icons.trending_down,
                label: '压缩率',
                value: '${widget.imageItem.compressionRatio.toStringAsFixed(1)}%',
                color: AppTheme.successColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // 构建统计项
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// 自定义裁剪器
class _ImageClipper extends CustomClipper<Rect> {
  final double position;
  
  _ImageClipper(this.position);
  
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * position, size.height);
  }
  
  @override
  bool shouldReclip(_ImageClipper oldClipper) {
    return oldClipper.position != position;
  }
}
