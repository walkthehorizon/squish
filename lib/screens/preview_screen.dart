import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../providers/image_provider.dart' as app_provider;
import '../widgets/image_compare_view.dart';
import '../utils/theme.dart';

// 预览对比页面
class PreviewScreen extends StatefulWidget {
  final String imageId;
  
  const PreviewScreen({
    super.key,
    required this.imageId,
  });
  
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    final provider = context.read<app_provider.ImageProvider>();
    _currentIndex = provider.images.indexWhere((img) => img.id == widget.imageId);
    if (_currentIndex == -1) _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  
  // 构建AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Consumer<app_provider.ImageProvider>(
        builder: (context, provider, child) {
          if (provider.images.isEmpty) {
            return const Text('图片预览');
          }
          return Text('${_currentIndex + 1} / ${provider.images.length}');
        },
      ),
      actions: [
        // 分享按钮
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareImage,
          tooltip: '分享',
        ),
        // 保存按钮
        IconButton(
          icon: const Icon(Icons.save_alt),
          onPressed: _saveImage,
          tooltip: '保存',
        ),
      ],
    );
  }
  
  // 构建主体内容
  Widget _buildBody() {
    return Consumer<app_provider.ImageProvider>(
      builder: (context, provider, child) {
        if (provider.images.isEmpty) {
          return const Center(
            child: Text(
              '没有图片',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        
        // 过滤出成功压缩的图片
        final successImages = provider.images.where((img) => img.isSuccess).toList();
        
        if (successImages.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.white70, size: 64),
                SizedBox(height: 16),
                Text(
                  '没有可预览的图片',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }
        
        return PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: successImages.length,
          itemBuilder: (context, index) {
            return ImageCompareView(imageItem: successImages[index]);
          },
        );
      },
    );
  }
  
  // 构建底部操作栏
  Widget _buildBottomBar() {
    return Consumer<app_provider.ImageProvider>(
      builder: (context, provider, child) {
        if (provider.images.isEmpty) {
          return const SizedBox.shrink();
        }
        
        final successImages = provider.images.where((img) => img.isSuccess).toList();
        if (successImages.isEmpty || _currentIndex >= successImages.length) {
          return const SizedBox.shrink();
        }
        
        final currentImage = successImages[_currentIndex];
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            border: Border(
              top: BorderSide(color: Colors.grey[800]!),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 上一张按钮
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: _currentIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              
              const Spacer(),
              
              // 快速信息显示
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentImage.truncatedName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '压缩率 ${currentImage.compressionRatio.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${currentImage.originalSizeText} → ${currentImage.compressedSizeText}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
              // 下一张按钮
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: _currentIndex < successImages.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
  
  // 分享图片
  Future<void> _shareImage() async {
    try {
      final provider = context.read<app_provider.ImageProvider>();
      final successImages = provider.images.where((img) => img.isSuccess).toList();
      
      if (_currentIndex >= successImages.length) return;
      
      final currentImage = successImages[_currentIndex];
      if (currentImage.compressedFile == null) return;
      
      await Share.shareXFiles(
        [XFile(currentImage.compressedFile!.path)],
        text: '通过南瓜压缩压缩的图片',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('分享失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  // 保存图片到相册
  Future<void> _saveImage() async {
    try {
      final provider = context.read<app_provider.ImageProvider>();
      final successImages = provider.images.where((img) => img.isSuccess).toList();
      
      if (_currentIndex >= successImages.length) return;
      
      final currentImage = successImages[_currentIndex];
      if (currentImage.compressedFile == null) return;
      
      // 使用文件路径保存到相册
      final result = await ImageGallerySaver.saveFile(
        currentImage.compressedFile!.path,
      );
      
      if (mounted) {
        if (result != null && result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已保存到相册'),
              backgroundColor: AppTheme.successColor,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存失败，请检查相册权限'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
