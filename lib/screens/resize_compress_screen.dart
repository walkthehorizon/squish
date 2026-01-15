import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../models/compress_config.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/image_selection_area.dart';

// 指定尺寸页面
class ResizeCompressScreen extends StatefulWidget {
  const ResizeCompressScreen({super.key});
  
  @override
  State<ResizeCompressScreen> createState() => _ResizeCompressScreenState();
}

class _ResizeCompressScreenState extends State<ResizeCompressScreen> {
  ImageFormat _outputFormat = ImageFormat.jpg;
  int _targetWidth = 1920;
  int _targetHeight = 1080;
  bool _useCustomSize = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('照片压缩'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // 图片选择区域
            const ImageSelectionArea(),
            
            const SizedBox(height: 24),
            
            // 自定义像素
            _buildCustomSizeSection(),
            
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
    );
  }
  
  // 构建自定义尺寸区域
  Widget _buildCustomSizeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '自定义像素',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _useCustomSize = false;
                            _targetWidth = 1920;
                            _targetHeight = 1080;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_useCustomSize ? AppTheme.lightOrange : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !_useCustomSize ? AppTheme.primaryOrange : Colors.grey[300]!,
                              width: !_useCustomSize ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            '指定\n宽度',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: !_useCustomSize ? FontWeight.bold : FontWeight.normal,
                              color: !_useCustomSize ? AppTheme.primaryOrange : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _useCustomSize = false;
                            _targetWidth = 1920;
                            _targetHeight = 1080;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '像素',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _useCustomSize = false;
                            _targetWidth = 1920;
                            _targetHeight = 1080;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '指定\n高度',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _useCustomSize = false;
                            _targetWidth = 1920;
                            _targetHeight = 1080;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '像素',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
          const Text(
            '输出格式',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFormatOption('原格式', null),
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
              _outputFormat = format ?? ImageFormat.jpg;
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
                provider.isProcessing ? '压缩中...' : '开始压缩',
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
      mode: CompressMode.resize,
      targetWidth: _targetWidth,
      targetHeight: _targetHeight,
      quality: 85,
      outputFormat: _outputFormat,
      fitMode: FitMode.contain,
      showPreview: false,
    );
    
    provider.updateConfig(config);
    
    try {
      await provider.startCompression();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('压缩完成！'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // 跳转到作品页
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('压缩失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
