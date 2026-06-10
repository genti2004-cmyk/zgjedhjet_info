import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/election_official_file.dart';
import '../../../core/models/election_source.dart';
import '../../../core/theme/app_theme.dart';
import '../../election_archive/data/election_official_file_catalog.dart';

enum SourceFilter {
  all,
  elections,
  files,
}

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({super.key});

  @override
  State<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  final TextEditingController _searchController = TextEditingController();

  SourceFilter _filter = SourceFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);

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

  List<ElectionSource> _visibleElectionSources() {
    if (_filter == SourceFilter.files) return const <ElectionSource>[];

    final query = _query.trim().toLowerCase();

    return ElectionSource.all.where((source) {
      if (query.isEmpty) return true;

      return source.title.toLowerCase().contains(query) ||
          source.shortTitle.toLowerCase().contains(query) ||
          source.description.toLowerCase().contains(query) ||
          source.dateLabel.toLowerCase().contains(query);
    }).toList();
  }

  List<ElectionOfficialFile> _visibleFiles() {
    if (_filter == SourceFilter.elections) {
      return const <ElectionOfficialFile>[];
    }

    final query = _query.trim().toLowerCase();

    return ElectionOfficialFileCatalog.all.where((file) {
      if (query.isEmpty) return true;

      return file.title.toLowerCase().contains(query) ||
          file.description.toLowerCase().contains(query) ||
          file.fileType.toLowerCase().contains(query) ||
          file.electionId.toLowerCase().contains(query);
    }).toList();
  }

  int _officialElectionCount() {
    return ElectionSource.all.length;
  }

  int _officialFileCount() {
    return ElectionOfficialFileCatalog.all.length;
  }

  int _resultFileCount() {
    return ElectionOfficialFileCatalog.all
        .where((file) => file.isResultData)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final electionSources = _visibleElectionSources();
    final files = _visibleFiles();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Burimet'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          const _PremiumHeader(),
          const SizedBox(height: 12),
          _SummaryCard(
            sourceCount: _officialElectionCount(),
            fileCount: _officialFileCount(),
            resultFileCount: _resultFileCount(),
          ),
          const SizedBox(height: 12),
          const _TrustNotice(),
          const SizedBox(height: 12),
          _SearchAndFilterCard(
            controller: _searchController,
            filter: _filter,
            onSearchChanged: (value) {
              setState(() {
                _query = value;
              });
            },
            onFilterChanged: (value) {
              if (value == null) return;
              setState(() {
                _filter = value;
              });
            },
          ),
          const SizedBox(height: 18),
          if (_filter != SourceFilter.files) ...[
            const _SectionHeader(
              title: 'Faqet zyrtare',
              subtitle: 'Burimet kryesore për çdo zgjedhje.',
            ),
            const SizedBox(height: 10),
            if (electionSources.isEmpty)
              const _EmptyCard(message: 'Nuk u gjet asnjë faqe zyrtare.')
            else
              ...electionSources.map(
                (source) => _ElectionSourceCard(
                  source: source,
                  fileCount:
                      ElectionOfficialFileCatalog.byElectionId(_sourceId(source))
                          .length,
                  onOpen: () => _openUrl(context, source.officialUrl),
                ),
              ),
            const SizedBox(height: 18),
          ],
          if (_filter != SourceFilter.elections) ...[
            const _SectionHeader(
              title: 'Dosjet zyrtare',
              subtitle: 'Dokumentet e regjistruara nga burimet e KQZ.',
            ),
            const SizedBox(height: 10),
            if (files.isEmpty)
              const _EmptyCard(message: 'Nuk u gjet asnjë dosje zyrtare.')
            else
              ...files.map(
                (file) => _OfficialFileCard(
                  file: file,
                  onOpen: () => _openUrl(context, file.url),
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _sourceId(ElectionSource source) {
    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return 'parliamentary-2025';
      case ElectionSourceType.parliamentary2021:
        return 'parliamentary-2021';
      case ElectionSourceType.parliamentary2019:
        return 'parliamentary-2019';
      case ElectionSourceType.parliamentary2017:
        return 'parliamentary-2017';
      case ElectionSourceType.parliamentary2014:
        return 'parliamentary-2014';
      case ElectionSourceType.parliamentary2010:
        return 'parliamentary-2010';
      case ElectionSourceType.local2025:
        return 'local-2025';
      case ElectionSourceType.local2025Round2:
        return 'local-2025-r2';
    }
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
                  Icons.source_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Burimet',
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
            'Faqet dhe dokumentet zyrtare',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Këtu ruhen lidhjet zyrtare dhe dosjet që përdoren për verifikimin e të dhënave në app.',
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
                label: 'KQZ / burime zyrtare',
              ),
              _WhitePill(
                icon: Icons.no_accounts_rounded,
                label: 'Jo app zyrtar i KQZ',
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
            Icons.verified_rounded,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            'Verifikim',
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

class _SummaryCard extends StatelessWidget {
  final int sourceCount;
  final int fileCount;
  final int resultFileCount;

  const _SummaryCard({
    required this.sourceCount,
    required this.fileCount,
    required this.resultFileCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                label: 'Faqe',
                value: '$sourceCount',
                icon: Icons.language_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryItem(
                label: 'Dosje',
                value: '$fileCount',
                icon: Icons.description_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryItem(
                label: 'Rezultate',
                value: '$resultFileCount',
                icon: Icons.bar_chart_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustNotice extends StatelessWidget {
  const _TrustNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFEDC7A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFB54708),
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ky aplikacion përdor burime zyrtare për verifikim, por nuk është aplikacion zyrtar i KQZ-së. Të dhënat shtohen vetëm pas kontrollit të dokumenteve.',
              style: TextStyle(
                color: Color(0xFF7A4B00),
                fontSize: 12.8,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilterCard extends StatelessWidget {
  final TextEditingController controller;
  final SourceFilter filter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<SourceFilter?> onFilterChanged;

  const _SearchAndFilterCard({
    required this.controller,
    required this.filter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Kërko burim, dosje, vit...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          controller.clear();
                          onSearchChanged('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<SourceFilter>(
              value: filter,
              decoration: const InputDecoration(
                labelText: 'Filtri',
              ),
              items: const [
                DropdownMenuItem(
                  value: SourceFilter.all,
                  child: Text('Të gjitha'),
                ),
                DropdownMenuItem(
                  value: SourceFilter.elections,
                  child: Text('Faqet zyrtare'),
                ),
                DropdownMenuItem(
                  value: SourceFilter.files,
                  child: Text('Dosjet zyrtare'),
                ),
              ],
              onChanged: onFilterChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ElectionSourceCard extends StatelessWidget {
  final ElectionSource source;
  final int fileCount;
  final VoidCallback onOpen;

  const _ElectionSourceCard({
    required this.source,
    required this.fileCount,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.language_rounded,
                  color: AppTheme.primaryGreen,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.shortTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      source.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(
                          icon: Icons.calendar_month_rounded,
                          label: source.dateLabel,
                        ),
                        _InfoChip(
                          icon: Icons.description_rounded,
                          label: '$fileCount dosje',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfficialFileCard extends StatelessWidget {
  final ElectionOfficialFile file;
  final VoidCallback onOpen;

  const _OfficialFileCard({
    required this.file,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  file.fileType.toUpperCase() == 'PDF'
                      ? Icons.picture_as_pdf_rounded
                      : Icons.table_chart_rounded,
                  color: AppTheme.primaryGreen,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(
                          icon: Icons.insert_drive_file_rounded,
                          label: file.fileType,
                        ),
                        if (file.isResultData)
                          const _InfoChip(
                            icon: Icons.bar_chart_rounded,
                            label: 'Rezultate',
                          ),
                        if (file.isCandidateData)
                          const _InfoChip(
                            icon: Icons.people_alt_rounded,
                            label: 'Kandidatë',
                          ),
                        if (file.isMunicipalityData)
                          const _InfoChip(
                            icon: Icons.location_city_rounded,
                            label: 'Komuna',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 6, 10, 6),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppTheme.textMuted,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Row(
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: AppTheme.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
