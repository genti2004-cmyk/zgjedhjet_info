import 'package:flutter/material.dart';

import '../../../core/models/candidate_result.dart';
import '../../../core/models/election.dart';
import '../../../core/models/election_source.dart';
import '../../../core/models/party_result.dart';
import '../../../core/services/selected_election_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/election_picker_card.dart';
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

  bool _hasOfficialParliamentaryData(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2014;
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
                        child: _HeroHeader(
                          election: election,
                          source: selectedSource,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              ElectionPickerCard(onChanged: _refresh),
                              const SizedBox(height: 18),
                              _DataStatusCard(
                                isOfficial: _hasOfficialParliamentaryData(
                                  selectedSource,
                                ),
                                source: selectedSource,
                              ),
                              const SizedBox(height: 18),
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

                                      return _DashboardSummary(
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
                              const _SectionTitle(title: 'Qasje e shpejtë'),
                              const SizedBox(height: 12),
                              _QuickActionsGrid(
                                onArchiveTap: () => _goToTab(1),
                                onResultsTap: () => _goToTab(2),
                                onMunicipalitiesTap: () => _goToTab(3),
                                onCandidatesTap: () => _goToTab(4),
                                onSourcesTap: () => _goToTab(5),
                              ),
                              const SizedBox(height: 22),
                              const _SectionTitle(title: 'Modulet kryesore'),
                              const SizedBox(height: 12),
                              _MainActionCard(
                                icon: Icons.archive_rounded,
                                title: 'Zgjedhjet',
                                description:
                                    'Arkivi i zgjedhjeve nga 2008 deri sot, me statusin e të dhënave.',
                                onTap: () => _goToTab(1),
                              ),
                              const SizedBox(height: 12),
                              _MainActionCard(
                                icon: Icons.bar_chart_rounded,
                                title: 'Rezultatet zgjedhore',
                                description:
                                    'Subjektet politike, votat, përqindjet dhe mandatet.',
                                onTap: () => _goToTab(2),
                              ),
                              const SizedBox(height: 12),
                              _MainActionCard(
                                icon: Icons.location_city_rounded,
                                title: 'Komunat',
                                description:
                                    'Pamje sipas komunave, pjesëmarrje dhe strukturë rezultatesh.',
                                onTap: () => _goToTab(3),
                              ),
                              const SizedBox(height: 12),
                              _MainActionCard(
                                icon: Icons.people_alt_rounded,
                                title: 'Kandidatët',
                                description:
                                    'Kandidatët e zgjedhur, votat dhe kërkimi sipas subjektit.',
                                onTap: () => _goToTab(4),
                              ),
                              const SizedBox(height: 12),
                              _MainActionCard(
                                icon: Icons.source_rounded,
                                title: 'Burimet zyrtare',
                                description:
                                    'Lidhjet zyrtare të KQZ dhe kontrolli i burimit online.',
                                onTap: () => _goToTab(5),
                              ),
                              const SizedBox(height: 22),
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

class _HeroHeader extends StatelessWidget {
  final Election? election;
  final ElectionSource source;

  const _HeroHeader({
    required this.election,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final title = election?.title ?? source.title;
    final status = election?.status ?? 'Në pritje';
    final date =
        election == null ? source.dateLabel : AppFormatters.date(election!.date);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryGreen,
            AppTheme.deepGreen,
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
          const _HeaderBadge(),
          const SizedBox(height: 22),
          const Text(
            HomeScreen.appName,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            HomeScreen.subtitle,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEAF7F0),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Data: $date',
            style: const TextStyle(
              fontSize: 13.2,
              fontWeight: FontWeight.w700,
              color: Color(0xFFEAF7F0),
            ),
          ),
          const SizedBox(height: 14),
          _UpdateStatusPill(status: status),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.24),
            ),
          ),
          child: const Icon(
            Icons.how_to_vote_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Dashboard zgjedhor',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _UpdateStatusPill extends StatelessWidget {
  final String status;

  const _UpdateStatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataStatusCard extends StatelessWidget {
  final bool isOfficial;
  final ElectionSource source;

  const _DataStatusCard({
    required this.isOfficial,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isOfficial ? const Color(0xFFECFDF3) : const Color(0xFFFFFBEB);
    final borderColor =
        isOfficial ? const Color(0xFFABEFC6) : const Color(0xFFFEDC7A);
    final iconColor =
        isOfficial ? const Color(0xFF079455) : const Color(0xFFB54708);
    final textColor =
        isOfficial ? const Color(0xFF067647) : const Color(0xFF7A4B00);

    final title = isOfficial
        ? 'Të dhëna zyrtare të KQZ'
        : 'Strukturë e përgatitur';

    final description = isOfficial
        ? 'Për ${source.shortTitle} janë vendosur rezultatet, mandatet dhe kandidatët e zgjedhur nga dokumentet zyrtare të KQZ.'
        : 'Për ${source.shortTitle} lidhja reale me të dhënat e KQZ është në përgatitje. Aktualisht shfaqen të dhëna strukturore/testuese.';

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isOfficial ? Icons.verified_rounded : Icons.info_outline_rounded,
            color: iconColor,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
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

class _DashboardSummary extends StatelessWidget {
  final int partiesCount;
  final int candidatesCount;
  final int totalSeats;
  final int totalVotes;

  const _DashboardSummary({
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
        const _SectionTitle(title: 'Përmbledhje'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Subjekte',
                value: '$partiesCount',
                icon: Icons.account_balance_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                label: 'Mandate',
                value: '$totalSeats',
                icon: Icons.event_seat_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Kandidatë',
                value: '$candidatesCount',
                icon: Icons.people_alt_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
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

class _QuickActionsGrid extends StatelessWidget {
  final VoidCallback onArchiveTap;
  final VoidCallback onResultsTap;
  final VoidCallback onMunicipalitiesTap;
  final VoidCallback onCandidatesTap;
  final VoidCallback onSourcesTap;

  const _QuickActionsGrid({
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
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.archive_rounded,
                title: 'Zgjedhjet',
                onTap: onArchiveTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.bar_chart_rounded,
                title: 'Rezultatet',
                onTap: onResultsTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.location_city_rounded,
                title: 'Komunat',
                onTap: onMunicipalitiesTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.people_alt_rounded,
                title: 'Kandidatët',
                onTap: onCandidatesTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.source_rounded,
                title: 'Burimet',
                onTap: onSourcesTap,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MainActionCard({
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryGreen,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
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



