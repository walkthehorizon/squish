import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
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
  
  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context);
    return AppBar(
      title: Text(l10n.compressConfigTitle),
      actions: [
        if (_hasChanges)
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetConfig,
            tooltip: l10n.reset,
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
  
  Widget _buildPresetCards() {
    final l10n = AppLocalizations.of(context);
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
            l10n.quickPresets,
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
                  context,
                  title: l10n.presetHigh,
                  subtitle: l10n.presetHighSub,
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
                  context,
                  title: l10n.presetBalance,
                  subtitle: l10n.presetBalanceSub,
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
                  context,
                  title: l10n.presetStrong,
                  subtitle: l10n.presetStrongSub,
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
                  context,
                  title: l10n.presetSmart,
                  subtitle: l10n.presetSmartSub,
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
  
  Widget _buildPresetCard(
    BuildContext context, {
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
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _hasChanges ? _saveConfig : null,
              child: Text(AppLocalizations.of(context).saveConfig),
            ),
          ),
        ],
      ),
    );
  }
  
  void _applyPreset(CompressConfig preset) {
    setState(() {
      _tempConfig = preset;
      _hasChanges = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).presetApplied),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _resetConfig() {
    final provider = context.read<app_provider.ImageProvider>();
    setState(() {
      _tempConfig = provider.config;
      _hasChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).configReset),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _saveConfig() {
    final provider = context.read<app_provider.ImageProvider>();
    provider.updateConfig(_tempConfig);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).configSaved),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 1),
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
    
    final l10n = AppLocalizations.of(context);
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.discardChanges),
        content: Text(l10n.discardChangesContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.continueEdit),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );
    
    return shouldPop ?? false;
  }
}
