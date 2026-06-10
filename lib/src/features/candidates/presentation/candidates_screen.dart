import 'package:flutter/material.dart';

import '../../../core/models/candidate_result.dart';
import '../../../core/models/election_source.dart';
import '../../../core/services/selected_election_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_state_cards.dart';
import '../../../core/widgets/election_picker_card.dart';
import '../../results/data/election_repository.dart';

enum CandidateSortMode {
  votes,
  name,
  subject,
  municipality,
}

class CandidatesScreen extends StatefulWidget {
  const CandidatesScreen({super.key});

  @override
  State<CandidatesScreen> createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  final ElectionRepository _repository = const ElectionRepository();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<CandidateResult>> _candidateResultsFuture;

  String _searchQuery = '';
  CandidateSortMode _sortMode = CandidateSortMode.votes;

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCandidates() {
    _candidateResultsFuture = _repository.getCandidateResults();
  }

  void _refresh() {
    setState(_loadCandidates);
  }

  List<CandidateResult> _filterAndSort(List<CandidateResult> candidates) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = candidates.where((item) {
      if (query.isEmpty) return true;

      return item.fullName.toLowerCase().contains(query) ||
          item.subjectName.toLowerCase().contains(query) ||
          item.municipalityName.toLowerCase().contains(query) ||
          item.id.toLowerCase().contains(query);
    }).toList();

    switch (_sortMode) {
      case CandidateSortMode.votes:
        filtered.sort((a, b) => b.votes.compareTo(a.votes));
        break;
      case CandidateSortMode.name:
        filtered.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case CandidateSortMode.subject:
        filtered.sort((a, b) => a.subjectName.compareTo(b.subjectName));
        break;
      case CandidateSortMode.municipality:
        filtered.sort(
          (a, b) => a.municipalityName.compareTo(b.municipalityName),
        );
        break;
    }

    return filtered;
  }

  int _totalVotes(List<CandidateResult> candidates) {
    return candidates.fold<int>(0, (sum, item) => sum + item.votes);
  }

  int _subjectCount(List<CandidateResult> candidates) {
    final subjects = candidates.map((item) => item.subjectName).toSet();
    return subjects.length;
  }

  int _municipalityCount(List<CandidateResult> candidates) {
    final municipalities =
        candidates.map((item) => item.municipalityName).toSet();
    return municipalities.length;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ElectionSource>(
      valueListenable: SelectedElectionController.selectedElection,
      builder: (context, selectedElection, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Kandidatët'),
            actions: [
              IconButton(
                tooltip: 'Përditëso',
                onPressed: _refresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: FutureBuilder<List<CandidateResult>>(
            future: _candidateResultsFuture,
            builder: (context, snapshot) {
              final allCandidates = snapshot.data ?? const <CandidateResult>[];
              final visibleCandidates = _filterAndSort(allCandidates);

              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                  await _candidateResultsFuture;
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  children: [
                    const _PageHeader(),
                    const SizedBox(height: 12),
                    ElectionPickerCard(onChanged: _refresh),
                    const SizedBox(height: 12),
                    _CandidateDataNotice(source: selectedElection),
                    const SizedBox(height: 12),
                    _SummaryCard(
                      candidatesCount: allCandidates.length,
                      subjectsCount: _subjectCount(allCandidates),
                      municipalitiesCount: _municipalityCount(allCandidates),
                      totalVotes: _totalVotes(allCandidates),
                    ),
                    const SizedBox(height: 12),
                    _SearchAndSortCard(
                      controller: _searchController,
                      sortMode: _sortMode,
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
                    const SizedBox(height: 18),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const AppLoadingCard(
                        message: 'Duke ngarkuar kandidatët...',
                      )
                    else if (snapshot.hasError)
                      AppErrorCard(
                        message:
                            'Ju lutem kontrolloni lidhjen me internetin ose provoni përsëri.',
                        onRetry: _refresh,
                      )
                    else if (allCandidates.isEmpty)
                      const AppEmptyCard(
                        message: 'Nuk ka ende kandidatë për t’u shfaqur.',
                      )
                    else if (visibleCandidates.isEmpty)
                      const AppEmptyCard(
                        message: 'Nuk u gjet asnjë kandidat me këtë kërkim.',
                      )
                    else
                      ...visibleCandidates.asMap().entries.map(
                            (entry) => _CandidateCard(
                              rank: entry.key + 1,
                              result: entry.value,
                            ),
                          ),
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
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.greenShadow,
      ),
      child: const Row(
        children: [
          Icon(
            Icons.people_alt_rounded,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Kandidatët, subjektet politike dhe votat.',
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

class _CandidateDataNotice extends StatelessWidget {
  final ElectionSource source;

  const _CandidateDataNotice({
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final isOfficial = source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019;

    final message = isOfficial
        ? 'Për ${source.shortTitle} shfaqen kandidatët e zgjedhur dhe votat nga dokumentet zyrtare të KQZ.'
        : 'Kjo faqe është e përgatitur për kandidatët e kësaj zgjedhjeje. Aktualisht shfaqen të dhëna strukturore/testuese deri në lidhjen reale me KQZ.';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: isOfficial ? const Color(0xFFECFDF3) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOfficial ? const Color(0xFFABEFC6) : const Color(0xFFFEDC7A),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOfficial ? Icons.verified_rounded : Icons.info_outline_rounded,
            color: isOfficial ? const Color(0xFF079455) : const Color(0xFFB54708),
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color:
                    isOfficial ? const Color(0xFF067647) : const Color(0xFF7A4B00),
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
  final int candidatesCount;
  final int subjectsCount;
  final int municipalitiesCount;
  final int totalVotes;

  const _SummaryCard({
    required this.candidatesCount,
    required this.subjectsCount,
    required this.municipalitiesCount,
    required this.totalVotes,
  });

  @override
  Widget build(BuildContext context) {
    final votes = AppFormatters.number(totalVotes);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(
                label: 'Kandidatë',
                value: '$candidatesCount',
                icon: Icons.person_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryItem(
                label: 'Subjekte',
                value: '$subjectsCount',
                icon: Icons.account_balance_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryItem(
                label: 'Vota',
                value: votes,
                icon: Icons.how_to_vote_rounded,
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

class _SearchAndSortCard extends StatelessWidget {
  final TextEditingController controller;
  final CandidateSortMode sortMode;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<CandidateSortMode?> onSortChanged;

  const _SearchAndSortCard({
    required this.controller,
    required this.sortMode,
    required this.onSearchChanged,
    required this.onSortChanged,
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
                hintText: 'Kërko kandidat, subjekt ose komunë...',
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
            DropdownButtonFormField<CandidateSortMode>(
              value: sortMode,
              decoration: const InputDecoration(
                labelText: 'Renditja',
              ),
              items: const [
                DropdownMenuItem(
                  value: CandidateSortMode.votes,
                  child: Text('Sipas votave'),
                ),
                DropdownMenuItem(
                  value: CandidateSortMode.name,
                  child: Text('Sipas emrit'),
                ),
                DropdownMenuItem(
                  value: CandidateSortMode.subject,
                  child: Text('Sipas subjektit'),
                ),
                DropdownMenuItem(
                  value: CandidateSortMode.municipality,
                  child: Text('Sipas komunës'),
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

class _CandidateCard extends StatelessWidget {
  final int rank;
  final CandidateResult result;

  const _CandidateCard({
    required this.rank,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final votes = AppFormatters.number(result.votes);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    result.fullName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.subjectName,
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
                      _InfoChip(
                        icon: Icons.how_to_vote_rounded,
                        label: '$votes vota',
                      ),
                      _InfoChip(
                        icon: Icons.location_city_rounded,
                        label: result.municipalityName,
                      ),
                    ],
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

