import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../data/historical_mayor_2017_data.dart';
import '../data/historical_mayor_2021_data.dart';
import '../data/historical_mayor_models.dart';

class HistoricalMayorMunicipalityDetailScreen extends StatelessWidget {
  final int year;
  final String municipalityName;

  const HistoricalMayorMunicipalityDetailScreen({
    super.key,
    required this.year,
    required this.municipalityName,
  });

  @override
  Widget build(BuildContext context) {
    final municipality = year == 2021
        ? HistoricalMayor2021Data.forMunicipality(municipalityName)
        : HistoricalMayor2017Data.forMunicipality(municipalityName);

    if (municipality == null) {
      return Scaffold(
        appBar: AppBar(title: Text(municipalityName)),
        body: const Center(child: Text('Nuk u gjetën të dhëna për këtë komunë.')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          '${municipality.name} · ${municipality.year}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
        children: [
          _StatusHero(municipality: municipality),
          const SizedBox(height: 14),
          _RoundSection(
            title: 'Raundi i parë',
            candidates: municipality.firstRound,
            winnerName: municipality.decidedInRunoff
                ? null
                : municipality.winner?.fullName,
          ),
          if (municipality.secondRound.isNotEmpty) ...[
            const SizedBox(height: 14),
            _RoundSection(
              title: 'Balotazhi · Raundi i dytë',
              candidates: municipality.secondRound,
              winnerName: municipality.winner?.fullName,
            ),
          ],
          if (!municipality.finalResultComplete) ...[
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Për këtë komunë janë importuar rezultatet zyrtare të raundit të parë. Rezultati përfundimtar i balotazhit 2017 nuk është përfshirë ende, sepse skedari përkatës nuk është dorëzuar.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusHero extends StatelessWidget {
  final HistoricalMayorMunicipality municipality;

  const _StatusHero({required this.municipality});

  @override
  Widget build(BuildContext context) {
    final winner = municipality.winner;
    final hasFinalWinner = winner != null && municipality.finalResultComplete;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF102A43), Color(0xFF1559A8), Color(0xFF0B2137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.greenShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            hasFinalWinner
                ? Icons.emoji_events_rounded
                : Icons.how_to_vote_rounded,
            color: hasFinalWinner
                ? const Color(0xFFD6A84B)
                : Colors.white,
            size: 36,
          ),
          const SizedBox(height: 10),
          Text(
            municipality.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasFinalWinner
                ? (municipality.decidedInRunoff
                    ? 'Kryetari i zgjedhur në balotazh'
                    : 'Kryetari i zgjedhur në raundin e parë')
                : 'Rezultati i raundit të parë',
            style: const TextStyle(
              color: Color(0xFFEAF2FF),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          if (winner != null) ...[
            Text(
              winner.fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              winner.subjectName,
              style: const TextStyle(
                color: Color(0xFFEAF2FF),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${AppFormatters.number(winner.votes)} vota · ${AppFormatters.percent(winner.percentage)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ] else ...[
            Text(
              municipality.firstRound.first.fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Kandidati i parë në raundin e parë · balotazhi ende i paimportuar',
              style: TextStyle(
                color: Color(0xFFEAF2FF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RoundSection extends StatelessWidget {
  final String title;
  final List<HistoricalMayorCandidate> candidates;
  final String? winnerName;

  const _RoundSection({
    required this.title,
    required this.candidates,
    required this.winnerName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        ...candidates.map((candidate) {
          final isWinner = candidate.fullName == winnerName;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isWinner
                    ? const Color(0xFFFFF4D6)
                    : const Color(0xFFEAF2FF),
                child: Icon(
                  isWinner ? Icons.emoji_events_rounded : Icons.person_rounded,
                  color: isWinner
                      ? const Color(0xFFD6A84B)
                      : const Color(0xFF1559A8),
                ),
              ),
              title: Text(
                candidate.fullName,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text(candidate.subjectName),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppFormatters.number(candidate.votes),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(AppFormatters.percent(candidate.percentage)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
