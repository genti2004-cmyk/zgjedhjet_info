import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/election_archive_item.dart';
import '../../../core/theme/app_theme.dart';
import '../data/election_archive_catalog.dart';

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

  Future<void> _openSource(BuildContext context, String url) async {
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
              (item) => _ArchiveCard(
                item: item,
                onOpenSource: () => _openSource(context, item.sourceUrl),
              ),
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
              'Arkivi është struktura bazë. Rezultatet do të vendosen vetëm me burime zyrtare të KQZ ose dokumente të verifikueshme.',
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

  const _SummaryCard({
    required this.total,
    required this.officialInApp,
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
            const Expanded(
              child: _SummaryItem(
                icon: Icons.source_rounded,
                label: 'Burimi',
                value: 'KQZ',
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
  final VoidCallback onOpenSource;

  const _ArchiveCard({
    required this.item,
    required this.onOpenSource,
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
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.statusLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: onOpenSource,
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Hap burimin'),
              ),
            ),
          ],
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
