import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/image_provider.dart' as app_provider;
import '../models/compress_config.dart';
import '../models/image_item.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../services/image_picker_service.dart';
import '../services/image_compress_service.dart' as compress_service;
import 'preview_screen.dart';

// 指定尺寸页面
class ResizeCompressScreen extends StatefulWidget {
  const ResizeCompressScreen({super.key});
  
  @override
  State<ResizeCompressScreen> createState() => _ResizeCompressScreenState();
}

class _ResizeCompressScreenState extends State<ResizeCompressScreen> {
  ImageFormat? _outputFormat; // null表示保持原格式
  int? _targetWidth;
  int? _targetHeight;
  int? _originalWidth;
  int? _originalHeight;
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // 选择单张图片
  Future<void> _pickSingleImage(app_provider.ImageProvider provider) async {
    final pickerService = ImagePickerService();
    try {
      final File? imageFile = await pickerService.pickSingleImage();
      if (imageFile != null) {
        // 指定尺寸只取第一张
        provider.clearAll();
        await provider.addFiles([imageFile]);
        
        // 获取图片尺寸
        final dimensions = await compress_service.ImageCompressService.getImagePixelDimensions(imageFile);
        if (dimensions != null) {
          setState(() {
            _originalWidth = dimensions['width'];
            _originalHeight = dimensions['height'];
            // 默认填充原尺寸
            _targetWidth = _originalWidth;
            _targetHeight = _originalHeight;
            _widthController.text = _targetWidth.toString();
            _heightController.text = _targetHeight.toString();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).pickImagesFailed(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<app_provider.ImageProvider>(context);
    final hasImage = provider.hasImages;
    final selectedImage = hasImage ? provider.images.first : null;

    return WillPopScope(
      onWillPop: () async {
        provider.clearAll();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).resizeTitle),
          centerTitle: true,
          actions: [
            if (hasImage)
              TextButton(
                onPressed: () {
                  provider.clearAll();
                  setState(() {
                    _originalWidth = null;
                    _originalHeight = null;
                    _widthController.clear();
                    _heightController.clear();
                  });
                },
                child: Text(
                  AppLocalizations.of(context).clearAll,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // 图片选择/显示区域
              _buildImageArea(provider, selectedImage),
              
              const SizedBox(height: 24),
              
              // 自定义像素区域
              _buildPixelSection(),
              
              const SizedBox(height: 24),
              
              // 输出格式
              _buildFormatSection(),
              
              const SizedBox(height: 32),
              
              // 开始压缩按钮
              _buildCompressButton(provider),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // 构建图片显示区域
  Widget _buildImageArea(app_provider.ImageProvider provider, ImageItem? image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: image == null
          ? InkWell(
              onTap: () => _pickSingleImage(provider),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Icon(
                      Icons.image_outlined,
                      size: 120,
                      color: AppTheme.primaryOrange.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryOrange.withOpacity(0.6), AppTheme.primaryOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context).pickImages,
                    style: const TextStyle(color: AppTheme.primaryOrange, fontSize: 16),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Image.file(
                      File(image.originalFile.path),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: () => _pickSingleImage(provider),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB380), Color(0xFFFF7043)],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // 构建像素输入区域
  Widget _buildPixelSection() {
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
                AppLocalizations.of(context).customPixels,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (_originalWidth != null) ...[
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).originalSize('$_originalWidth', '$_originalHeight'),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInputBox(
                  AppLocalizations.of(context).targetWidth,
                  _widthController,
                  _originalWidth != null ? AppLocalizations.of(context).rangeWidth('$_originalWidth') : '',
                  (val) {
                    final intValue = int.tryParse(val);
                    if (intValue != null && _originalWidth != null) {
                      if (intValue > _originalWidth!) {
                        _widthController.text = _originalWidth.toString();
                        _targetWidth = _originalWidth;
                      } else {
                        _targetWidth = intValue;
                      }
                    } else {
                      _targetWidth = intValue;
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputBox(
                  AppLocalizations.of(context).targetHeight,
                  _heightController,
                  _originalHeight != null ? AppLocalizations.of(context).rangeHeight('$_originalHeight') : '',
                  (val) {
                    final intValue = int.tryParse(val);
                    if (intValue != null && _originalHeight != null) {
                      if (intValue > _originalHeight!) {
                        _heightController.text = _originalHeight.toString();
                        _targetHeight = _originalHeight;
                      } else {
                        _targetHeight = intValue;
                      }
                    } else {
                      _targetHeight = intValue;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox(String label, TextEditingController controller, String hint, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(AppLocalizations.of(context).pixels, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ],
          ),
        ],
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              _outputFormat = format;
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
  Widget _buildCompressButton(app_provider.ImageProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: provider.hasImages && !provider.isProcessing
              ? () => _startCompress(provider)
              : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return Colors.grey[300];
              return null; // 使用主题色
            }),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: provider.hasImages && !provider.isProcessing
                  ? const LinearGradient(colors: [Color(0xFFFFB380), Color(0xFFFF7043)])
                  : null,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                provider.isProcessing ? AppLocalizations.of(context).processing : AppLocalizations.of(context).startCompressButton,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 开始压缩
  Future<void> _startCompress(app_provider.ImageProvider provider) async {
    if (_targetWidth == null || _targetHeight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).inputTargetSize)),
      );
      return;
    }

    final config = CompressConfig(
      mode: CompressMode.resize,
      quality: 90,
      targetWidth: _targetWidth!,
      targetHeight: _targetHeight!,
      outputFormat: _outputFormat,
      fitMode: FitMode.fill,
    );
    
    provider.updateConfig(config);
    
    try {
      await provider.startCompression();
      
      if (mounted) {
        final successImages = provider.images.where((img) => img.isSuccess).toList();
        if (successImages.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewScreen(imageId: successImages.first.id),
            ),
          );
        } else {
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
}
