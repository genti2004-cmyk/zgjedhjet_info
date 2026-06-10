import 'package:flutter/material.dart';

import '../../../core/models/election_source.dart';
import '../../../core/models/party_result.dart';
import '../../../core/services/selected_election_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_state_cards.dart';
import '../../../core/widgets/election_picker_card.dart';
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
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2014;
  }

  bool _hasRegisteredSourcesOnly(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2010;
  }

  String _emptyMessage(ElectionSource source) {
    if (_hasRegisteredSourcesOnly(source)) {
      return 'Burimet zyrtare për ${source.shortTitle} janë regjistruar. Rezultatet do të shfaqen pasi skedarët e KQZ të verifikohen plotësisht.';
    }

    return 'Nuk ka ende rezultate për t’u shfaqur.';
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
                    _OfficialDataNotice(
                      source: selectedElection,
                      isOfficial: _hasOfficialResults(selectedElection),
                      isSourceOnly: _hasRegisteredSourcesOnly(selectedElection),
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
        ? 'KQZ të dhëna aktive'
        : isSourceOnly
            ? 'Burime zyrtare'
            : 'Në përgatitje';

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
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Rezultatet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
              _HeaderStatusPill(label: status, isOfficial: isOfficial),
            ],
          ),
          const SizedBox(height: 16),
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
              color: Color(0xFFEAF7F0),
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
              _WhitePill(
                icon: Icons.calendar_month_rounded,
                label: source.dateLabel,
              ),
              _WhitePill(
                icon: Icons.emoji_events_rounded,
                label: winner == null ? 'Pa rezultate' : 'Fitues: ${winner!.shortName}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStatusPill extends StatelessWidget {
  final String label;
  final bool isOfficial;

  const _HeaderStatusPill({
    required this.label,
    required this.isOfficial,
  });

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOfficial ? Icons.verified_rounded : Icons.info_outline_rounded,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

class _OfficialDataNotice extends StatelessWidget {
  final ElectionSource source;
  final bool isOfficial;
  final bool isSourceOnly;

  const _OfficialDataNotice({
    required this.source,
    required this.isOfficial,
    required this.isSourceOnly,
  });

  @override
  Widget build(BuildContext context) {
    final message = isOfficial
        ? 'Për ${source.shortTitle} shfaqen rezultatet e subjekteve politike, votat, përqindjet dhe mandatet nga dokumentet zyrtare të KQZ.'
        : isSourceOnly
            ? 'Për ${source.shortTitle} burimet zyrtare të KQZ janë regjistruar. Rezultatet nuk shfaqen ende, sepse skedarët duhet të verifikohen plotësisht.'
            : 'Për ${source.shortTitle} lidhja reale me rezultatet e KQZ është ende në përgatitje. Aktualisht shfaqen të dhëna strukturore/testuese.';

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
                color: isOfficial ? const Color(0xFF067647) : const Color(0xFF7A4B00),
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
                      _InfoChip(
                        icon: Icons.how_to_vote_rounded,
                        label: '$votes vota',
                      ),
                      _InfoChip(
                        icon: Icons.percent_rounded,
                        label: percent,
                      ),
                      _InfoChip(
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
