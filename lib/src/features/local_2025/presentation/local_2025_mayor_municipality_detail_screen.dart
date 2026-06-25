import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../data/local_2025_mayor_data.dart';
import '../data/local_2025_mayor_models.dart';

class Local2025MayorMunicipalityDetailScreen extends StatelessWidget {
  final String municipalityName;

  const Local2025MayorMunicipalityDetailScreen({
    super.key,
    required this.municipalityName,
  });

  @override
  Widget build(BuildContext context) {
    final municipality = Local2025MayorData.forMunicipality(municipalityName);

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
          municipality.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
        children: [
          _WinnerHero(municipality: municipality),
          const SizedBox(height: 14),
          _RoundSection(
            title: 'Raundi i parë',
            candidates: municipality.firstRound,
            winnerName: municipality.decidedInRunoff
                ? null
                : municipality.winner.fullName,
          ),
          if (municipality.secondRound.isNotEmpty) ...[
            const SizedBox(height: 14),
            _RoundSection(
              title: 'Balotazhi · Raundi i dytë',
              candidates: municipality.secondRound,
              winnerName: municipality.winner.fullName,
            ),
          ],
        ],
      ),
    );
  }
}

class _WinnerHero extends StatelessWidget {
  final Local2025MayorMunicipality municipality;

  const _WinnerHero({required this.municipality});

  @override
  Widget build(BuildContext context) {
    final winner = municipality.winner;
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
          const Icon(Icons.emoji_events_rounded, color: Color(0xFFD6A84B), size: 36),
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
            municipality.decidedInRunoff
                ? 'Kryetari i zgjedhur në balotazh'
                : 'Kryetari i zgjedhur në raundin e parë',
            style: const TextStyle(
              color: Color(0xFFEAF2FF),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
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
        ],
      ),
    );
  }
}

class _RoundSection extends StatelessWidget {
  final String title;
  final List<Local2025MayorCandidate> candidates;
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
