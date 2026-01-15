import 'package:flutter/material.dart';
import '../utils/theme.dart';

// 帮助手册页面
class HelpManualScreen extends StatelessWidget {
  const HelpManualScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('帮助手册'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHelpCard(
              icon: Icons.verified_user,
              title: '无损压缩',
              description: '不改变图片尺寸,只压缩图片大小,对图片质量基本没有影响',
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.aspect_ratio,
              title: '等比压缩',
              description: '等比例改变图片尺寸,影响图片质量,但是压缩效果较好',
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.crop_free,
              title: '指定尺寸',
              description: '可选择指定尺寸或指定像素压缩,灵活满足您的需求',
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.swap_horiz,
              title: '格式转换',
              description: '转换成您需要的图片格式,转换后也可以继续压缩哦',
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建帮助卡片
  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图标
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // 文字内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
