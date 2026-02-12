import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../l10n/app_localizations.dart';
import '../providers/image_provider.dart' as app_provider;
import '../widgets/image_compare_view.dart';
import '../utils/theme.dart';

// 预览对比页面
class PreviewScreen extends StatefulWidget {
  final String imageId;

  const PreviewScreen({super.key, required this.imageId});

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
    _currentIndex = provider.images.indexWhere(
      (img) => img.id == widget.imageId,
    );
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

  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Consumer<app_provider.ImageProvider>(
        builder: (context, provider, child) {
          if (provider.images.isEmpty) {
            return Text(l10n.imagePreview);
          }
          return Text('${_currentIndex + 1} / ${provider.images.length}');
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareImage,
          tooltip: l10n.share,
        ),
        IconButton(
          icon: const Icon(Icons.save_alt),
          onPressed: _saveImage,
          tooltip: l10n.save,
        ),
      ],
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context);
    return Consumer<app_provider.ImageProvider>(
      builder: (context, provider, child) {
        if (provider.images.isEmpty) {
          return Center(
            child: Text(l10n.noImage, style: const TextStyle(color: Colors.white)),
          );
        }
        final successImages = provider.images
            .where((img) => img.isSuccess)
            .toList();
        if (successImages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white70, size: 64),
                const SizedBox(height: 16),
                Text(l10n.noPreviewImages, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          );
        }

        return PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(), // 添加弹性滚动效果
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

        final successImages = provider.images
            .where((img) => img.isSuccess)
            .toList();
        if (successImages.isEmpty || _currentIndex >= successImages.length) {
          return const SizedBox.shrink();
        }

        final currentImage = successImages[_currentIndex];

        return Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            border: Border(top: BorderSide(color: Colors.grey[800]!)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 上一张按钮
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),

              // 文件名显示
              Expanded(
                child: Text(
                  currentImage.truncatedName,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 下一张按钮
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
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
      final successImages = provider.images
          .where((img) => img.isSuccess)
          .toList();

      if (_currentIndex >= successImages.length) return;

      final currentImage = successImages[_currentIndex];
      if (currentImage.compressedFile == null) return;

      await Share.shareXFiles([
        XFile(currentImage.compressedFile!.path),
      ], text: AppLocalizations.of(context).shareSubjectText);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).shareFailed(e.toString())),
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
      final successImages = provider.images
          .where((img) => img.isSuccess)
          .toList();

      if (_currentIndex >= successImages.length) return;

      final currentImage = successImages[_currentIndex];
      if (currentImage.compressedFile == null) return;

      // 使用文件路径保存到相册
      final result = await ImageGallerySaver.saveFile(
        currentImage.compressedFile!.path,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        if (result != null && result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.savedToGallery),
              backgroundColor: AppTheme.successColor,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.saveFailedCheckPermission),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).saveFailed(e.toString())),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
