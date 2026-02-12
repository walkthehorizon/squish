import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/compress_config.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

// 压缩配置面板组件
class CompressConfigPanel extends StatefulWidget {
  final CompressConfig config;
  final Function(CompressConfig) onConfigChanged;
  
  const CompressConfigPanel({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });
  
  @override
  State<CompressConfigPanel> createState() => _CompressConfigPanelState();
}

class _CompressConfigPanelState extends State<CompressConfigPanel> {
  late CompressConfig _config;
  
  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }
  
  void _updateConfig(CompressConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    widget.onConfigChanged(newConfig);
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppLocalizations.of(context).compressMode),
          _buildCompressMode(),
          const SizedBox(height: 24),
          _buildSectionTitle(AppLocalizations.of(context).compressQuality),
          _buildQualitySlider(),
          const SizedBox(height: 24),
          if (_config.mode == CompressMode.scale) ...[
            _buildSectionTitle(AppLocalizations.of(context).scaleRatio),
            _buildScaleSlider(),
          ] else if (_config.mode == CompressMode.resize) ...[
            _buildSectionTitle(AppLocalizations.of(context).targetSize),
            _buildSizeInputs(),
            const SizedBox(height: 16),
            _buildSectionTitle(AppLocalizations.of(context).fillMode),
            _buildFitMode(),
          ],
          const SizedBox(height: 24),
          _buildSectionTitle(AppLocalizations.of(context).outputFormat),
          _buildFormatSelector(),
          const SizedBox(height: 24),
          _buildPreviewSwitch(),
        ],
      ),
    );
  }
  
  // 构建章节标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryOrange,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
  
  // 构建压缩模式选择
  Widget _buildCompressMode() {
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<CompressMode>(
      segments: [
        ButtonSegment(
          value: CompressMode.scale,
          label: Text(l10n.scaleTitle),
          icon: const Icon(Icons.aspect_ratio),
        ),
        ButtonSegment(
          value: CompressMode.resize,
          label: Text(l10n.resizeTitle),
          icon: const Icon(Icons.crop),
        ),
        ButtonSegment(
          value: CompressMode.smart,
          label: Text(l10n.presetSmart),
          icon: const Icon(Icons.auto_awesome),
        ),
      ],
      selected: {_config.mode},
      onSelectionChanged: (Set<CompressMode> newSelection) {
        _updateConfig(_config.copyWith(mode: newSelection.first));
      },
      showSelectedIcon: true,
    );
  }
  
  // 构建质量滑块
  Widget _buildQualitySlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context).qualityLevel),
            Text(
              '${_config.quality.toInt()}%',
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _config.quality,
          min: 10,
          max: 100,
          divisions: 90,
          label: '${_config.quality.toInt()}%',
          onChanged: (value) {
            _updateConfig(_config.copyWith(quality: value));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context).lowQuality, style: Theme.of(context).textTheme.bodySmall),
            Text(AppLocalizations.of(context).highQuality, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
  
  // 构建缩放比例滑块
  Widget _buildScaleSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context).scaleRatio),
            Text(
              '${(_config.scaleRatio * 100).toInt()}%',
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _config.scaleRatio,
          min: 0.1,
          max: 1.0,
          divisions: 90,
          label: '${(_config.scaleRatio * 100).toInt()}%',
          onChanged: (value) {
            _updateConfig(_config.copyWith(scaleRatio: value));
          },
        ),
      ],
    );
  }
  
  // 构建尺寸输入框
  Widget _buildSizeInputs() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).width,
              suffixText: 'px',
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: _config.targetWidth.toString()),
            onChanged: (value) {
              final width = int.tryParse(value);
              if (width != null && width > 0) {
                _updateConfig(_config.copyWith(targetWidth: width));
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.close, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).height,
              suffixText: 'px',
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: _config.targetHeight.toString()),
            onChanged: (value) {
              final height = int.tryParse(value);
              if (height != null && height > 0) {
                _updateConfig(_config.copyWith(targetHeight: height));
              }
            },
          ),
        ),
      ],
    );
  }
  
  // 构建填充模式选择
  Widget _buildFitMode() {
    return Wrap(
      spacing: 8,
      children: FitMode.values.map((mode) {
        final isSelected = _config.fitMode == mode;
        return ChoiceChip(
          label: Text(_getFitModeName(mode)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              _updateConfig(_config.copyWith(fitMode: mode));
            }
          },
          selectedColor: AppTheme.lightOrange,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryOrange : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
  
  String _getFitModeName(FitMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case FitMode.contain:
        return l10n.fitContain;
      case FitMode.cover:
        return l10n.fitCover;
      case FitMode.fill:
        return l10n.fitFill;
    }
  }
  
  // 构建格式选择器
  Widget _buildFormatSelector() {
    // 如果outputFormat为null，使用jpg作为默认显示
    final displayFormat = _config.outputFormat ?? ImageFormat.jpg;
    return SegmentedButton<ImageFormat>(
      segments: const [
        ButtonSegment(
          value: ImageFormat.jpg,
          label: Text('JPG'),
        ),
        ButtonSegment(
          value: ImageFormat.png,
          label: Text('PNG'),
        ),
        ButtonSegment(
          value: ImageFormat.webp,
          label: Text('WebP'),
        ),
      ],
      selected: {displayFormat},
      onSelectionChanged: (Set<ImageFormat> newSelection) {
        _updateConfig(_config.copyWith(outputFormat: newSelection.first));
      },
      showSelectedIcon: true,
    );
  }
  
  Widget _buildPreviewSwitch() {
    final l10n = AppLocalizations.of(context);
    return SwitchListTile(
      title: Text(l10n.showPreview),
      subtitle: Text(l10n.showPreviewSub),
      value: _config.showPreview,
      onChanged: (value) {
        _updateConfig(_config.copyWith(showPreview: value));
      },
      activeColor: AppTheme.primaryOrange,
      contentPadding: EdgeInsets.zero,
    );
  }
}
