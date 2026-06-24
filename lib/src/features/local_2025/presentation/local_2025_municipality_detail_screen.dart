import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../data/local_2025_assembly_candidate_data.dart';
import '../data/local_2025_assembly_data.dart';
import '../data/local_2025_assembly_party_data.dart';

class Local2025MunicipalityDetailScreen extends StatelessWidget {
  final String municipalityName;
  const Local2025MunicipalityDetailScreen({super.key, required this.municipalityName});

  @override
  Widget build(BuildContext context) {
    final statistics = Local2025AssemblyData.statisticsFor(municipalityName);
    final parties = Local2025AssemblyPartyData.forMunicipality(municipalityName);
    final elected = Local2025AssemblyCandidateData.electedForMunicipality(municipalityName);
    final winner = parties.isEmpty ? null : parties.first;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(municipalityName, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF102A43), Color(0xFF1559A8), Color(0xFF0B2137)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppTheme.greenShadow,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.account_balance_rounded, color: Colors.white, size: 34),
              const SizedBox(height: 10),
              Text(municipalityName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const Text('Kuvendi i Komunës 2025 · Rezultatet zyrtare të KQZ', style: TextStyle(color: Color(0xFFEAF2FF), fontWeight: FontWeight.w700)),
              if (winner != null) ...[
                const SizedBox(height: 12),
                Text('Subjekti i parë: ${winner.subjectName} · ${winner.seats} mandate · ${AppFormatters.number(winner.votes)} vota', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ],
            ]),
          ),
          if (statistics != null) ...[
            const SizedBox(height: 12),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Statistikat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              _StatRow('Votues në listë', AppFormatters.number(statistics.electorate)),
              _StatRow('Kanë votuar', AppFormatters.number(statistics.votersTotal)),
              _StatRow('Pjesëmarrja', AppFormatters.percent(statistics.turnout)),
              _StatRow('Fletëvotime të vlefshme', AppFormatters.number(statistics.validBallots)),
              _StatRow('Të pavlefshme dhe të zbrazëta', AppFormatters.number(statistics.invalidAndBlankBallots)),
              _StatRow('Vende në kuvend', '${statistics.assemblySeats}'),
            ]))),
          ],
          const SizedBox(height: 12),
          const Text('Subjektet dhe mandatet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF172B4D))),
          const SizedBox(height: 8),
          ...parties.map((p) => Card(child: ListTile(
            leading: CircleAvatar(child: Text('${p.seats}')),
            title: Text(p.subjectName, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('${AppFormatters.number(p.votes)} vota · ${AppFormatters.percent(p.percentage)}'),
            trailing: Text('${p.seats} mandate', style: const TextStyle(fontWeight: FontWeight.w900)),
          ))),
          const SizedBox(height: 14),
          const Text('Kandidatët e zgjedhur', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF172B4D))),
          const SizedBox(height: 8),
          ...elected.map((c) => Card(child: ListTile(
            leading: CircleAvatar(child: Text('${c.rank}')),
            title: Text(c.fullName, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('${c.subjectName} · ${c.gender == 'F' ? 'F' : 'M'}'),
            trailing: Text(AppFormatters.number(c.votes), style: const TextStyle(fontWeight: FontWeight.w900)),
          ))),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label; final String value;
  const _StatRow(this.label, this.value);
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))]),
  );
}
