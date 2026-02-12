import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/image_provider.dart' as app_provider;
import '../models/compress_config.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/image_selection_area.dart';
import 'preview_screen.dart';

// 无损压缩页面
class LosslessCompressScreen extends StatefulWidget {
  const LosslessCompressScreen({super.key});
  
  @override
  State<LosslessCompressScreen> createState() => _LosslessCompressScreenState();
}

class _LosslessCompressScreenState extends State<LosslessCompressScreen> {
  ImageFormat? _outputFormat; // null表示保持原格式
  double _quality = 90.0;
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 离开页面时清除所有已选图片
        final provider = Provider.of<app_provider.ImageProvider>(context, listen: false);
        provider.clearAll();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).losslessTitle),
          centerTitle: true,
        actions: [
          Consumer<app_provider.ImageProvider>(
            builder: (context, provider, child) {
              if (!provider.hasImages) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _clearAllImages(context, provider),
                child: Text(
                  AppLocalizations.of(context).clearAll,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            },
          ),
        ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // 图片选择区域
              const ImageSelectionArea(),
              
              const SizedBox(height: 24),
              
              // 压缩质量
              _buildQualitySection(),
              
              const SizedBox(height: 24),
              
              // 输出格式
              _buildFormatSection(),
              
              const SizedBox(height: 32),
              
              // 开始压缩按钮
              _buildCompressButton(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  // 构建质量选择区域
  Widget _buildQualitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).compressQualityLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildQualityOption(AppLocalizations.of(context).qualityLow, 60, Icons.star_border),
              _buildQualityOption(AppLocalizations.of(context).qualityMid, 75, Icons.star_half),
              _buildQualityOption(AppLocalizations.of(context).qualityHigh, 90, Icons.star),
              _buildQualityOption(AppLocalizations.of(context).qualitySuper, 95, Icons.auto_awesome),
            ],
          ),
        ],
      ),
    );
  }
  
  // 构建质量选项
  Widget _buildQualityOption(String label, double quality, IconData icon) {
    final isSelected = _quality == quality;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () {
            setState(() {
              _quality = quality;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.lightOrange : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryOrange : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppTheme.primaryOrange : Colors.grey,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryOrange : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // 构建格式选择区域
  Widget _buildFormatSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).outputFormat,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFormatOption(AppLocalizations.of(context).formatOriginal, null),
              _buildFormatOption('png', ImageFormat.png),
              _buildFormatOption('jpg', ImageFormat.jpg),
              _buildFormatOption('webp', ImageFormat.webp),
            ],
          ),
        ],
      ),
    );
  }
  
  // 构建格式选项
  Widget _buildFormatOption(String label, ImageFormat? format) {
    final isSelected = _outputFormat == format;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () {
            setState(() {
              _outputFormat = format; // null表示保持原格式
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.lightOrange : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryOrange : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryOrange : AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // 构建压缩按钮
  Widget _buildCompressButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Consumer<app_provider.ImageProvider>(
        builder: (context, provider, child) {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: provider.hasImages && !provider.isProcessing
                  ? () => _startCompress(provider)
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                provider.isProcessing ? AppLocalizations.of(context).compressing : AppLocalizations.of(context).startCompressButton,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  // 开始压缩
  Future<void> _startCompress(app_provider.ImageProvider provider) async {
    final config = CompressConfig(
      mode: CompressMode.smart,
      quality: _quality,
      outputFormat: _outputFormat,
      showPreview: false,
    );
    
    provider.updateConfig(config);
    
    try {
      await provider.startCompression();
      
      if (mounted) {
        // 查找第一个成功压缩的图片
        final successImages = provider.images.where((img) => img.isSuccess).toList();
        if (successImages.isNotEmpty) {
          // 跳转到预览页
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewScreen(imageId: successImages.first.id),
            ),
          );
        } else {
          // 检查是否有因为体积变大被跳过的
          final hasSkipped = provider.images.any((img) => img.errorMessage == '压缩后体积变大，已跳过');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(hasSkipped ? AppLocalizations.of(context).skippedNoSmaller : AppLocalizations.of(context).compressFailedNoPreview),
              backgroundColor: AppTheme.warningColor,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).compressFailed(e.toString())),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  // 清除全部图片
  void _clearAllImages(
    BuildContext context,
    app_provider.ImageProvider provider,
  ) {
    if (provider.images.isEmpty) return;
    
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmClearAll),
        content: Text(l10n.confirmClearAllContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
