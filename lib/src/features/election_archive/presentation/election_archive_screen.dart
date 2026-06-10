import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/election_archive_item.dart';
import '../../../core/models/election_official_file.dart';
import '../../../core/theme/app_theme.dart';
import '../data/election_archive_catalog.dart';
import '../data/election_official_file_catalog.dart';

enum ElectionArchiveFilter {
  all,
  parliamentary,
  local,
}

class ElectionArchiveScreen extends StatefulWidget {
  const ElectionArchiveScreen({super.key});

  @override
  State<ElectionArchiveScreen> createState() => _ElectionArchiveScreenState();
}

class _ElectionArchiveScreenState extends State<ElectionArchiveScreen> {
  final TextEditingController _searchController = TextEditingController();

  ElectionArchiveFilter _filter = ElectionArchiveFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ElectionArchiveItem> _visibleItems() {
    final query = _query.trim().toLowerCase();

    return ElectionArchiveCatalog.items.where((item) {
      final matchesFilter = switch (_filter) {
        ElectionArchiveFilter.all => true,
        ElectionArchiveFilter.parliamentary => item.type == 'Parlamentare',
        ElectionArchiveFilter.local => item.type.startsWith('Lokale'),
      };

      if (!matchesFilter) return false;

      if (query.isEmpty) return true;

      return item.title.toLowerCase().contains(query) ||
          item.shortTitle.toLowerCase().contains(query) ||
          item.type.toLowerCase().contains(query) ||
          item.dateLabel.toLowerCase().contains(query);
    }).toList();
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

  int _officialFileCount() {
    return ElectionOfficialFileCatalog.all.length;
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _visibleItems();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Zgjedhjet'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          const _PageHeader(),
          const SizedBox(height: 12),
          const _ArchiveNotice(),
          const SizedBox(height: 12),
          _SummaryCard(
            total: ElectionArchiveCatalog.items.length,
            officialInApp: ElectionArchiveCatalog.items
                .where((item) => item.hasOfficialResultsInApp)
                .length,
            officialFiles: _officialFileCount(),
          ),
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
          if (visibleItems.isEmpty)
            const _EmptyArchiveCard()
          else
            ...visibleItems.map(
                  (item) {
                final files = ElectionOfficialFileCatalog.byElectionId(item.id);

                return _ArchiveCard(
                  item: item,
                  officialFiles: files,
                  onOpenSource: () => _openUrl(context, item.sourceUrl),
                  onOpenFile: (file) => _openUrl(context, file.url),
                );
              },
            ),
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
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryGreen,
            AppTheme.deepGreen,
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
            Icons.archive_rounded,
            color: Colors.white,
            size: 38,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Arkivi i zgjedhjeve nga 2008 deri sot.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveNotice extends StatelessWidget {
  const _ArchiveNotice();

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
              'Arkivi tregon statusin dhe dokumentet zyrtare të regjistruara. Rezultatet numerike shtohen vetëm pas verifikimit nga burimet e KQZ.',
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

class _SummaryCard extends StatelessWidget {
  final int total;
  final int officialInApp;
  final int officialFiles;

  const _SummaryCard({
    required this.total,
    required this.officialInApp,
    required this.officialFiles,
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
                icon: Icons.event_available_rounded,
                label: 'Zgjedhje',
                value: '$total',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryItem(
                icon: Icons.verified_rounded,
                label: 'Në app',
                value: '$officialInApp',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryItem(
                icon: Icons.description_rounded,
                label: 'Dosje',
                value: '$officialFiles',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
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

class _SearchAndFilterCard extends StatelessWidget {
  final TextEditingController controller;
  final ElectionArchiveFilter filter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ElectionArchiveFilter?> onFilterChanged;

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
                hintText: 'Kërko zgjedhje, vit ose lloj...',
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
            DropdownButtonFormField<ElectionArchiveFilter>(
              value: filter,
              decoration: const InputDecoration(
                labelText: 'Filtri',
              ),
              items: const [
                DropdownMenuItem(
                  value: ElectionArchiveFilter.all,
                  child: Text('Të gjitha'),
                ),
                DropdownMenuItem(
                  value: ElectionArchiveFilter.parliamentary,
                  child: Text('Parlamentare'),
                ),
                DropdownMenuItem(
                  value: ElectionArchiveFilter.local,
                  child: Text('Lokale'),
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

class _ArchiveCard extends StatelessWidget {
  final ElectionArchiveItem item;
  final List<ElectionOfficialFile> officialFiles;
  final VoidCallback onOpenSource;
  final ValueChanged<ElectionOfficialFile> onOpenFile;

  const _ArchiveCard({
    required this.item,
    required this.officialFiles,
    required this.onOpenSource,
    required this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnyData = item.hasOfficialResultsInApp ||
        item.hasCandidateDataInApp ||
        item.hasMunicipalityDataInApp;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    hasAnyData
                        ? Icons.verified_rounded
                        : Icons.pending_actions_rounded,
                    color: hasAnyData
                        ? AppTheme.primaryGreen
                        : const Color(0xFFB54708),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.shortTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Chip(label: item.type, icon: Icons.category_rounded),
                _Chip(label: item.dateLabel, icon: Icons.calendar_month_rounded),
                _Chip(
                  label: hasAnyData ? 'Në app' : 'Në pritje',
                  icon: hasAnyData
                      ? Icons.verified_rounded
                      : Icons.hourglass_empty_rounded,
                ),
                _Chip(
                  label: '${officialFiles.length} dosje',
                  icon: Icons.description_rounded,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.statusLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: onOpenSource,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Hap burimin'),
                ),
              ],
            ),
            if (officialFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              _OfficialFilesSection(
                files: officialFiles,
                onOpenFile: onOpenFile,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OfficialFilesSection extends StatelessWidget {
  final List<ElectionOfficialFile> files;
  final ValueChanged<ElectionOfficialFile> onOpenFile;

  const _OfficialFilesSection({
    required this.files,
    required this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(top: 6),
      iconColor: AppTheme.primaryGreen,
      collapsedIconColor: AppTheme.textMuted,
      title: Text(
        'Dosjet zyrtare të KQZ (${files.length})',
        style: const TextStyle(
          color: AppTheme.textDark,
          fontSize: 14.5,
          fontWeight: FontWeight.w900,
        ),
      ),
      children: files.map(
            (file) {
          return _OfficialFileTile(
            file: file,
            onOpen: () => onOpenFile(file),
          );
        },
      ).toList(),
    );
  }
}

class _OfficialFileTile extends StatelessWidget {
  final ElectionOfficialFile file;
  final VoidCallback onOpen;

  const _OfficialFileTile({
    required this.file,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppTheme.softGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              file.fileType.toUpperCase() == 'PDF'
                  ? Icons.picture_as_pdf_rounded
                  : Icons.table_chart_rounded,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.title,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  file.description,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12.2,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _MiniChip(label: file.fileType),
                    if (file.isResultData) const _MiniChip(label: 'Rezultate'),
                    if (file.isCandidateData) const _MiniChip(label: 'Kandidatë'),
                    if (file.isMunicipalityData) const _MiniChip(label: 'Komuna'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hap dosjen',
            onPressed: onOpen,
            icon: const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;

  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.primaryGreen,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Chip({
    required this.label,
    required this.icon,
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

class _EmptyArchiveCard extends StatelessWidget {
  const _EmptyArchiveCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Text('Nuk u gjet asnjë zgjedhje me këtë kërkim.'),
      ),
    );
  }
}
