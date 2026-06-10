import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/main/presentation/main_navigation_screen.dart';

class ZgjedhjetInfoApp extends StatelessWidget {
  const ZgjedhjetInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zgjedhjet Info',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}