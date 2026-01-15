import 'package:flutter/material.dart';

// 应用主题配置
class AppTheme {
  // 主色调 - 橙色系
  static const Color primaryOrange = Color(0xFFFF5722); // 深橙色
  static const Color secondaryOrange = Color(0xFFFF9800); // 橙色
  static const Color accentOrange = Color(0xFFE64A19); // 强调橙色
  static const Color lightOrange = Color(0xFFFFCCBC); // 浅橙色

  // 背景色
  static const Color backgroundColor = Color(0xFFFAFAFA); // 浅灰背景
  static const Color cardColor = Colors.white; // 卡片白色
  static const Color surfaceColor = Colors.white;

  // 文字颜色
  static const Color textPrimary = Color(0xFF212121); // 主要文字
  static const Color textSecondary = Color(0xFF757575); // 次要文字
  static const Color textHint = Color(0xFFBDBDBD); // 提示文字

  // 状态颜色
  static const Color successColor = Color(0xFF4CAF50); // 成功
  static const Color errorColor = Color(0xFFF44336); // 错误
  static const Color warningColor = Color(0xFFFFC107); // 警告

  // 获取亮色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOrange,
        primary: primaryOrange,
        secondary: secondaryOrange,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),

      // AppBar主题
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // FloatingActionButton主题
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // 底部导航栏主题
      bottomAppBarTheme: const BottomAppBarTheme(
        color: surfaceColor,
        elevation: 8,
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // 文本按钮主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryOrange),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Slider主题
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryOrange,
        inactiveTrackColor: lightOrange,
        thumbColor: primaryOrange,
        overlayColor: primaryOrange.withOpacity(0.2),
        valueIndicatorColor: primaryOrange,
      ),

      // 进度条主题
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryOrange,
        linearTrackColor: lightOrange,
      ),

      // 文字主题
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, color: textHint),
      ),
    );
  }
}
