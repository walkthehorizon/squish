import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/image_provider.dart' as app_provider;
import 'screens/main_screen.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';

void main() {
  runApp(const PumpkinImageCompressApp());
}

class PumpkinImageCompressApp extends StatelessWidget {
  const PumpkinImageCompressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => app_provider.ImageProvider(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}
