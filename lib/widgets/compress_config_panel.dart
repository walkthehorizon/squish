import 'package:flutter/material.dart';
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
          // 压缩模式选择
          _buildSectionTitle('压缩模式'),
          _buildCompressMode(),
          
          const SizedBox(height: 24),
          
          // 质量调节
          _buildSectionTitle('压缩质量'),
          _buildQualitySlider(),
          
          const SizedBox(height: 24),
          
          // 根据模式显示不同的配置
          if (_config.mode == CompressMode.scale) ...[
            _buildSectionTitle('缩放比例'),
            _buildScaleSlider(),
          ] else if (_config.mode == CompressMode.resize) ...[
            _buildSectionTitle('目标尺寸'),
            _buildSizeInputs(),
            const SizedBox(height: 16),
            _buildSectionTitle('填充模式'),
            _buildFitMode(),
          ],
          
          const SizedBox(height: 24),
          
          // 输出格式
          _buildSectionTitle('输出格式'),
          _buildFormatSelector(),
          
          const SizedBox(height: 24),
          
          // 预览开关
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
    return SegmentedButton<CompressMode>(
      segments: const [
        ButtonSegment(
          value: CompressMode.scale,
          label: Text('等比压缩'),
          icon: Icon(Icons.aspect_ratio),
        ),
        ButtonSegment(
          value: CompressMode.resize,
          label: Text('指定尺寸'),
          icon: Icon(Icons.crop),
        ),
        ButtonSegment(
          value: CompressMode.smart,
          label: Text('智能压缩'),
          icon: Icon(Icons.auto_awesome),
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
            const Text('质量等级'),
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
            Text('低质量', style: Theme.of(context).textTheme.bodySmall),
            Text('高质量', style: Theme.of(context).textTheme.bodySmall),
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
            const Text('缩放比例'),
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
            decoration: const InputDecoration(
              labelText: '宽度',
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
            decoration: const InputDecoration(
              labelText: '高度',
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
    switch (mode) {
      case FitMode.contain:
        return '包含（留白）';
      case FitMode.cover:
        return '覆盖（裁剪）';
      case FitMode.fill:
        return '拉伸填充';
    }
  }
  
  // 构建格式选择器
  Widget _buildFormatSelector() {
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
      selected: {_config.outputFormat},
      onSelectionChanged: (Set<ImageFormat> newSelection) {
        _updateConfig(_config.copyWith(outputFormat: newSelection.first));
      },
      showSelectedIcon: true,
    );
  }
  
  // 构建预览开关
  Widget _buildPreviewSwitch() {
    return SwitchListTile(
      title: const Text('显示对比预览'),
      subtitle: const Text('压缩完成后显示原图与压缩图对比'),
      value: _config.showPreview,
      onChanged: (value) {
        _updateConfig(_config.copyWith(showPreview: value));
      },
      activeColor: AppTheme.primaryOrange,
      contentPadding: EdgeInsets.zero,
    );
  }
}
