import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';

// 联系客服页面
class ContactServiceScreen extends StatelessWidget {
  const ContactServiceScreen({super.key});
  
  // 联系方式
  static const String email = '1308311472@qq.com';
  static const String qq = '1308311472';
  static const String wechat = '123456';
  static const String workHours = '10:00 - 18:00';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('联系我们'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContactItem(
              icon: Icons.email,
              title: '邮件客服',
              subtitle: email,
              onTap: () => _openEmail(context),
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.chat_bubble_outline,
              title: '微信客服',
              subtitle: wechat,
              onTap: () => _copyToClipboard(context, wechat, '微信'),
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.phone,
              title: 'QQ客服',
              subtitle: qq,
              onTap: () => _copyToClipboard(context, qq, 'QQ'),
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.access_time,
              title: '工作时间',
              subtitle: workHours,
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建联系项
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.amber[700],
                  size: 24,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textHint,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 打开邮箱
  Future<void> _openEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // 如果无法打开邮箱，则复制到剪贴板
        _copyToClipboard(context, email, '邮箱');
      }
    } catch (e) {
      _copyToClipboard(context, email, '邮箱');
    }
  }
  
  // 复制到剪贴板
  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已复制$label到剪贴板'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
