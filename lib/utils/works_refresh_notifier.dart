import 'package:flutter/material.dart';

// 全局的作品页刷新通知器
class WorksRefreshNotifier extends ChangeNotifier {
  static final WorksRefreshNotifier _instance = WorksRefreshNotifier._internal();
  
  factory WorksRefreshNotifier() {
    return _instance;
  }
  
  WorksRefreshNotifier._internal();
  
  // 通知刷新
  void notifyRefresh() {
    notifyListeners();
  }
}
