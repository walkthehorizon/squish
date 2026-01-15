import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as app_provider;
import '../widgets/compress_config_panel.dart';
import '../models/compress_config.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

// 配置页面
class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});
  
  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  late CompressConfig _tempConfig;
  bool _hasChanges = false;
  
  @override
  void initState() {
    super.initState();
    final provider = context.read<app_provider.ImageProvider>();
    _tempConfig = provider.config;
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }
  
  // 构建AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('压缩配置'),
      actions: [
        // 重置按钮
        if (_hasChanges)
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetConfig,
            tooltip: '重置',
          ),
      ],
    );
  }
  
  // 构建主体内容
  Widget _buildBody() {
    return Column(
      children: [
        // 配置面板
        Expanded(
          child: CompressConfigPanel(
            config: _tempConfig,
            onConfigChanged: (newConfig) {
              setState(() {
                _tempConfig = newConfig;
                _hasChanges = true;
              });
            },
          ),
        ),
        
        // 预设配置卡片
        _buildPresetCards(),
      ],
    );
  }
  
  // 构建预设配置卡片
  Widget _buildPresetCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '快速预设',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPresetCard(
                  title: '高质量',
                  subtitle: '质量90% + 等比80%',
                  icon: Icons.high_quality,
                  onTap: () => _applyPreset(
                    CompressConfig(
                      mode: CompressMode.scale,
                      quality: 90,
                      scaleRatio: 0.8,
                    ),
                  ),
                ),
                _buildPresetCard(
                  title: '平衡',
                  subtitle: '质量75% + 等比70%',
                  icon: Icons.balance,
                  onTap: () => _applyPreset(
                    CompressConfig(
                      mode: CompressMode.scale,
                      quality: 75,
                      scaleRatio: 0.7,
                    ),
                  ),
                ),
                _buildPresetCard(
                  title: '高压缩',
                  subtitle: '质量60% + 等比50%',
                  icon: Icons.compress,
                  onTap: () => _applyPreset(
                    CompressConfig(
                      mode: CompressMode.scale,
                      quality: 60,
                      scaleRatio: 0.5,
                    ),
                  ),
                ),
                _buildPresetCard(
                  title: '智能',
                  subtitle: '自动优化',
                  icon: Icons.auto_awesome,
                  onTap: () => _applyPreset(
                    CompressConfig(
                      mode: CompressMode.smart,
                      quality: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 构建预设卡片
  Widget _buildPresetCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppTheme.primaryOrange,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 构建底部操作栏
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 取消按钮
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ),
          const SizedBox(width: 16),
          // 保存按钮
          Expanded(
            child: ElevatedButton(
              onPressed: _hasChanges ? _saveConfig : null,
              child: const Text('保存配置'),
            ),
          ),
        ],
      ),
    );
  }
  
  // 应用预设配置
  void _applyPreset(CompressConfig preset) {
    setState(() {
      _tempConfig = preset;
      _hasChanges = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已应用预设配置'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  
  // 重置配置
  void _resetConfig() {
    final provider = context.read<app_provider.ImageProvider>();
    setState(() {
      _tempConfig = provider.config;
      _hasChanges = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已重置配置'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  
  // 保存配置
  void _saveConfig() {
    final provider = context.read<app_provider.ImageProvider>();
    provider.updateConfig(_tempConfig);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('配置已保存'),
        backgroundColor: AppTheme.successColor,
        duration: Duration(seconds: 1),
      ),
    );
    
    // 延迟返回，让用户看到保存成功的提示
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
  
  // 处理返回事件
  Future<bool> _onWillPop() async {
    if (!_hasChanges) {
      return true;
    }
    
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('放弃更改？'),
        content: const Text('您有未保存的配置更改，确定要放弃吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('继续编辑'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('放弃'),
          ),
        ],
      ),
    );
    
    return shouldPop ?? false;
  }
}
