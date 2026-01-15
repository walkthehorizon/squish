import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'help_manual_screen.dart';
import 'contact_service_screen.dart';

// 我的Tab
class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 头像和标题
            _buildHeader(),
            
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
  
  // 构建头部
  Widget _buildHeader() {
    return Column(
      children: [
        // 头像
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
          child: const Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '照片压缩',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  // 构建VIP卡片
  Widget _buildVipCard(BuildContext context) {
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '普通用户',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '免费使用所有功能',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // 按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '欢迎您',
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.help_outline,
            iconColor: Colors.blue,
            title: '帮助手册',
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
            title: '联系客服',
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
            title: '用户协议',
            onTap: () => _showComingSoon(context),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            iconColor: Colors.red,
            title: '隐私政策',
            onTap: () => _showComingSoon(context),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.person_remove_outlined,
            iconColor: Colors.grey,
            title: '账户注销',
            onTap: () => _showLogoutDialog(context),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.info_outline,
            iconColor: Colors.amber,
            title: '当前版本',
            trailing: const Text(
              'v1.0.0',
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
            showArrow: false,
            onTap: () => _showVersionToast(context),
          ),
        ],
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
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(title),
      trailing: trailing ??
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
  
  // 显示即将推出提示
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('功能即将推出'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  
  // 显示注销对话框
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('账户注销'),
        content: const Text('确定要注销账户吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('注销成功'),
                  backgroundColor: AppTheme.successColor,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  // 显示版本Toast
  void _showVersionToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已是最新版本了'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }
}
