import 'package:flutter/material.dart';

import '../../../core/models/candidate_result.dart';
import '../../../core/models/party_result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../results/data/election_repository.dart';

class Local2017MunicipalityDetailScreen extends StatefulWidget {
  final String municipality;

  const Local2017MunicipalityDetailScreen({
    super.key,
    required this.municipality,
  });

  @override
  State<Local2017MunicipalityDetailScreen> createState() =>
      _Local2017MunicipalityDetailScreenState();
}

class _Local2017MunicipalityDetailScreenState
    extends State<Local2017MunicipalityDetailScreen> {
  final ElectionRepository _repository = const ElectionRepository();

  late Future<_MunicipalityBundle> _bundleFuture;

  @override
  void initState() {
    super.initState();
    _bundleFuture = _loadBundle();
  }

  String _municipalityFromPartyResult(PartyResult result) {
    const separator = ' · ';
    final index = result.name.indexOf(separator);
    if (index <= 0) return '';
    return result.name.substring(0, index).trim();
  }

  String _subjectName(PartyResult result) {
    const separator = ' · ';
    final index = result.name.indexOf(separator);
    if (index < 0 || index + separator.length >= result.name.length) {
      return result.name;
    }
    return result.name.substring(index + separator.length).trim();
  }

  Future<_MunicipalityBundle> _loadBundle() async {
    final partyResults = await _repository.getPartyResults();
    final candidates = await _repository.getCandidateResults();

    final filteredResults = partyResults
        .where(
          (item) =>
              _municipalityFromPartyResult(item) == widget.municipality,
        )
        .toList()
      ..sort((a, b) => b.votes.compareTo(a.votes));

    final filteredCandidates = candidates
        .where(
          (item) => item.municipalityName.trim() == widget.municipality,
        )
        .toList()
      ..sort((a, b) => b.votes.compareTo(a.votes));

    return _MunicipalityBundle(
      partyResults: filteredResults,
      candidates: filteredCandidates,
    );
  }

  void _refresh() {
    setState(() {
      _bundleFuture = _loadBundle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text(
            widget.municipality,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              tooltip: 'Përditëso',
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.account_balance_rounded),
                text: 'Subjektet',
              ),
              Tab(
                icon: Icon(Icons.groups_rounded),
                text: 'Kandidatët',
              ),
            ],
          ),
        ),
        body: FutureBuilder<_MunicipalityBundle>(
          future: _bundleFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _MessageState(
                icon: Icons.error_outline_rounded,
                title: 'Të dhënat nuk u ngarkuan',
                message: 'Provo përsëri.',
                actionLabel: 'Përditëso',
                onPressed: _refresh,
              );
            }

            final bundle = snapshot.data ??
                const _MunicipalityBundle(
                  partyResults: <PartyResult>[],
                  candidates: <CandidateResult>[],
                );

            return Column(
              children: [
                _MunicipalityHeader(
                  municipality: widget.municipality,
                  partyResults: bundle.partyResults,
                  candidates: bundle.candidates,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _PartyResultsTab(
                        results: bundle.partyResults,
                        subjectName: _subjectName,
                      ),
                      _CandidatesTab(candidates: bundle.candidates),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MunicipalityHeader extends StatelessWidget {
  final String municipality;
  final List<PartyResult> partyResults;
  final List<CandidateResult> candidates;

  const _MunicipalityHeader({
    required this.municipality,
    required this.partyResults,
    required this.candidates,
  });

  @override
  Widget build(BuildContext context) {
    final totalVotes = partyResults.fold<int>(
      0,
      (sum, item) => sum + item.votes,
    );
    final totalSeats = partyResults.fold<int>(
      0,
      (sum, item) => sum + item.seats,
    );
    final winner = partyResults.isEmpty ? null : partyResults.first;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.all(18),
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
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppTheme.greenShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_city_rounded,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            municipality,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Zgjedhjet Lokale 2017 · Kuvendi Komunal',
            style: TextStyle(
              color: Color(0xFFEAF7F0),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeaderPill(
                icon: Icons.account_balance_rounded,
                label: '${partyResults.length} subjekte',
              ),
              _HeaderPill(
                icon: Icons.how_to_vote_rounded,
                label: '${AppFormatters.number(totalVotes)} vota',
              ),
              _HeaderPill(
                icon: Icons.event_seat_rounded,
                label: '$totalSeats mandate',
              ),
              _HeaderPill(
                icon: Icons.groups_rounded,
                label: '${candidates.length} kandidatë',
              ),
            ],
          ),
          if (winner != null) ...[
            const SizedBox(height: 13),
            Text(
              'Subjekti kryesues: ${winner.shortName} · '
              '${AppFormatters.number(winner.votes)} vota',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PartyResultsTab extends StatelessWidget {
  final List<PartyResult> results;
  final String Function(PartyResult result) subjectName;

  const _PartyResultsTab({
    required this.results,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const _MessageState(
        icon: Icons.inbox_outlined,
        title: 'Nuk ka rezultate',
        message: 'Për këtë komunë nuk u gjetën rezultate.',
      );
    }

    final maxVotes = results.first.votes;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final progress =
            maxVotes <= 0 ? 0.0 : result.votes / maxVotes;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RankBadge(rank: index + 1),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subjectName(result),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            result.shortName,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${result.seats}',
                      style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: AppTheme.softGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppFormatters.number(result.votes)} vota',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      AppFormatters.percent(result.percentage),
                      style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${result.seats} mandate',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CandidatesTab extends StatelessWidget {
  final List<CandidateResult> candidates;

  const _CandidatesTab({
    required this.candidates,
  });

  @override
  Widget build(BuildContext context) {
    if (candidates.isEmpty) {
      return const _MessageState(
        icon: Icons.person_search_rounded,
        title: 'Nuk ka kandidatë',
        message: 'Për këtë komunë nuk u gjetën kandidatë.',
      );
    }

    final maxVotes = candidates.first.votes;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        final candidate = candidates[index];
        final progress =
            maxVotes <= 0 ? 0.0 : candidate.votes / maxVotes;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RankBadge(rank: index + 1),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.fullName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        candidate.subjectName,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 7,
                          backgroundColor: AppTheme.softGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppFormatters.number(candidate.votes),
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;

  const _RankBadge({
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: rank == 1 ? AppTheme.softGreen : const Color(0xFFF2F5F3),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        '$rank',
        style: TextStyle(
          color: rank == 1 ? AppTheme.primaryGreen : AppTheme.textDark,
          fontSize: 13.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onPressed;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: AppTheme.primaryGreen),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (actionLabel != null && onPressed != null) ...[
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MunicipalityBundle {
  final List<PartyResult> partyResults;
  final List<CandidateResult> candidates;

  const _MunicipalityBundle({
    required this.partyResults,
    required this.candidates,
  });
}
