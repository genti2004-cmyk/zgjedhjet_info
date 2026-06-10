import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static const String appName = 'Zgjedhjet Info';
  static const String version = 'v0.3.7';
  static const String subtitle =
      'Rezultatet dhe informacionet zgjedhore në një vend';
  static const String disclaimer =
      'Ky aplikacion nuk është aplikacion zyrtar i KQZ-së. Të dhënat përdoren vetëm nga burime zyrtare të verifikuara.';

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
          _PremiumHeader(),
          SizedBox(height: 12),
          _VersionCard(),
          SizedBox(height: 12),
          _DataStatusCard(),
          SizedBox(height: 12),
          _RulesCard(),
          SizedBox(height: 12),
          _CoverageCard(),
          SizedBox(height: 12),
          _DisclaimerCard(),
        ],
      ),
    );
  }
}

class _PremiumHeader extends StatelessWidget {
  const _PremiumHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F7A4C),
            Color(0xFF095D3A),
            Color(0xFF063F2B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppTheme.greenShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  InfoScreen.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
              const _HeaderStatusPill(),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            InfoScreen.subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'App për shfaqjen dhe verifikimin e rezultateve zgjedhore të Kosovës me burime të dokumentuara.',
            style: TextStyle(
              color: Color(0xFFEAF7F0),
              fontSize: 13.3,
              fontWeight: FontWeight.w700,
              height: 1.32,
            ),
          ),
          const SizedBox(height: 13),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _WhitePill(
                icon: Icons.verified_rounded,
                label: 'Burime zyrtare',
              ),
              _WhitePill(
                icon: Icons.lock_outline_rounded,
                label: 'Pa të dhëna të shpikura',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStatusPill extends StatelessWidget {
  const _HeaderStatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 6, 9, 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            InfoScreen.version,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhitePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WhitePill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 6, 10, 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.6,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.verified_rounded,
      title: 'Versioni aktual',
      children: [
        _InfoRow(label: 'Version', value: InfoScreen.version),
        _InfoRow(label: 'Status', value: 'Stabil'),
        _InfoRow(label: 'Dizajn', value: 'Apple Green Premium'),
        _InfoRow(label: 'Të dhënat', value: 'Vetëm nga burime zyrtare'),
      ],
    );
  }
}

class _DataStatusCard extends StatelessWidget {
  const _DataStatusCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.fact_check_rounded,
      title: 'Statusi i të dhënave',
      children: [
        _StatusLine(
          label: 'Parlamentare 2025',
          value: 'Aktive',
          done: true,
        ),
        _StatusLine(
          label: 'Parlamentare 2021',
          value: 'Aktive',
          done: true,
        ),
        _StatusLine(
          label: 'Parlamentare 2019',
          value: 'Aktive',
          done: true,
        ),
        _StatusLine(
          label: 'Parlamentare 2014',
          value: 'Aktive',
          done: true,
        ),
        _StatusLine(
          label: 'Parlamentare 2017',
          value: 'Burime të regjistruara',
          done: false,
        ),
        _StatusLine(
          label: 'Parlamentare 2010',
          value: 'Burime të regjistruara',
          done: false,
        ),
      ],
    );
  }
}

class _RulesCard extends StatelessWidget {
  const _RulesCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.rule_rounded,
      title: 'Rregullat e app-it',
      children: [
        _BulletLine(text: 'Nuk shtohen të dhëna të shpikura.'),
        _BulletLine(text: 'Çdo rezultat lidhet me burim zyrtar.'),
        _BulletLine(text: 'Kandidatët shtohen vetëm pas verifikimit të plotë.'),
        _BulletLine(text: 'Komunat shënohen si të paplota derisa të importohen plotësisht.'),
        _BulletLine(text: 'Burimet e bllokuara regjistrohen, por nuk përdoren për numra pa kontroll.'),
      ],
    );
  }
}

class _CoverageCard extends StatelessWidget {
  const _CoverageCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.map_rounded,
      title: 'Mbulimi aktual',
      children: [
        _InfoRow(label: 'Rezultate', value: '2025, 2021, 2019, 2014'),
        _InfoRow(label: 'Kandidatë', value: '2025, 2021, 2019, 2014'),
        _InfoRow(label: 'Burime', value: '2025, 2021, 2019, 2017, 2014, 2010'),
        _InfoRow(label: 'Komuna', value: 'Në përgatitje / pa import të plotë'),
        _InfoRow(label: 'Lokale', value: 'Strukturë e përgatitur'),
      ],
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFEDC7A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFB54708),
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              InfoScreen.disclaimer,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A4B00),
              ),
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
  final List<Widget> children;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryGreen),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 12.7,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final String label;
  final String value;
  final bool done;

  const _StatusLine({
    required this.label,
    required this.value,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        color: done ? AppTheme.softGreen : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: done ? const Color(0xFFABEFC6) : const Color(0xFFFEDC7A),
        ),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
            color: done ? AppTheme.primaryGreen : const Color(0xFFB54708),
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: done ? AppTheme.primaryGreen : const Color(0xFF7A4B00),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;

  const _BulletLine({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppTheme.primaryGreen,
            size: 18,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
