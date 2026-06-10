import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../candidates/presentation/candidates_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../info/presentation/info_screen.dart';
import '../../municipalities/presentation/municipalities_screen.dart';
import '../../results/presentation/results_screen.dart';
import '../../sources/presentation/sources_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    if (index < 0 || index > 5) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onNavigateTab: _selectTab),
      const ResultsScreen(),
      const MunicipalitiesScreen(),
      const CandidatesScreen(),
      const SourcesScreen(),
      const InfoScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppTheme.softBlue,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Ballina',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Rezultatet',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_city_outlined),
            selectedIcon: Icon(Icons.location_city_rounded),
            label: 'Komunat',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: 'Kandidatët',
          ),
          NavigationDestination(
            icon: Icon(Icons.source_outlined),
            selectedIcon: Icon(Icons.source_rounded),
            label: 'Burimet',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline_rounded),
            selectedIcon: Icon(Icons.info_rounded),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}