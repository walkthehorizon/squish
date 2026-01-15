import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../models/compress_config.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/image_selection_area.dart';

// 格式转换页面
class FormatConvertScreen extends StatefulWidget {
  const FormatConvertScreen({super.key});
  
  @override
  State<FormatConvertScreen> createState() => _FormatConvertScreenState();
}

class _FormatConvertScreenState extends State<FormatConvertScreen> {
  ImageFormat _outputFormat = ImageFormat.jpg;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('格式转换'),
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
                provider.isProcessing ? '转换中...' : '开始压缩',
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
      quality: 85,
      outputFormat: _outputFormat,
      showPreview: false,
    );
    
    provider.updateConfig(config);
    
    try {
      await provider.startCompression();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('转换完成！'),
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
            content: Text('转换失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
