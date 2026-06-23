import 'package:flutter/material.dart';

import '../../../core/models/candidate_result.dart';
import '../../../core/models/party_result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../results/data/election_repository.dart';

enum _PartySortMode {
  votes,
  seats,
  name,
}

enum _CandidateSortMode {
  votes,
  name,
  subject,
}

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
  final TextEditingController _partySearchController =
      TextEditingController();
  final TextEditingController _candidateSearchController =
      TextEditingController();

  late Future<_MunicipalityBundle> _bundleFuture;

  _PartySortMode _partySortMode = _PartySortMode.votes;
  _CandidateSortMode _candidateSortMode = _CandidateSortMode.votes;

  String _partyQuery = '';
  String _candidateQuery = '';

  @override
  void initState() {
    super.initState();
    _bundleFuture = _loadBundle();
  }

  @override
  void dispose() {
    _partySearchController.dispose();
    _candidateSearchController.dispose();
    super.dispose();
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
        .toList();

    final filteredCandidates = candidates
        .where(
          (item) => item.municipalityName.trim() == widget.municipality,
        )
        .toList();

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

  List<PartyResult> _visiblePartyResults(List<PartyResult> source) {
    final query = _partyQuery.trim().toLowerCase();

    final results = source.where((item) {
      if (query.isEmpty) return true;
      return _subjectName(item).toLowerCase().contains(query) ||
          item.shortName.toLowerCase().contains(query);
    }).toList();

    switch (_partySortMode) {
      case _PartySortMode.votes:
        results.sort((a, b) => b.votes.compareTo(a.votes));
      case _PartySortMode.seats:
        results.sort((a, b) {
          final seats = b.seats.compareTo(a.seats);
          return seats != 0 ? seats : b.votes.compareTo(a.votes);
        });
      case _PartySortMode.name:
        results.sort(
          (a, b) => _subjectName(a).toLowerCase().compareTo(
                _subjectName(b).toLowerCase(),
              ),
        );
    }

    return results;
  }

  List<CandidateResult> _visibleCandidates(
    List<CandidateResult> source,
  ) {
    final query = _candidateQuery.trim().toLowerCase();

    final results = source.where((item) {
      if (query.isEmpty) return true;
      return item.fullName.toLowerCase().contains(query) ||
          item.subjectName.toLowerCase().contains(query);
    }).toList();

    switch (_candidateSortMode) {
      case _CandidateSortMode.votes:
        results.sort((a, b) => b.votes.compareTo(a.votes));
      case _CandidateSortMode.name:
        results.sort(
          (a, b) => a.fullName.toLowerCase().compareTo(
                b.fullName.toLowerCase(),
              ),
        );
      case _CandidateSortMode.subject:
        results.sort((a, b) {
          final subject = a.subjectName.toLowerCase().compareTo(
                b.subjectName.toLowerCase(),
              );
          return subject != 0 ? subject : b.votes.compareTo(a.votes);
        });
    }

    return results;
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

            final visibleParties =
                _visiblePartyResults(bundle.partyResults);
            final visibleCandidates =
                _visibleCandidates(bundle.candidates);

            return Column(
              children: [
                _MunicipalityHeader(
                  municipality: widget.municipality,
                  partyResults: bundle.partyResults,
                  candidates: bundle.candidates,
                  subjectName: _subjectName,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _PartyResultsTab(
                        results: visibleParties,
                        subjectName: _subjectName,
                        searchController: _partySearchController,
                        query: _partyQuery,
                        sortMode: _partySortMode,
                        onQueryChanged: (value) {
                          setState(() {
                            _partyQuery = value;
                          });
                        },
                        onSortChanged: (value) {
                          setState(() {
                            _partySortMode = value;
                          });
                        },
                      ),
                      _CandidatesTab(
                        candidates: visibleCandidates,
                        searchController: _candidateSearchController,
                        query: _candidateQuery,
                        sortMode: _candidateSortMode,
                        onQueryChanged: (value) {
                          setState(() {
                            _candidateQuery = value;
                          });
                        },
                        onSortChanged: (value) {
                          setState(() {
                            _candidateSortMode = value;
                          });
                        },
                      ),
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
  final String Function(PartyResult result) subjectName;

  const _MunicipalityHeader({
    required this.municipality,
    required this.partyResults,
    required this.candidates,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    final sortedParties = [...partyResults]
      ..sort((a, b) => b.votes.compareTo(a.votes));

    final totalVotes = partyResults.fold<int>(
      0,
      (sum, item) => sum + item.votes,
    );
    final totalSeats = partyResults.fold<int>(
      0,
      (sum, item) => sum + item.seats,
    );
    final winner = sortedParties.isEmpty ? null : sortedParties.first;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      padding: const EdgeInsets.all(17),
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.greenShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_city_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      municipality,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Zgjedhjet Lokale 2017 · Kuvendi Komunal',
                      style: TextStyle(
                        color: Color(0xFFEAF7F0),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 7,
            runSpacing: 7,
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
            const SizedBox(height: 11),
            Text(
              'Kryeson: ${subjectName(winner)} · '
              '${AppFormatters.number(winner.votes)} vota',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.7,
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
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
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.2,
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
  final TextEditingController searchController;
  final String query;
  final _PartySortMode sortMode;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<_PartySortMode> onSortChanged;

  const _PartyResultsTab({
    required this.results,
    required this.subjectName,
    required this.searchController,
    required this.query,
    required this.sortMode,
    required this.onQueryChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchAndSortBar(
          controller: searchController,
          hintText: 'Kërko subjektin',
          query: query,
          onChanged: onQueryChanged,
          sortLabel: switch (sortMode) {
            _PartySortMode.votes => 'Votat',
            _PartySortMode.seats => 'Mandatet',
            _PartySortMode.name => 'Emri',
          },
          sortItems: const [
            PopupMenuItem(
              value: _PartySortMode.votes,
              child: Text('Sipas votave'),
            ),
            PopupMenuItem(
              value: _PartySortMode.seats,
              child: Text('Sipas mandateve'),
            ),
            PopupMenuItem(
              value: _PartySortMode.name,
              child: Text('Sipas emrit'),
            ),
          ],
          onSelected: onSortChanged,
        ),
        Expanded(
          child: results.isEmpty
              ? const _MessageState(
                  icon: Icons.inbox_outlined,
                  title: 'Nuk ka rezultate',
                  message:
                      'Nuk u gjet asnjë subjekt për kërkimin e zgjedhur.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 22),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 9),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 11,
                        ),
                        child: Row(
                          children: [
                            _RankBadge(rank: index + 1),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subjectName(result),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 14.2,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppFormatters.number(result.votes)} vota · '
                                    '${AppFormatters.percent(result.percentage)}',
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 12.2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            _SeatBadge(seats: result.seats),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CandidatesTab extends StatelessWidget {
  final List<CandidateResult> candidates;
  final TextEditingController searchController;
  final String query;
  final _CandidateSortMode sortMode;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<_CandidateSortMode> onSortChanged;

  const _CandidatesTab({
    required this.candidates,
    required this.searchController,
    required this.query,
    required this.sortMode,
    required this.onQueryChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchAndSortBar(
          controller: searchController,
          hintText: 'Kërko kandidatin ose subjektin',
          query: query,
          onChanged: onQueryChanged,
          sortLabel: switch (sortMode) {
            _CandidateSortMode.votes => 'Votat',
            _CandidateSortMode.name => 'Emri',
            _CandidateSortMode.subject => 'Subjekti',
          },
          sortItems: const [
            PopupMenuItem(
              value: _CandidateSortMode.votes,
              child: Text('Sipas votave'),
            ),
            PopupMenuItem(
              value: _CandidateSortMode.name,
              child: Text('Sipas emrit'),
            ),
            PopupMenuItem(
              value: _CandidateSortMode.subject,
              child: Text('Sipas subjektit'),
            ),
          ],
          onSelected: onSortChanged,
        ),
        Expanded(
          child: candidates.isEmpty
              ? const _MessageState(
                  icon: Icons.person_search_rounded,
                  title: 'Nuk ka kandidatë',
                  message:
                      'Nuk u gjet asnjë kandidat për kërkimin e zgjedhur.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 22),
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = candidates[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 9),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 11,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _RankBadge(rank: index + 1),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    candidate.fullName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 14.2,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    candidate.subjectName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 12.1,
                                      fontWeight: FontWeight.w700,
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
                                fontSize: 14.4,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SearchAndSortBar<T> extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String query;
  final ValueChanged<String> onChanged;
  final String sortLabel;
  final List<PopupMenuEntry<T>> sortItems;
  final ValueChanged<T> onSelected;

  const _SearchAndSortBar({
    required this.controller,
    required this.hintText,
    required this.query,
    required this.onChanged,
    required this.sortLabel,
    required this.sortItems,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Pastro',
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          PopupMenuButton<T>(
            tooltip: 'Rendit',
            onSelected: onSelected,
            itemBuilder: (_) => sortItems,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.softGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    sortLabel,
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 12.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
      height: 34,
      width: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: rank == 1 ? AppTheme.softGreen : const Color(0xFFF2F5F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$rank',
        style: TextStyle(
          color: rank == 1 ? AppTheme.primaryGreen : AppTheme.textDark,
          fontSize: 12.8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SeatBadge extends StatelessWidget {
  final int seats;

  const _SeatBadge({
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 44),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Text(
            '$seats',
            style: const TextStyle(
              color: AppTheme.primaryGreen,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'mandate',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
