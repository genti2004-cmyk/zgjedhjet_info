import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../candidates/presentation/candidates_screen.dart';
import '../../election_archive/presentation/election_archive_screen.dart';
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

  void _setTab(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _pages => [
        HomeScreen(onNavigateTab: _setTab),
        const ElectionArchiveScreen(),
        const ResultsScreen(),
        const MunicipalitiesScreen(),
        const CandidatesScreen(),
        const SourcesScreen(),
        const InfoScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: const Border(
              top: BorderSide(color: AppTheme.border),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.055),
                blurRadius: 24,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _setTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Ballina',
              ),
              NavigationDestination(
                icon: Icon(Icons.archive_outlined),
                selectedIcon: Icon(Icons.archive_rounded),
                label: 'Zgjedhjet',
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
        ),
      ),
    );
  }
}
