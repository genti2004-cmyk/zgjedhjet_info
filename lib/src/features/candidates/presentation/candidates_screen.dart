import 'package:flutter/material.dart';

import '../../../core/models/candidate_result.dart';
import '../../../core/models/election_source.dart';
import '../../../core/services/election_data_status.dart';
import '../../../core/services/selected_election_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_state_cards.dart';
import '../../../core/widgets/election_picker_card.dart';
import '../../../core/widgets/premium_components.dart';
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

  bool _hasOfficialCandidates(ElectionSource source) {
    return ElectionDataStatus.hasOfficialElectedCandidates(source);
  }

  bool _hasRegisteredSourcesOnly(ElectionSource source) {
    return ElectionDataStatus.isSourceOnly(source);
  }

  String _emptyMessage(ElectionSource source) {
    return ElectionDataStatus.candidateEmptyMessage(source);
  }

  String _candidateNoticeMessage(ElectionSource source) {
    if (_hasOfficialCandidates(source)) {
      return 'Për ${source.shortTitle} shfaqen kandidatët e zgjedhur dhe votat nga dokumentet zyrtare të KQZ.';
    }

    if (_hasRegisteredSourcesOnly(source)) {
      return 'Për ${source.shortTitle} burimet zyrtare të kandidatëve janë regjistruar. Kandidatët nuk shfaqen ende, sepse skedarët duhet të verifikohen plotësisht.';
    }

    return 'Kjo faqe është e përgatitur për kandidatët e kësaj zgjedhjeje. Aktualisht shfaqen të dhëna strukturore/testuese deri në lidhjen reale me KQZ.';
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

  CandidateResult? _topCandidate(List<CandidateResult> candidates) {
    if (candidates.isEmpty) return null;
    final sorted = [...candidates]..sort((a, b) => b.votes.compareTo(a.votes));
    return sorted.first;
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
              final topCandidate = _topCandidate(allCandidates);

              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                  await _candidateResultsFuture;
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  children: [
                    _PremiumHeader(
                      source: selectedElection,
                      topCandidate: topCandidate,
                      isOfficial: _hasOfficialCandidates(selectedElection),
                      isSourceOnly: _hasRegisteredSourcesOnly(selectedElection),
                    ),
                    const SizedBox(height: 12),
                    ElectionPickerCard(onChanged: _refresh),
                    const SizedBox(height: 12),
                    PremiumStatusNotice(
                      icon: _hasOfficialCandidates(selectedElection)
                          ? Icons.verified_rounded
                          : Icons.info_outline_rounded,
                      verified: _hasOfficialCandidates(selectedElection),
                      message: _candidateNoticeMessage(selectedElection),
                    ),
                    const SizedBox(height: 12),
                    _SummaryCard(
                      candidatesCount: allCandidates.length,
                      subjectsCount: _subjectCount(allCandidates),
                      totalVotes: _totalVotes(allCandidates),
                      topCandidate: topCandidate,
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
                      AppEmptyCard(
                        message: _emptyMessage(selectedElection),
                      )
                    else if (visibleCandidates.isEmpty)
                      const AppEmptyCard(
                        message: 'Nuk u gjet asnjë kandidat me këtë kërkim.',
                      )
                    else ...[
                      _ListHeader(
                        count: visibleCandidates.length,
                        sortMode: _sortMode,
                      ),
                      const SizedBox(height: 10),
                      ...visibleCandidates.asMap().entries.map(
                            (entry) => _CandidateCard(
                              rank: entry.key + 1,
                              result: entry.value,
                              maxVotes:
                                  topCandidate == null ? 0 : topCandidate.votes,
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

class _PremiumHeader extends StatelessWidget {
  final ElectionSource source;
  final CandidateResult? topCandidate;
  final bool isOfficial;
  final bool isSourceOnly;

  const _PremiumHeader({
    required this.source,
    required this.topCandidate,
    required this.isOfficial,
    required this.isSourceOnly,
  });

  @override
  Widget build(BuildContext context) {
    final status = isOfficial
        ? 'KQZ të dhëna aktive'
        : isSourceOnly
            ? 'Burime zyrtare'
            : 'Në përgatitje';

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
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const Spacer(),
              PremiumHeroStatusPill(label: status, verified: isOfficial),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Kandidatët',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: -0.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            source.shortTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            source.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFEAF2FF),
              fontSize: 13.3,
              fontWeight: FontWeight.w700,
              height: 1.32,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PremiumWhitePill(
                icon: Icons.calendar_month_rounded,
                label: source.dateLabel,
              ),
              PremiumWhitePill(
                icon: Icons.emoji_events_rounded,
                label: topCandidate == null
                    ? 'Pa kandidatë'
                    : 'Top: ${topCandidate!.fullName}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int candidatesCount;
  final int subjectsCount;
  final int totalVotes;
  final CandidateResult? topCandidate;

  const _SummaryCard({
    required this.candidatesCount,
    required this.subjectsCount,
    required this.totalVotes,
    required this.topCandidate,
  });

  @override
  Widget build(BuildContext context) {
    final votes = AppFormatters.number(totalVotes);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          children: [
            Row(
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
            if (topCandidate != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.successBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_rounded,
                      color: AppTheme.primaryGreen,
                      size: 23,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${topCandidate!.fullName} • ${AppFormatters.number(topCandidate!.votes)} vota',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 13.2,
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
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

class _ListHeader extends StatelessWidget {
  final int count;
  final CandidateSortMode sortMode;

  const _ListHeader({
    required this.count,
    required this.sortMode,
  });

  @override
  Widget build(BuildContext context) {
    final sortLabel = switch (sortMode) {
      CandidateSortMode.votes => 'sipas votave',
      CandidateSortMode.name => 'sipas emrit',
      CandidateSortMode.subject => 'sipas subjektit',
      CandidateSortMode.municipality => 'sipas komunës',
    };

    return Row(
      children: [
        Expanded(
          child: Text(
            '$count kandidatë • $sortLabel',
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 14.2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final int rank;
  final CandidateResult result;
  final int maxVotes;

  const _CandidateCard({
    required this.rank,
    required this.result,
    required this.maxVotes,
  });

  @override
  Widget build(BuildContext context) {
    final votes = AppFormatters.number(result.votes);
    final progress = maxVotes <= 0 ? 0.0 : result.votes / maxVotes;

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
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      minHeight: 7,
                      value: progress.clamp(0, 1),
                      backgroundColor: AppTheme.softGreen,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PremiumInfoChip(
                        icon: Icons.how_to_vote_rounded,
                        label: '$votes vota',
                      ),
                      PremiumInfoChip(
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
    final top = rank <= 3;

    return Container(
      height: 43,
      width: 43,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: top ? AppTheme.primaryGreen : AppTheme.softGreen,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: top ? AppTheme.primaryGreen : AppTheme.border,
        ),
      ),
      child: Text(
        '$rank',
        style: TextStyle(
          color: top ? Colors.white : AppTheme.primaryGreen,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

