import 'package:flutter/material.dart';

import '../../../core/models/municipality_party_result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../parliamentary_2021/data/parliamentary_2021_municipality_party_data.dart';

class Parliamentary2021MunicipalityDetailScreen extends StatefulWidget {
  final String municipalityName;

  const Parliamentary2021MunicipalityDetailScreen({
    super.key,
    required this.municipalityName,
  });

  @override
  State<Parliamentary2021MunicipalityDetailScreen> createState() =>
      _Parliamentary2021MunicipalityDetailScreenState();
}

class _Parliamentary2021MunicipalityDetailScreenState
    extends State<Parliamentary2021MunicipalityDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  List<MunicipalityPartyResult> get _allResults {
    return Parliamentary2021MunicipalityPartyData.forMunicipality(
      widget.municipalityName,
    );
  }

  List<MunicipalityPartyResult> get _visibleResults {
    final query = _normalizeSearchText(_query);

    if (query.isEmpty) return _allResults;

    return _allResults.where((item) {
      final searchable = _normalizeSearchText(
        '${item.subjectName} ${item.shortName} ${item.subjectCode}',
      );

      return searchable.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allResults = _allResults;
    final visibleResults = _visibleResults;
    final totalVotes = allResults.fold<int>(
      0,
      (sum, item) => sum + item.votes,
    );
    final winner = allResults.isEmpty ? null : allResults.first;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          widget.municipalityName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
        children: [
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_city_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.municipalityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Parlamentare 2021 · Rezultatet sipas subjekteve',
                  style: TextStyle(
                    color: Color(0xFFEAF2FF),
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeaderChip(
                      icon: Icons.how_to_vote_rounded,
                      label: '${AppFormatters.number(totalVotes)} vota',
                    ),
                    _HeaderChip(
                      icon: Icons.groups_rounded,
                      label: '${allResults.length} subjekte',
                    ),
                  ],
                ),
                if (winner != null) ...[
                  const SizedBox(height: 13),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          color: AppTheme.winnerGold,
                          size: 22,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Fituesi: ${winner.shortName} · '
                            '${AppFormatters.number(winner.votes)} vota · '
                            '${AppFormatters.percent(winner.percentage)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.8,
                              fontWeight: FontWeight.w900,
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
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Kërko subjektin...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _query = '';
                            });
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...visibleResults.map(
            (result) => _PartyCard(result: result),
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderChip({
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
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PartyCard extends StatelessWidget {
  final MunicipalityPartyResult result;

  const _PartyCard({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final isWinner = result.rank == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: isWinner ? const Color(0xFFF1F6FD) : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 38,
              width: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isWinner
                    ? AppTheme.softNavy
                    : const Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                '${result.rank}',
                style: TextStyle(
                  color: isWinner
                      ? AppTheme.primaryNavy
                      : AppTheme.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          result.subjectName,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (isWinner) ...[
                        const SizedBox(width: 7),
                        const Icon(
                          Icons.emoji_events_rounded,
                          color: AppTheme.winnerGold,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${result.subjectCode} · ${result.shortName}',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${AppFormatters.number(result.votes)} vota',
                          style: const TextStyle(
                            color: AppTheme.primaryNavy,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        AppFormatters.percent(result.percentage),
                        style: const TextStyle(
                          color: AppTheme.accentBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
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
