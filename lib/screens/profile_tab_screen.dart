import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../utils/theme.dart';
import 'help_manual_screen.dart';
import 'contact_service_screen.dart';
import 'web_view_screen.dart';

// 我的Tab
class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text(l10n.profileTitle), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            _buildHeader(context),

            const SizedBox(height: 20),

            // VIP卡片
            _buildVipCard(context),

            const SizedBox(height: 20),

            // 功能列表
            _buildFunctionList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFCCBC), Color(0xFFFF8A65)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryOrange.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context).photoCompress,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // 构建VIP卡片
  Widget _buildVipCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE5D9), Color(0xFFFFCCBC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // VIP图标
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 32,
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(width: 16),
          // 文字
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.normalUser,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.freeAllFeatures,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.welcome,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建功能列表
  Widget _buildFunctionList(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.language,
            iconColor: Colors.teal,
            title: l10n.language,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.watch<LocaleProvider>().locale.languageCode == 'zh'
                      ? l10n.languageChinese
                      : l10n.languageEnglish,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppTheme.textHint),
              ],
            ),
            showArrow: false,
            onTap: () => _showLanguageDialog(context, l10n),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.help_outline,
            iconColor: Colors.blue,
            title: l10n.helpManual,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpManualScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.support_agent,
            iconColor: Colors.purple,
            title: l10n.contactUs,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactServiceScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.description_outlined,
            iconColor: Colors.orange,
            title: l10n.userAgreement,
            onTap: () {
              final locale = context.read<LocaleProvider>().locale;
              final path = locale.languageCode == 'zh'
                  ? 'https://walkthehorizon.github.io/squish/static/user-agreement.html'
                  : 'https://walkthehorizon.github.io/squish/static/user-agreement-en.html';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WebViewScreen(title: l10n.userAgreement, assetPath: path),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            iconColor: Colors.red,
            title: l10n.privacyPolicy,
            onTap: () {
              final locale = context.read<LocaleProvider>().locale;
              final path = locale.languageCode == 'zh'
                  ? 'https://walkthehorizon.github.io/squish/static/privacy-policy.html'
                  : 'https://walkthehorizon.github.io/squish/static/privacy-policy-en.html';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WebViewScreen(title: l10n.privacyPolicy, assetPath: path),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.person_remove_outlined,
            iconColor: Colors.grey,
            title: l10n.accountLogout,
            onTap: () => _showLogoutDialog(context, l10n),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.info_outline,
            iconColor: Colors.amber,
            title: l10n.currentVersion,
            trailing: const Text(
              'v1.0.0',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            showArrow: false,
            onTap: () => _showVersionToast(context, l10n.alreadyLatest),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    final localeProvider = context.read<LocaleProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.languageEnglish),
              onTap: () {
                localeProvider.setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(l10n.languageChinese),
              onTap: () {
                localeProvider.setLocale(const Locale('zh'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 构建菜单项
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title),
      trailing:
          trailing ??
          (showArrow
              ? const Icon(Icons.chevron_right, color: AppTheme.textHint)
              : null),
      onTap: onTap,
    );
  }

  // 构建分隔线
  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 60,
      endIndent: 16,
      color: Colors.grey[200],
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutConfirm),
        content: Text(l10n.logoutConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.logoutSuccess),
                  backgroundColor: AppTheme.successColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showVersionToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }
}
