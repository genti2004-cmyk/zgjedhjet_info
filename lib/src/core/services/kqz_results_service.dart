import '../../features/local_2025/data/local_2025_placeholder_data.dart';
import '../../features/parliamentary_2025/data/parliamentary_2025_candidate_data.dart';
import '../../features/parliamentary_2025/data/parliamentary_2025_party_data.dart';
import '../models/candidate_result.dart';
import '../models/election.dart';
import '../models/election_source.dart';
import '../models/municipality_result.dart';
import '../models/party_result.dart';

class KqzResultsService {
  const KqzResultsService();

  Future<Election> fetchCurrentElection(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return Election(
          id: 'parliamentary-2025',
          title: source.title,
          type: 'Parlamentare',
          status: 'Të dhëna nga dokumentet zyrtare të KQZ',
          date: DateTime(2025, 2, 9),
          lastUpdated: DateTime.now(),
        );

      case ElectionSourceType.local2025:
        return Election(
          id: 'local-2025',
          title: source.title,
          type: 'Lokale',
          status: 'Burim zyrtar i përgatitur - test UI',
          date: DateTime(2025, 10, 12),
          lastUpdated: DateTime.now(),
        );

      case ElectionSourceType.local2025Round2:
        return Election(
          id: 'local-2025-r2',
          title: source.title,
          type: 'Lokale - Raundi II',
          status: 'Burim zyrtar i përgatitur - test UI',
          date: DateTime(2025, 11, 9),
          lastUpdated: DateTime.now(),
        );
    }
  }

  Future<List<PartyResult>> fetchPartyResults(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return Parliamentary2025PartyData.results;

      case ElectionSourceType.local2025:
        return Local2025PlaceholderData.localPartyResults;

      case ElectionSourceType.local2025Round2:
        return Local2025PlaceholderData.localRound2PartyResults;
    }
  }

  Future<List<MunicipalityResult>> fetchMunicipalityResults(
    ElectionSource source,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return Local2025PlaceholderData.parliamentaryMunicipalitiesPlaceholder;

      case ElectionSourceType.local2025:
        return Local2025PlaceholderData.localMunicipalitiesPlaceholder;

      case ElectionSourceType.local2025Round2:
        return Local2025PlaceholderData.localRound2MunicipalitiesPlaceholder;
    }
  }

  Future<List<CandidateResult>> fetchCandidateResults(
    ElectionSource source,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return Parliamentary2025CandidateData.results;

      case ElectionSourceType.local2025:
        return Local2025PlaceholderData.localCandidatesPlaceholder;

      case ElectionSourceType.local2025Round2:
        return Local2025PlaceholderData.localRound2CandidatesPlaceholder;
    }
  }
}
