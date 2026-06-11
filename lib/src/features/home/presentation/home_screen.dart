import 'package:flutter/material.dart';

import '../../../core/models/candidate_result.dart';
import '../../../core/models/election.dart';
import '../../../core/models/election_source.dart';
import '../../../core/services/election_data_status.dart';
import '../../../core/models/party_result.dart';
import '../../../core/services/selected_election_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/election_picker_card.dart';
import '../../../core/widgets/premium_components.dart';
import '../../results/data/election_repository.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  static const String appName = 'Zgjedhjet Info';
  static const String subtitle =
      'Rezultatet dhe informacionet zgjedhore në një vend';

  static const String disclaimer =
      'Burimi i të dhënave: KQZ. Ky aplikacion nuk është aplikacion zyrtar i KQZ-së.';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ElectionRepository _repository = const ElectionRepository();

  late Future<Election> _electionFuture;
  late Future<List<PartyResult>> _partyResultsFuture;
  late Future<List<CandidateResult>> _candidateResultsFuture;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    _electionFuture = _repository.getCurrentElection();
    _partyResultsFuture = _repository.getPartyResults();
    _candidateResultsFuture = _repository.getCandidateResults();
  }

  void _refresh() {
    setState(_loadDashboard);
  }

  void _goToTab(int index) {
    widget.onNavigateTab?.call(index);
  }

  int _totalSeats(List<PartyResult> parties) {
    return parties.fold<int>(0, (sum, item) => sum + item.seats);
  }

  int _totalVotes(List<PartyResult> parties) {
    return parties.fold<int>(0, (sum, item) => sum + item.votes);
  }

  bool _hasOfficialPartyData(ElectionSource source) {
    return ElectionDataStatus.hasOfficialPartyResults(source);
  }

  bool _hasOfficialCandidateData(ElectionSource source) {
    return ElectionDataStatus.hasOfficialElectedCandidates(source);
  }

  bool _sourceOnly(ElectionSource source) {
    return ElectionDataStatus.isSourceOnly(source);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ElectionSource>(
      valueListenable: SelectedElectionController.selectedElection,
      builder: (context, selectedSource, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: FutureBuilder<Election>(
              future: _electionFuture,
              builder: (context, electionSnapshot) {
                final election = electionSnapshot.data;

                return RefreshIndicator(
                  onRefresh: () async {
                    _refresh();
                    await Future.wait([
                      _electionFuture,
                      _partyResultsFuture,
                      _candidateResultsFuture,
                    ]);
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _PremiumHero(
                          election: election,
                          source: selectedSource,
                          isOfficial: _hasOfficialPartyData(selectedSource),
                          isSourceOnly: _sourceOnly(selectedSource),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              ElectionPickerCard(onChanged: _refresh),
                              const SizedBox(height: 14),
                              _StatusStrip(
                                hasPartyData: _hasOfficialPartyData(selectedSource),
                                hasCandidateData:
                                    _hasOfficialCandidateData(selectedSource),
                                isSourceOnly: _sourceOnly(selectedSource),
                                source: selectedSource,
                              ),
                              const SizedBox(height: 16),
                              FutureBuilder<List<PartyResult>>(
                                future: _partyResultsFuture,
                                builder: (context, partySnapshot) {
                                  final parties =
                                      partySnapshot.data ?? const <PartyResult>[];

                                  return FutureBuilder<List<CandidateResult>>(
                                    future: _candidateResultsFuture,
                                    builder: (context, candidateSnapshot) {
                                      final candidates =
                                          candidateSnapshot.data ??
                                              const <CandidateResult>[];

                                      return _PremiumStatsGrid(
                                        partiesCount: parties.length,
                                        candidatesCount: candidates.length,
                                        totalSeats: _totalSeats(parties),
                                        totalVotes: _totalVotes(parties),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 22),
                              _QuickAccessPanel(
                                onArchiveTap: () => _goToTab(1),
                                onResultsTap: () => _goToTab(2),
                                onMunicipalitiesTap: () => _goToTab(3),
                                onCandidatesTap: () => _goToTab(4),
                                onSourcesTap: () => _goToTab(5),
                              ),
                              const SizedBox(height: 22),
                              PremiumSectionHeader(
                                title: 'Modulet',
                                subtitle: 'Hap shpejt pjesët kryesore të app-it.',
                              ),
                              const SizedBox(height: 12),
                              _ModuleList(
                                onArchiveTap: () => _goToTab(1),
                                onResultsTap: () => _goToTab(2),
                                onMunicipalitiesTap: () => _goToTab(3),
                                onCandidatesTap: () => _goToTab(4),
                                onSourcesTap: () => _goToTab(5),
                              ),
                              const SizedBox(height: 18),
                              const _SourceInfoCard(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _PremiumHero extends StatelessWidget {
  final Election? election;
  final ElectionSource source;
  final bool isOfficial;
  final bool isSourceOnly;

  const _PremiumHero({
    required this.election,
    required this.source,
    required this.isOfficial,
    required this.isSourceOnly,
  });

  @override
  Widget build(BuildContext context) {
    final title = election?.title ?? source.title;
    final status = election?.status ?? 'Në pritje';
    final date =
        election == null ? source.dateLabel : AppFormatters.date(election!.date);

    final statusText = isOfficial
        ? 'KQZ të dhëna aktive'
        : isSourceOnly
            ? 'Burime zyrtare'
            : 'Në përgatitje';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
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
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppTheme.greenShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
                child: const Icon(
                  Icons.how_to_vote_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  HomeScreen.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
              _HeroStatusPill(
                label: statusText,
                isOfficial: isOfficial,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            HomeScreen.subtitle,
            style: TextStyle(
              fontSize: 14.8,
              fontWeight: FontWeight.w700,
              color: Color(0xFFEAF7F0),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.shortTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.5,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFEAF7F0),
                    fontSize: 13.3,
                    fontWeight: FontWeight.w700,
                    height: 1.32,
                  ),
                ),
                const SizedBox(height: 11),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _WhitePill(
                      icon: Icons.calendar_month_rounded,
                      label: date,
                    ),
                    _WhitePill(
                      icon: Icons.info_outline_rounded,
                      label: status,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStatusPill extends StatelessWidget {
  final String label;
  final bool isOfficial;

  const _HeroStatusPill({
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

class _StatusStrip extends StatelessWidget {
  final bool hasPartyData;
  final bool hasCandidateData;
  final bool isSourceOnly;
  final ElectionSource source;

  const _StatusStrip({
    required this.hasPartyData,
    required this.hasCandidateData,
    required this.isSourceOnly,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final isOfficial = hasPartyData || hasCandidateData;

    final title = isOfficial
        ? 'Të dhëna të verifikuara'
        : isSourceOnly
            ? 'Burimet janë regjistruar'
            : 'Strukturë në përgatitje';

    final message = isOfficial
        ? 'Për ${source.shortTitle} janë vendosur të dhëna nga dokumentet zyrtare të KQZ.'
        : isSourceOnly
            ? 'Për ${source.shortTitle} janë regjistruar burimet zyrtare. Rezultatet shfaqen pas verifikimit të plotë.'
            : 'Kjo zgjedhje është e përgatitur në strukturë. Të dhënat reale shtohen vetëm nga KQZ.';

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      decoration: BoxDecoration(
        color: isOfficial ? const Color(0xFFECFDF3) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isOfficial ? const Color(0xFFABEFC6) : const Color(0xFFFEDC7A),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOfficial ? Icons.verified_rounded : Icons.info_outline_rounded,
            color: isOfficial ? const Color(0xFF079455) : const Color(0xFFB54708),
            size: 24,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        isOfficial ? const Color(0xFF067647) : const Color(0xFF7A4B00),
                    fontSize: 14.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color:
                        isOfficial ? const Color(0xFF067647) : const Color(0xFF7A4B00),
                    fontSize: 12.6,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumStatsGrid extends StatelessWidget {
  final int partiesCount;
  final int candidatesCount;
  final int totalSeats;
  final int totalVotes;

  const _PremiumStatsGrid({
    required this.partiesCount,
    required this.candidatesCount,
    required this.totalSeats,
    required this.totalVotes,
  });

  @override
  Widget build(BuildContext context) {
    final votes = AppFormatters.number(totalVotes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumSectionHeader(
          title: 'Përmbledhje',
          subtitle: 'Pamje e shkurtër e zgjedhjes së zgjedhur.',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PremiumMetricCard(
                label: 'Subjekte',
                value: '$partiesCount',
                icon: Icons.account_balance_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PremiumMetricCard(
                label: 'Mandate',
                value: '$totalSeats',
                icon: Icons.event_seat_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: PremiumMetricCard(
                label: 'Kandidatë',
                value: '$candidatesCount',
                icon: Icons.people_alt_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PremiumMetricCard(
                label: 'Vota',
                value: votes,
                icon: Icons.how_to_vote_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessPanel extends StatelessWidget {
  final VoidCallback onArchiveTap;
  final VoidCallback onResultsTap;
  final VoidCallback onMunicipalitiesTap;
  final VoidCallback onCandidatesTap;
  final VoidCallback onSourcesTap;

  const _QuickAccessPanel({
    required this.onArchiveTap,
    required this.onResultsTap,
    required this.onMunicipalitiesTap,
    required this.onCandidatesTap,
    required this.onSourcesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PremiumSectionHeader(
          title: 'Qasje e shpejtë',
          subtitle: 'Hap direkt atë që të duhet.',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _QuickButton(
                        icon: Icons.archive_rounded,
                        title: 'Zgjedhjet',
                        subtitle: 'Arkivi',
                        onTap: onArchiveTap,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickButton(
                        icon: Icons.bar_chart_rounded,
                        title: 'Rezultatet',
                        subtitle: 'Vota & mandate',
                        onTap: onResultsTap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _QuickButton(
                        icon: Icons.people_alt_rounded,
                        title: 'Kandidatët',
                        subtitle: 'Të zgjedhur',
                        onTap: onCandidatesTap,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickButton(
                        icon: Icons.location_city_rounded,
                        title: 'Komunat',
                        subtitle: 'Në përgatitje',
                        onTap: onMunicipalitiesTap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _QuickButton(
                  icon: Icons.source_rounded,
                  title: 'Burimet zyrtare',
                  subtitle: 'KQZ dhe dokumentet zyrtare',
                  onTap: onSourcesTap,
                  wide: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool wide;

  const _QuickButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, wide ? 12 : 13, 12, wide ? 12 : 13),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 13.6,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleList extends StatelessWidget {
  final VoidCallback onArchiveTap;
  final VoidCallback onResultsTap;
  final VoidCallback onMunicipalitiesTap;
  final VoidCallback onCandidatesTap;
  final VoidCallback onSourcesTap;

  const _ModuleList({
    required this.onArchiveTap,
    required this.onResultsTap,
    required this.onMunicipalitiesTap,
    required this.onCandidatesTap,
    required this.onSourcesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ModuleTile(
          icon: Icons.archive_rounded,
          title: 'Zgjedhjet',
          description: 'Arkivi me status, burime dhe dosje zyrtare.',
          onTap: onArchiveTap,
        ),
        const SizedBox(height: 10),
        _ModuleTile(
          icon: Icons.bar_chart_rounded,
          title: 'Rezultatet',
          description: 'Subjektet politike, votat, përqindjet dhe mandatet.',
          onTap: onResultsTap,
        ),
        const SizedBox(height: 10),
        _ModuleTile(
          icon: Icons.people_alt_rounded,
          title: 'Kandidatët',
          description: 'Kandidatët e zgjedhur dhe votat sipas subjektit.',
          onTap: onCandidatesTap,
        ),
        const SizedBox(height: 10),
        _ModuleTile(
          icon: Icons.location_city_rounded,
          title: 'Komunat',
          description: 'Status i qartë për të dhënat sipas komunave.',
          onTap: onMunicipalitiesTap,
        ),
        const SizedBox(height: 10),
        _ModuleTile(
          icon: Icons.source_rounded,
          title: 'Burimet',
          description: 'Faqet dhe dokumentet zyrtare për verifikim.',
          onTap: onSourcesTap,
        ),
      ],
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ModuleTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: AppTheme.primaryGreen, size: 23),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceInfoCard extends StatelessWidget {
  const _SourceInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFEDC7A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFB54708),
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              HomeScreen.disclaimer,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A4B00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
