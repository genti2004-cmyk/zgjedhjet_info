import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../candidates/presentation/candidates_screen.dart';
import '../../info/presentation/info_screen.dart';
import '../../sources/presentation/sources_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Më shumë'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF102A43),
                  Color(0xFF1559A8),
                  Color(0xFF0B2137),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: AppTheme.greenShadow,
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.apps_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Më shumë',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Kandidatët, burimet zyrtare dhe informacionet e aplikacionit.',
                        style: TextStyle(
                          color: Color(0xFFEAF2FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _MoreTile(
            icon: Icons.people_alt_rounded,
            title: 'Kandidatët',
            subtitle:
                'Shiko kandidatët e zgjedhur dhe kërko sipas emrit ose subjektit.',
            onTap: () => _open(context, const CandidatesScreen()),
          ),
          const SizedBox(height: 12),
          _MoreTile(
            icon: Icons.source_rounded,
            title: 'Burimet',
            subtitle:
                'Faqet zyrtare dhe dokumentet e përdorura për verifikimin e të dhënave.',
            onTap: () => _open(context, const SourcesScreen()),
          ),
          const SizedBox(height: 12),
          _MoreTile(
            icon: Icons.info_outline_rounded,
            title: 'Info',
            subtitle:
                'Versioni, statusi i të dhënave, rregullat dhe sqarimi ligjor.',
            onTap: () => _open(context, const InfoScreen()),
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 13, 15),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppTheme.softNavy,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryNavy,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
