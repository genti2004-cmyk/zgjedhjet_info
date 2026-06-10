import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static const String disclaimer =
      'Burimi i të dhënave: KQZ. Ky aplikacion nuk është aplikacion zyrtar i KQZ-së.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: const [
          _AppInfoHeader(),
          SizedBox(height: 18),
          _InfoCard(
            icon: Icons.verified_user_rounded,
            title: 'Qëllimi i aplikacionit',
            description:
            'Zgjedhjet Info është një aplikacion informues për paraqitjen e rezultateve dhe informacionit zgjedhor në një vend.',
          ),
          _InfoCard(
            icon: Icons.source_rounded,
            title: 'Burimi i të dhënave',
            description:
            'Të dhënat do të merren nga burime zyrtare të publikuara nga Komisioni Qendror i Zgjedhjeve.',
          ),
          _InfoCard(
            icon: Icons.warning_amber_rounded,
            title: 'Njoftim i rëndësishëm',
            description: disclaimer,
          ),
          _InfoCard(
            icon: Icons.language_rounded,
            title: 'Gjuha',
            description:
            'Versioni i parë i aplikacionit do të jetë në gjuhën shqipe. Më vonë mund të shtohen gjermanishtja dhe anglishtja.',
          ),
        ],
      ),
    );
  }
}

class _AppInfoHeader extends StatelessWidget {
  const _AppInfoHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryBlue,
            AppTheme.darkBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.how_to_vote_rounded,
            color: Colors.white,
            size: 38,
          ),
          SizedBox(height: 14),
          Text(
            'Zgjedhjet Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Rezultatet dhe informacionet zgjedhore në një vend',
            style: TextStyle(
              color: Color(0xFFEAF2FF),
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppTheme.softBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}