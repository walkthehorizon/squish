import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/theme.dart';
import '../models/compress_history_item.dart';
import '../services/storage_service.dart';
import '../utils/works_refresh_notifier.dart';
import '../providers/image_provider.dart' as app_provider;
import 'preview_screen.dart';

// 作品Tab - 压缩历史记录
class WorksTabScreen extends StatefulWidget {
  const WorksTabScreen({super.key});
  
  @override
  State<WorksTabScreen> createState() => WorksTabScreenState();
}

class WorksTabScreenState extends State<WorksTabScreen> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  List<CompressHistoryItem> _historyList = [];
  bool _isLoading = true;
  final WorksRefreshNotifier _refreshNotifier = WorksRefreshNotifier();
  
  @override
  bool get wantKeepAlive => true; // 保持状态
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshNotifier.addListener(_onRefreshNotified);
    _loadHistory();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshNotifier.removeListener(_onRefreshNotified);
    super.dispose();
  }
  
  // 当收到刷新通知时
  void _onRefreshNotified() {
    _loadHistory();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当应用从后台返回前台时刷新数据
    if (state == AppLifecycleState.resumed) {
      _loadHistory();
    }
  }
  
  // 加载历史记录
  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    final history = await StorageService.getCompressHistory();
    
    if (mounted) {
      setState(() {
        _historyList = history;
        _isLoading = false;
      });
    }
  }
  
  // 公开的刷新方法，供外部调用
  void refreshHistory() {
    _loadHistory();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.worksTitle),
        centerTitle: true,
        actions: [
          if (_historyList.isNotEmpty)
            TextButton(
              onPressed: () => _showClearDialog(context),
              child: Text(
                l10n.clearAll,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyList.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _historyList.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryItem(_historyList[index], index);
                    },
                  ),
                ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noHistory,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.historyHint,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
  
  // 构建历史记录项
  Widget _buildHistoryItem(CompressHistoryItem item, int index) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        await StorageService.deleteHistoryItem(item.id);
        setState(() {
          _historyList.removeAt(index);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).deleted),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _previewImage(item),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 缩略图
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(item.compressedFilePath),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // 信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            item.formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.lightOrange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.format,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            item.originalSizeText,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            item.compressedSizeText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 压缩率标签
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryOrange.withOpacity(0.1),
                        AppTheme.primaryOrange.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryOrange.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${item.compressionRatio.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // 预览图片
  void _previewImage(CompressHistoryItem item) {
    // 将历史记录加载到 ImageProvider 中
    final provider = context.read<app_provider.ImageProvider>();
    provider.loadFromHistory(_historyList);
    
    // 跳转到预览页
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(imageId: item.id),
      ),
    ).then((_) {
      // 预览页返回后刷新列表
      _loadHistory();
    });
  }
  
  void _showClearDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmClearHistory),
        content: Text(l10n.confirmClearHistoryContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await StorageService.clearHistory();
              Navigator.pop(context);
              _loadHistory();
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
