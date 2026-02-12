import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/theme.dart';

// 帮助手册页面
class HelpManualScreen extends StatelessWidget {
  const HelpManualScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.helpTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHelpCard(
              icon: Icons.verified_user,
              title: l10n.helpLossless,
              description: l10n.helpLosslessDesc,
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.aspect_ratio,
              title: l10n.helpScale,
              description: l10n.helpScaleDesc,
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.crop_free,
              title: l10n.helpResize,
              description: l10n.helpResizeDesc,
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.swap_horiz,
              title: l10n.helpFormat,
              description: l10n.helpFormatDesc,
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
