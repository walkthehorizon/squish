import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../models/compress_config.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/image_selection_area.dart';

// 无损压缩页面
class LosslessCompressScreen extends StatefulWidget {
  const LosslessCompressScreen({super.key});
  
  @override
  State<LosslessCompressScreen> createState() => _LosslessCompressScreenState();
}

class _LosslessCompressScreenState extends State<LosslessCompressScreen> {
  ImageFormat _outputFormat = ImageFormat.jpg;
  double _quality = 90.0;
  
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
    );
  }
  
  // 构建质量选择区域
  Widget _buildQualitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '压缩质量',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildQualityOption('低', 60, Icons.battery_0_bar),
              _buildQualityOption('中', 75, Icons.battery_3_bar),
              _buildQualityOption('高', 90, Icons.battery_full),
              _buildQualityOption('超高', 95, Icons.battery_charging_full),
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
      mode: CompressMode.smart,
      quality: _quality,
      outputFormat: _outputFormat,
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
