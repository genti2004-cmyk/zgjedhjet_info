import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/election_archive_item.dart';
import '../../../core/models/election_official_file.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/premium_components.dart';
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

  void _openDetails(ElectionArchiveItem item) {
    final files = ElectionOfficialFileCatalog.byElectionId(item.id);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ElectionDetailSheet(
          item: item,
          files: files,
          onOpenSource: () => _openUrl(context, item.sourceUrl),
          onOpenFile: (file) => _openUrl(context, file.url),
        );
      },
    );
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
                  onOpenDetails: () => _openDetails(item),
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
  final VoidCallback onOpenDetails;

  const _ArchiveCard({
    required this.item,
    required this.officialFiles,
    required this.onOpenSource,
    required this.onOpenDetails,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnyData = item.hasOfficialResultsInApp ||
        item.hasCandidateDataInApp ||
        item.hasMunicipalityDataInApp;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onOpenDetails,
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
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PremiumInfoChip(label: item.type, icon: Icons.category_rounded),
                  PremiumInfoChip(label: item.dateLabel, icon: Icons.calendar_month_rounded),
                  PremiumInfoChip(
                    label: hasAnyData ? 'Në app' : 'Në pritje',
                    icon: hasAnyData
                        ? Icons.verified_rounded
                        : Icons.hourglass_empty_rounded,
                  ),
                  PremiumInfoChip(
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
                    onPressed: onOpenDetails,
                    icon: const Icon(Icons.info_outline_rounded),
                    label: const Text('Detajet'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: onOpenSource,
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Burimi'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElectionDetailSheet extends StatelessWidget {
  final ElectionArchiveItem item;
  final List<ElectionOfficialFile> files;
  final VoidCallback onOpenSource;
  final ValueChanged<ElectionOfficialFile> onOpenFile;

  const _ElectionDetailSheet({
    required this.item,
    required this.files,
    required this.onOpenSource,
    required this.onOpenFile,
  });

  bool get _hasImportedResults => item.hasOfficialResultsInApp;
  bool get _hasImportedCandidates => item.hasCandidateDataInApp;
  bool get _hasImportedMunicipalities => item.hasMunicipalityDataInApp;

  int get _resultFileCount => files.where((file) => file.isResultData).length;
  int get _candidateFileCount => files.where((file) => file.isCandidateData).length;
  int get _municipalityFileCount =>
      files.where((file) => file.isMunicipalityData).length;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.55,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
            children: [
              Center(
                child: Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppTheme.borderStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _DetailHeader(item: item),
              const SizedBox(height: 14),
              _DetailStatusGrid(
                hasResults: _hasImportedResults,
                hasCandidates: _hasImportedCandidates,
                hasMunicipalities: _hasImportedMunicipalities,
                fileCount: files.length,
              ),
              const SizedBox(height: 14),
              _DetailInfoCard(
                title: 'Statusi i të dhënave',
                icon: Icons.fact_check_rounded,
                children: [
                  _StatusRow(
                    label: 'Rezultatet',
                    value: _hasImportedResults
                        ? 'Importuar në app'
                        : _resultFileCount > 0
                            ? 'Burimi është regjistruar'
                            : 'Ende pa burim të veçantë',
                    isDone: _hasImportedResults,
                  ),
                  _StatusRow(
                    label: 'Kandidatët',
                    value: _hasImportedCandidates
                        ? 'Importuar në app'
                        : _candidateFileCount > 0
                            ? 'Burimi është regjistruar'
                            : 'Ende pa burim të veçantë',
                    isDone: _hasImportedCandidates,
                  ),
                  _StatusRow(
                    label: 'Komunat',
                    value: _hasImportedMunicipalities
                        ? 'Importuar në app'
                        : _municipalityFileCount > 0
                            ? 'Burimi është regjistruar, importi mungon'
                            : 'Ende pa burim të veçantë',
                    isDone: _hasImportedMunicipalities,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _DetailInfoCard(
                title: 'Çfarë mungon ende',
                icon: Icons.pending_actions_rounded,
                children: [
                  if (!_hasImportedResults)
                    const _MissingRow(text: 'Importi i rezultateve numerike.'),
                  if (!_hasImportedCandidates)
                    const _MissingRow(text: 'Importi i kandidatëve të zgjedhur.'),
                  if (!_hasImportedMunicipalities)
                    const _MissingRow(
                      text: 'Importi i rezultateve sipas komunave.',
                    ),
                  if (_hasImportedResults &&
                      _hasImportedCandidates &&
                      _hasImportedMunicipalities)
                    const _MissingRow(text: 'Nuk mungon asgjë kryesore.'),
                ],
              ),
              const SizedBox(height: 14),
              _OfficialFilesBlock(
                files: files,
                onOpenFile: onOpenFile,
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onOpenSource,
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Hap faqen zyrtare'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final ElectionArchiveItem item;

  const _DetailHeader({required this.item});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.hasOfficialResultsInApp
                ? Icons.verified_rounded
                : Icons.archive_rounded,
            color: Colors.white,
            size: 34,
          ),
          const SizedBox(height: 12),
          Text(
            item.shortTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            item.title,
            style: const TextStyle(
              color: Color(0xFFEAF7F0),
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PremiumWhitePill(icon: Icons.calendar_month_rounded, label: item.dateLabel),
              PremiumWhitePill(icon: Icons.category_rounded, label: item.type),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailStatusGrid extends StatelessWidget {
  final bool hasResults;
  final bool hasCandidates;
  final bool hasMunicipalities;
  final int fileCount;

  const _DetailStatusGrid({
    required this.hasResults,
    required this.hasCandidates,
    required this.hasMunicipalities,
    required this.fileCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DetailMetric(
            label: 'Rezultate',
            value: hasResults ? 'Po' : 'Jo',
            icon: Icons.bar_chart_rounded,
            isDone: hasResults,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DetailMetric(
            label: 'Kandidatë',
            value: hasCandidates ? 'Po' : 'Jo',
            icon: Icons.people_alt_rounded,
            isDone: hasCandidates,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DetailMetric(
            label: 'Dosje',
            value: '$fileCount',
            icon: Icons.description_rounded,
            isDone: fileCount > 0,
          ),
        ),
      ],
    );
  }
}

class _DetailMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDone;

  const _DetailMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      decoration: BoxDecoration(
        color: isDone ? AppTheme.softGreen : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone ? const Color(0xFFABEFC6) : const Color(0xFFFEDC7A),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isDone ? AppTheme.primaryGreen : const Color(0xFFB54708),
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 15,
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

class _DetailInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailInfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDone;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            color: isDone ? AppTheme.primaryGreen : const Color(0xFFB54708),
            size: 19,
          ),
          const SizedBox(width: 9),
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
                fontSize: 12.6,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingRow extends StatelessWidget {
  final String text;

  const _MissingRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.pending_rounded,
            color: Color(0xFFB54708),
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialFilesBlock extends StatelessWidget {
  final List<ElectionOfficialFile> files;
  final ValueChanged<ElectionOfficialFile> onOpenFile;

  const _OfficialFilesBlock({
    required this.files,
    required this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Ende nuk ka dosje zyrtare të regjistruara për këtë zgjedhje.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description_rounded, color: AppTheme.primaryGreen),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Dosjet zyrtare (${files.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...files.map(
              (file) => _OfficialFileTile(
                file: file,
                onOpen: () => onOpenFile(file),
              ),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
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
                    PremiumInfoChip(icon: Icons.label_rounded, label: file.fileType),
                    if (file.isResultData) const PremiumInfoChip(icon: Icons.label_rounded, label: 'Rezultate'),
                    if (file.isCandidateData) const PremiumInfoChip(icon: Icons.label_rounded, label: 'Kandidatë'),
                    if (file.isMunicipalityData) const PremiumInfoChip(icon: Icons.label_rounded, label: 'Komuna'),
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
