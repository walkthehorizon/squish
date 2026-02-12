import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/theme.dart';
import 'lossless_compress_screen.dart';
import 'scale_compress_screen.dart';
import 'resize_compress_screen.dart';
import 'format_convert_screen.dart';

// 首页Tab
class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.imageProcess),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildFunctionCard(
              context,
              icon: Icons.high_quality,
              title: l10n.losslessCompress,
              subtitle: l10n.losslessSubtitle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE5D9), Color(0xFFFFCCBC)],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LosslessCompressScreen(),
                  ),
                );
              },
            ),
            _buildFunctionCard(
              context,
              icon: Icons.aspect_ratio,
              title: l10n.scaleCompress,
              subtitle: l10n.scaleSubtitle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScaleCompressScreen(),
                  ),
                );
              },
            ),
            _buildFunctionCard(
              context,
              icon: Icons.crop,
              title: l10n.resizeCompress,
              subtitle: l10n.resizeSubtitle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResizeCompressScreen(),
                  ),
                );
              },
            ),
            _buildFunctionCard(
              context,
              icon: Icons.transform,
              title: l10n.formatConvert,
              subtitle: l10n.formatSubtitle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE5CC), Color(0xFFFFD4A3)],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormatConvertScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建功能卡片
  Widget _buildFunctionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppTheme.primaryOrange,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
