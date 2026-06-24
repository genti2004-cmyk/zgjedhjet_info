import 'parliamentary_2001_municipality_detail_screen.dart';
import 'parliamentary_2004_municipality_detail_screen.dart';
import 'parliamentary_2007_municipality_detail_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/models/election_source.dart';
import '../../../core/services/election_data_status.dart';
import '../../../core/models/municipality_result.dart';
import '../../../core/services/selected_election_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/utils/municipality_name_helper.dart';
import '../../../core/widgets/app_state_cards.dart';
import '../../../core/widgets/election_picker_card.dart';
import '../../../core/widgets/premium_components.dart';
import '../../results/data/election_repository.dart';
import 'parliamentary_2017_municipality_detail_screen.dart';
import 'parliamentary_2014_municipality_detail_screen.dart';
import 'parliamentary_2010_municipality_detail_screen.dart';
import 'parliamentary_2019_municipality_detail_screen.dart';
import 'parliamentary_2021_municipality_detail_screen.dart';
import 'parliamentary_2025_municipality_detail_screen.dart';

enum MunicipalitySortMode {
  name,
  turnout,
  voters,
  votesCast,
}

class MunicipalitiesScreen extends StatefulWidget {
  const MunicipalitiesScreen({super.key});

  @override
  State<MunicipalitiesScreen> createState() => _MunicipalitiesScreenState();
}

class _MunicipalitiesScreenState extends State<MunicipalitiesScreen> {
  final ElectionRepository _repository = const ElectionRepository();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<MunicipalityResult>> _municipalityResultsFuture;

  String _searchQuery = '';
  MunicipalitySortMode _sortMode = MunicipalitySortMode.name;

  @override
  void initState() {
    super.initState();
    SelectedElectionController.selectedElection.addListener(
      _handleElectionChanged,
    );
    _loadMunicipalities();
  }

  @override
  void dispose() {
    SelectedElectionController.selectedElection.removeListener(
      _handleElectionChanged,
    );
    _searchController.dispose();
    super.dispose();
  }

  void _handleElectionChanged() {
    if (!mounted) return;

    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _sortMode = MunicipalitySortMode.name;
      _loadMunicipalities();
    });
  }

  void _loadMunicipalities() {
    _municipalityResultsFuture = _repository.getMunicipalityResults();
  }

  void _refresh() {
    setState(_loadMunicipalities);
  }

  bool _isParliamentary(ElectionSource source) {
    return ElectionDataStatus.isParliamentary(source);
  }

  bool _hasRegisteredMunicipalitySources(ElectionSource source) {
    return ElectionDataStatus.hasRegisteredMunicipalitySources(source);
  }

  bool _hasOfficialMunicipalityResults(ElectionSource source) {
    return ElectionDataStatus.hasOfficialMunicipalityResults(source);
  }

  String _normalizeSearchText(String value) {
    return value
        .toLowerCase()
        .replaceAll('ë', 'e')
        .replaceAll('ç', 'c')
        .replaceAll('č', 'c')
        .replaceAll('ć', 'c')
        .replaceAll('š', 's')
        .replaceAll('ž', 'z')
        .replaceAll('đ', 'd')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim();
  }

  String _municipalityNoticeMessage(ElectionSource source) {
    if (_hasOfficialMunicipalityResults(source)) {
      return 'Të dhënat janë importuar nga skedari zyrtar i KQZ. Votuesit dhe dalja nuk shfaqen, sepse skedari nuk i përmban.';
    }

    if (_isParliamentary(source)) {
      if (_hasRegisteredMunicipalitySources(source)) {
        return 'Për ${source.shortTitle} burimet zyrtare të komunave janë regjistruar në arkiv. Të dhënat numerike sipas komunave ende nuk janë importuar, sepse duhet verifikim i plotë i skedarëve të KQZ.';
      }

      return 'Rezultatet sipas komunave do të shfaqen vetëm pas importimit dhe verifikimit të të dhënave zyrtare të KQZ.';
    }

    return 'Të dhënat zyrtare për komunat nuk janë importuar ende. Ato do të shfaqen vetëm pas verifikimit nga dokumentet zyrtare të KQZ.';
  }

  List<MunicipalityResult> _filterAndSort(
    List<MunicipalityResult> municipalities,
  ) {
    final query = _normalizeSearchText(_searchQuery);

    final filtered = municipalities.where((item) {
      if (query.isEmpty) return true;

      final searchable = _normalizeSearchText(
        '${MunicipalityNameHelper.searchableText(item.name)} '
        '${item.leadingSubject} ${item.id}',
      );

      return searchable.contains(query);
    }).toList();

    switch (_sortMode) {
      case MunicipalitySortMode.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case MunicipalitySortMode.turnout:
        filtered.sort(
          (a, b) => b.turnoutPercentage.compareTo(a.turnoutPercentage),
        );
        break;
      case MunicipalitySortMode.voters:
        filtered.sort((a, b) => b.voters.compareTo(a.voters));
        break;
      case MunicipalitySortMode.votesCast:
        filtered.sort((a, b) => b.votesCast.compareTo(a.votesCast));
        break;
    }

    return filtered;
  }

  int _totalVoters(List<MunicipalityResult> municipalities) {
    return municipalities.fold<int>(0, (sum, item) => sum + item.voters);
  }

  int _totalVotesCast(List<MunicipalityResult> municipalities) {
    return municipalities.fold<int>(0, (sum, item) => sum + item.votesCast);
  }

  double _averageTurnout(List<MunicipalityResult> municipalities) {
    if (municipalities.isEmpty) return 0;

    final total = municipalities.fold<double>(
      0,
      (sum, item) => sum + item.turnoutPercentage,
    );

    return total / municipalities.length;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ElectionSource>(
      valueListenable: SelectedElectionController.selectedElection,
      builder: (context, selectedElection, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Komunat'),
            actions: [
              IconButton(
                tooltip: 'Përditëso',
                onPressed: _refresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: FutureBuilder<List<MunicipalityResult>>(
            future: _municipalityResultsFuture,
            builder: (context, snapshot) {
              final allMunicipalities =
                  snapshot.data ?? const <MunicipalityResult>[];
              final visibleMunicipalities = _filterAndSort(allMunicipalities);

              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                  await _municipalityResultsFuture;
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  children: [
                    const _PageHeader(),
                    const SizedBox(height: 9),
                    const ElectionPickerCard(),
                    const SizedBox(height: 9),
                    _CompactMunicipalityNotice(
                      message: _municipalityNoticeMessage(selectedElection),
                    ),
                    const SizedBox(height: 9),
                    if (_isParliamentary(selectedElection) &&
                        !_hasOfficialMunicipalityResults(selectedElection))
                      _MunicipalityPendingCard(source: selectedElection)
                    else if (snapshot.connectionState ==
                        ConnectionState.waiting)
                      const AppLoadingCard(
                        message: 'Duke ngarkuar komunat...',
                      )
                    else if (snapshot.hasError)
                      AppErrorCard(
                        message:
                            'Ju lutem kontrolloni lidhjen me internetin ose provoni përsëri.',
                        onRetry: _refresh,
                      )
                    else if (allMunicipalities.isEmpty)
                      const _LocalMunicipalityEmptyCard()
                    else ...[
                      _SummaryCard(
                        municipalitiesCount: allMunicipalities.length,
                        totalVoters: _totalVoters(allMunicipalities),
                        totalVotesCast: _totalVotesCast(allMunicipalities),
                        averageTurnout: _averageTurnout(allMunicipalities),
                        hasVoterStatistics: allMunicipalities.any(
                          (item) => item.hasVoterStatistics,
                        ),
                      ),
                      const SizedBox(height: 9),
                      _SearchAndSortCard(
                        controller: _searchController,
                        sortMode: _sortMode,
                        hasVoterStatistics: allMunicipalities.any(
                          (item) => item.hasVoterStatistics,
                        ),
                        onSearchChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onSortChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _sortMode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      if (visibleMunicipalities.isEmpty)
                        const AppEmptyCard(
                          message: 'Nuk u gjet asnjë komunë me këtë kërkim.',
                        )
                      else
                        ...visibleMunicipalities.asMap().entries.map(
                              (entry) => _MunicipalityCard(
                                rank: entry.key + 1,
                                result: entry.value,
                                onTap: switch (selectedElection.type) {
                                  ElectionSourceType.parliamentary2025 => () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              Parliamentary2025MunicipalityDetailScreen(
                                            municipalityName: entry.value.name,
                                          ),
                                        ),
                                      );
                                    },
                                  ElectionSourceType.parliamentary2021 => () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              Parliamentary2021MunicipalityDetailScreen(
                                            municipalityName: entry.value.name,
                                          ),
                                        ),
                                      );
                                    },
                                  ElectionSourceType.parliamentary2019 => () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              Parliamentary2019MunicipalityDetailScreen(
                                            municipalityName: entry.value.name,
                                          ),
                                        ),
                                      );
                                    },
                                  ElectionSourceType.parliamentary2017 => () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              Parliamentary2017MunicipalityDetailScreen(
                                            municipalityName: entry.value.name,
                                          ),
                                        ),
                                      );
                                    },
                                  ElectionSourceType.parliamentary2014 => () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              Parliamentary2014MunicipalityDetailScreen(
                                            municipalityName: entry.value.name,
                                          ),
                                        ),
                                      );
                                    },
                                  ElectionSourceType.parliamentary2010 => () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => Parliamentary2010MunicipalityDetailScreen(municipalityName: entry.value.name),
                                        ),
                                      );
                                    },
                                  ElectionSourceType.parliamentary2007 => () {
                                      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Parliamentary2007MunicipalityDetailScreen(municipalityName: entry.value.name)));
                                    },
                                  ElectionSourceType.parliamentary2004 => () {
                                      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Parliamentary2004MunicipalityDetailScreen(municipalityName: entry.value.name)));
                                    },
                                  ElectionSourceType.parliamentary2001 => () {
                                      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Parliamentary2001MunicipalityDetailScreen(municipalityName: entry.value.name)));
                                    },
                                  _ => null,
                                },
                              ),
                            ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
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
            Color(0xFF102A43),
            Color(0xFF1559A8),
            Color(0xFF0B2137),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.greenShadow,
      ),
      child: const Row(
        children: [
          Icon(
            Icons.location_city_rounded,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Rezultatet dhe pjesëmarrja sipas komunave.',
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

class _CompactMunicipalityNotice extends StatelessWidget {
  final String message;

  const _CompactMunicipalityNotice({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF2D26B)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              color: Color(0xFFB54708),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF8A5300),
                fontSize: 12.2,
                height: 1.30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalMunicipalityEmptyCard extends StatelessWidget {
  const _LocalMunicipalityEmptyCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        child: Column(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: AppTheme.softNavy,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.location_city_outlined,
                color: AppTheme.primaryNavy,
                size: 29,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Të dhënat zyrtare për komunat nuk janë importuar ende',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Statistikat, kërkimi dhe renditja do të shfaqen vetëm pasi të dhënat të jenë verifikuar nga dokumentet zyrtare të KQZ.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppTheme.successBackground,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppTheme.successBorder),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: AppTheme.successIcon,
                    size: 17,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Vetëm të dhëna të verifikuara',
                    style: TextStyle(
                      color: AppTheme.successText,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
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

class _MunicipalityPendingCard extends StatelessWidget {
  final ElectionSource source;

  const _MunicipalityPendingCard({
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFEDC7A)),
              ),
              child: const Icon(
                Icons.pending_actions_rounded,
                color: Color(0xFFB54708),
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Të dhënat sipas komunave nuk janë importuar ende',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Për ${source.shortTitle} nuk shfaqen karta, statistika ose numra provë. Burimet zyrtare janë në arkiv dhe të dhënat do të lidhen vetëm pas verifikimit të plotë.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
              decoration: BoxDecoration(
                color: AppTheme.softGreen,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: AppTheme.primaryGreen,
                    size: 17,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Pa të dhëna të shpikura',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
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

class _SummaryCard extends StatelessWidget {
  final int municipalitiesCount;
  final int totalVoters;
  final int totalVotesCast;
  final double averageTurnout;
  final bool hasVoterStatistics;

  const _SummaryCard({
    required this.municipalitiesCount,
    required this.totalVoters,
    required this.totalVotesCast,
    required this.averageTurnout,
    required this.hasVoterStatistics,
  });

  @override
  Widget build(BuildContext context) {
    final voters = AppFormatters.number(totalVoters);
    final votesCast = AppFormatters.number(totalVotesCast);
    final turnout = AppFormatters.percent(averageTurnout);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(11, 11, 11, 11),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                label: 'Komuna',
                value: '$municipalitiesCount',
                icon: Icons.map_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryItem(
                label: 'Vota',
                value: votesCast,
                icon: Icons.how_to_vote_rounded,
              ),
            ),
            if (hasVoterStatistics) ...[
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryItem(
                  label: 'Votues',
                  value: voters,
                  icon: Icons.people_alt_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryItem(
                  label: 'Dalja',
                  value: turnout,
                  icon: Icons.percent_rounded,
                ),
              ),
            ],
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
      padding: const EdgeInsets.fromLTRB(8, 9, 8, 9),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 20,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
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

class _SearchAndSortCard extends StatelessWidget {
  final TextEditingController controller;
  final MunicipalitySortMode sortMode;
  final bool hasVoterStatistics;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<MunicipalitySortMode?> onSortChanged;

  const _SearchAndSortCard({
    required this.controller,
    required this.sortMode,
    required this.hasVoterStatistics,
    required this.onSearchChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Kërko komunë ose subjekt...',
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
            const SizedBox(height: 8),
            DropdownButtonFormField<MunicipalitySortMode>(
              value: sortMode,
              decoration: const InputDecoration(
                labelText: 'Renditja',
              ),
              items: [
                const DropdownMenuItem(
                  value: MunicipalitySortMode.name,
                  child: Text('Sipas emrit'),
                ),
                if (hasVoterStatistics) ...[
                  const DropdownMenuItem(
                    value: MunicipalitySortMode.turnout,
                    child: Text('Sipas daljes'),
                  ),
                  const DropdownMenuItem(
                    value: MunicipalitySortMode.voters,
                    child: Text('Sipas votuesve'),
                  ),
                ],
                const DropdownMenuItem(
                  value: MunicipalitySortMode.votesCast,
                  child: Text('Sipas votave'),
                ),
              ],
              onChanged: onSortChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _MunicipalityCard extends StatelessWidget {
  final int rank;
  final MunicipalityResult result;
  final VoidCallback? onTap;

  const _MunicipalityCard({
    required this.rank,
    required this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final voters = AppFormatters.number(result.voters);
    final votesCast = AppFormatters.number(result.votesCast);
    final turnout = AppFormatters.percent(result.turnoutPercentage);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RankBadge(rank: rank),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Udhëheq: ${result.leadingSubject}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PremiumInfoChip(
                        icon: Icons.how_to_vote_rounded,
                        label: '$votesCast vota',
                      ),
                      if (result.hasVoterStatistics) ...[
                        PremiumInfoChip(
                          icon: Icons.percent_rounded,
                          label: 'Dalja $turnout',
                        ),
                        PremiumInfoChip(
                          icon: Icons.people_alt_rounded,
                          label: '$voters votues',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 7),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;

  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        '$rank',
        style: const TextStyle(
          color: AppTheme.primaryGreen,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

