import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/kqz_connection_card.dart';

import '../../../core/models/official_source.dart';
import '../../../core/theme/app_theme.dart';
import '../data/official_sources_repository.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sources = const OfficialSourcesRepository().getSources();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Burimet'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          const _PageHeader(),
          const SizedBox(height: 18),
          const KqzConnectionCard(),
          const SizedBox(height: 18),
          ...sources.map(_SourceCard.new),
          const SizedBox(height: 10),
          const _SourceDisclaimerCard(),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.source_rounded,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Lidhjet zyrtare nga ku do të merren dhe verifikohen të dhënat.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final OfficialSource source;

  const _SourceCard(this.source);

  Future<void> _openSource(BuildContext context) async {
    final uri = Uri.parse(source.url);

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lidhja nuk mund të hapet.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _openSource(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppTheme.softBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.open_in_new_rounded,
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      source.type,
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      source.description,
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

class _SourceDisclaimerCard extends StatelessWidget {
  const _SourceDisclaimerCard();

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
            Icons.warning_amber_rounded,
            color: Color(0xFFB54708),
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ky aplikacion përdor burime zyrtare publike për informim, por nuk është aplikacion zyrtar i KQZ-së.',
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