import 'package:flutter/material.dart';

import '../../../core/models/election_source.dart';
import '../../../core/services/election_data_status.dart';
import '../../../core/models/party_result.dart';
import '../../../core/services/selected_election_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_state_cards.dart';
import '../../../core/widgets/election_picker_card.dart';
import '../../../core/widgets/premium_components.dart';
import '../data/election_repository.dart';

enum ResultSortMode {
  votes,
  percentage,
  seats,
  name,
}

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final ElectionRepository _repository = const ElectionRepository();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<PartyResult>> _partyResultsFuture;

  String _searchQuery = '';
  ResultSortMode _sortMode = ResultSortMode.votes;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadResults() {
    _partyResultsFuture = _repository.getPartyResults();
  }

  void _refresh() {
    setState(_loadResults);
  }

  bool _hasOfficialResults(ElectionSource source) {
    return ElectionDataStatus.hasOfficialPartyResults(source);
  }

  bool _hasRegisteredSourcesOnly(ElectionSource source) {
    return ElectionDataStatus.isSourceOnly(source);
  }

  String _emptyMessage(ElectionSource source) {
    return ElectionDataStatus.resultEmptyMessage(source);
  }

  String _resultNoticeMessage(ElectionSource source) {
    if (_hasOfficialResults(source)) {
      return 'Për ${source.shortTitle} shfaqen rezultatet e subjekteve politike, votat, përqindjet dhe mandatet nga dokumentet zyrtare të KQZ.';
    }

    if (_hasRegisteredSourcesOnly(source)) {
      return 'Për ${source.shortTitle} burimet zyrtare të KQZ janë regjistruar. Rezultatet nuk shfaqen ende, sepse skedarët duhet të verifikohen plotësisht.';
    }

    return 'Për ${source.shortTitle} rezultatet zyrtare nuk janë importuar ende. Ato do të shfaqen vetëm pas verifikimit të plotë të dokumenteve zyrtare të KQZ.';
  }

  List<PartyResult> _filterAndSort(List<PartyResult> results) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = results.where((item) {
      if (query.isEmpty) return true;

      return item.name.toLowerCase().contains(query) ||
          item.shortName.toLowerCase().contains(query) ||
          item.id.toLowerCase().contains(query);
    }).toList();

    switch (_sortMode) {
      case ResultSortMode.votes:
        filtered.sort((a, b) => b.votes.compareTo(a.votes));
        break;
      case ResultSortMode.percentage:
        filtered.sort((a, b) => b.percentage.compareTo(a.percentage));
        break;
      case ResultSortMode.seats:
        filtered.sort((a, b) => b.seats.compareTo(a.seats));
        break;
      case ResultSortMode.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return filtered;
  }

  int _totalVotes(List<PartyResult> results) {
    return results.fold<int>(0, (sum, item) => sum + item.votes);
  }

  int _totalSeats(List<PartyResult> results) {
    return results.fold<int>(0, (sum, item) => sum + item.seats);
  }

  PartyResult? _winner(List<PartyResult> results) {
    if (results.isEmpty) return null;
    final sorted = [...results]..sort((a, b) => b.votes.compareTo(a.votes));
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
            title: const Text('Rezultatet'),
            actions: [
              IconButton(
                tooltip: 'Përditëso',
                onPressed: _refresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: FutureBuilder<List<PartyResult>>(
            future: _partyResultsFuture,
            builder: (context, snapshot) {
              final allResults = snapshot.data ?? const <PartyResult>[];
              final visibleResults = _filterAndSort(allResults);
              final winner = _winner(allResults);

              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                  await _partyResultsFuture;
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  children: [
                    _PremiumHeader(
                      source: selectedElection,
                      winner: winner,
                      isOfficial: _hasOfficialResults(selectedElection),
                      isSourceOnly: _hasRegisteredSourcesOnly(selectedElection),
                    ),
                    const SizedBox(height: 12),
                    ElectionPickerCard(onChanged: _refresh),
                    const SizedBox(height: 12),
                    PremiumStatusNotice(
                      icon: _hasOfficialResults(selectedElection)
                          ? Icons.verified_rounded
                          : Icons.info_outline_rounded,
                      verified: _hasOfficialResults(selectedElection),
                      message: _resultNoticeMessage(selectedElection),
                    ),
                    const SizedBox(height: 12),
                    _SummaryCard(
                      totalVotes: _totalVotes(allResults),
                      totalSeats: _totalSeats(allResults),
                      subjectsCount: allResults.length,
                      winner: winner,
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
                      const AppLoadingCard(message: 'Duke ngarkuar rezultatet...')
                    else if (snapshot.hasError)
                      AppErrorCard(
                        message:
                            'Ju lutem kontrolloni lidhjen me internetin ose provoni përsëri.',
                        onRetry: _refresh,
                      )
                    else if (allResults.isEmpty)
                      AppEmptyCard(
                        message: _emptyMessage(selectedElection),
                      )
                    else if (visibleResults.isEmpty)
                      const AppEmptyCard(
                        message: 'Nuk u gjet asnjë subjekt me këtë kërkim.',
                      )
                    else ...[
                      _ListHeader(
                        count: visibleResults.length,
                        sortMode: _sortMode,
                      ),
                      const SizedBox(height: 10),
                      ...visibleResults.asMap().entries.map(
                            (entry) => _PartyResultCard(
                              rank: entry.key + 1,
                              result: entry.value,
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
  final PartyResult? winner;
  final bool isOfficial;
  final bool isSourceOnly;

  const _PremiumHeader({
    required this.source,
    required this.winner,
    required this.isOfficial,
    required this.isSourceOnly,
  });

  @override
  Widget build(BuildContext context) {
    final status = isOfficial
        ? 'Të dhëna aktive nga KQZ'
        : isSourceOnly
            ? 'Burime zyrtare'
            : 'Në përgatitje';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF102A43),
            Color(0xFF1677FF),
            Color(0xFF071A2D),
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
                  Icons.bar_chart_rounded,
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
            'Rezultatet',
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
                label: winner == null ? 'Pa rezultate' : 'Fituesi: ${winner!.shortName}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalVotes;
  final int totalSeats;
  final int subjectsCount;
  final PartyResult? winner;

  const _SummaryCard({
    required this.totalVotes,
    required this.totalSeats,
    required this.subjectsCount,
    required this.winner,
  });

  @override
  Widget build(BuildContext context) {
    final votes = AppFormatters.number(totalVotes);
    final winnerPercent =
        winner == null ? '—' : AppFormatters.percent(winner!.percentage);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          children: [
            Row(
              children: [
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
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryItem(
                    label: 'Mandate',
                    value: '$totalSeats',
                    icon: Icons.event_seat_rounded,
                  ),
                ),
              ],
            ),
            if (winner != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFABEFC6)),
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
                        '${winner!.shortName} kryeson me $winnerPercent',
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
              fontSize: 11.5,
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
  final ResultSortMode sortMode;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ResultSortMode?> onSortChanged;

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
                hintText: 'Kërko subjektin politik...',
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
            DropdownButtonFormField<ResultSortMode>(
              value: sortMode,
              decoration: const InputDecoration(
                labelText: 'Renditja',
              ),
              items: const [
                DropdownMenuItem(
                  value: ResultSortMode.votes,
                  child: Text('Sipas votave'),
                ),
                DropdownMenuItem(
                  value: ResultSortMode.percentage,
                  child: Text('Sipas përqindjes'),
                ),
                DropdownMenuItem(
                  value: ResultSortMode.seats,
                  child: Text('Sipas mandateve'),
                ),
                DropdownMenuItem(
                  value: ResultSortMode.name,
                  child: Text('Sipas emrit'),
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
  final ResultSortMode sortMode;

  const _ListHeader({
    required this.count,
    required this.sortMode,
  });

  @override
  Widget build(BuildContext context) {
    final sortLabel = switch (sortMode) {
      ResultSortMode.votes => 'sipas votave',
      ResultSortMode.percentage => 'sipas përqindjes',
      ResultSortMode.seats => 'sipas mandateve',
      ResultSortMode.name => 'sipas emrit',
    };

    return Row(
      children: [
        Expanded(
          child: Text(
            '$count subjekte • $sortLabel',
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

class _PartyResultCard extends StatelessWidget {
  final int rank;
  final PartyResult result;

  const _PartyResultCard({
    required this.rank,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final votes = AppFormatters.number(result.votes);
    final percent = AppFormatters.percent(result.percentage);

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
                    result.shortName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      minHeight: 7,
                      value: (result.percentage / 100).clamp(0, 1),
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
                        icon: Icons.percent_rounded,
                        label: percent,
                      ),
                      PremiumInfoChip(
                        icon: Icons.event_seat_rounded,
                        label: '${result.seats} mandate',
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

