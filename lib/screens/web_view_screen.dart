import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/theme.dart';

/// 用于展示用户协议、隐私政策，支持本地 asset 或远程 URL
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  /// 本地资源路径（如 assets/html/xxx.html）或完整远程 URL（https://...）
  final String assetPath;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (e) {
            if (mounted) setState(() {
              _loading = false;
              _error = e.description;
            });
          },
        ),
      );
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    try {
      final path = widget.assetPath;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        if (!mounted) return;
        await _controller.loadRequest(Uri.parse(path));
      } else {
        final html = await rootBundle.loadString(path);
        if (!mounted) return;
        await _controller.loadHtmlString(
          html,
          baseUrl: null,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loading)
                  const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryOrange),
                  ),
              ],
            ),
    );
  }
}
