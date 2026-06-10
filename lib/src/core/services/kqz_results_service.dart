import '../../features/local_2025/data/local_2025_placeholder_data.dart';
import '../../features/parliamentary_2014/data/parliamentary_2014_candidate_data.dart';
import '../../features/parliamentary_2014/data/parliamentary_2014_party_data.dart';
import '../../features/parliamentary_2019/data/parliamentary_2019_candidate_data.dart';
import '../../features/parliamentary_2019/data/parliamentary_2019_party_data.dart';
import '../../features/parliamentary_2021/data/parliamentary_2021_candidate_data.dart';
import '../../features/parliamentary_2021/data/parliamentary_2021_party_data.dart';
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
        return Election(id: 'parliamentary-2025', title: source.title, type: 'Parlamentare', status: 'Të dhëna nga dokumentet zyrtare të KQZ', date: DateTime(2025, 2, 9), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2021:
        return Election(id: 'parliamentary-2021', title: source.title, type: 'Parlamentare', status: 'Rezultatet dhe kandidatët nga dokumentet zyrtare të KQZ', date: DateTime(2021, 2, 14), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2019:
        return Election(id: 'parliamentary-2019', title: source.title, type: 'Parlamentare', status: 'Rezultatet dhe kandidatët nga dokumentet zyrtare të KQZ', date: DateTime(2019, 10, 6), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2017:
        return Election(id: 'parliamentary-2017', title: source.title, type: 'Parlamentare', status: 'Burimet zyrtare janë regjistruar - importi në përgatitje', date: DateTime(2017, 6, 11), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2014:
        return Election(id: 'parliamentary-2014', title: source.title, type: 'Parlamentare', status: 'Rezultatet dhe kandidatët nga dokumentet zyrtare të KQZ', date: DateTime(2014, 6, 8), lastUpdated: DateTime.now());
      case ElectionSourceType.local2025:
        return Election(id: 'local-2025', title: source.title, type: 'Lokale', status: 'Burim zyrtar i përgatitur - test UI', date: DateTime(2025, 10, 12), lastUpdated: DateTime.now());
      case ElectionSourceType.local2025Round2:
        return Election(id: 'local-2025-r2', title: source.title, type: 'Lokale - Raundi II', status: 'Burim zyrtar i përgatitur - test UI', date: DateTime(2025, 11, 9), lastUpdated: DateTime.now());
    }
  }

  Future<List<PartyResult>> fetchPartyResults(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return Parliamentary2025PartyData.results;
      case ElectionSourceType.parliamentary2021:
        return Parliamentary2021PartyData.results;
      case ElectionSourceType.parliamentary2019:
        return Parliamentary2019PartyData.results;
      case ElectionSourceType.parliamentary2017:
        return const <PartyResult>[];
      case ElectionSourceType.parliamentary2014:
        return Parliamentary2014PartyData.results;
      case ElectionSourceType.local2025:
        return Local2025PlaceholderData.localPartyResults;
      case ElectionSourceType.local2025Round2:
        return Local2025PlaceholderData.localRound2PartyResults;
    }
  }

  Future<List<MunicipalityResult>> fetchMunicipalityResults(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
      case ElectionSourceType.parliamentary2021:
      case ElectionSourceType.parliamentary2019:
      case ElectionSourceType.parliamentary2017:
      case ElectionSourceType.parliamentary2014:
        return Local2025PlaceholderData.parliamentaryMunicipalitiesPlaceholder;
      case ElectionSourceType.local2025:
        return Local2025PlaceholderData.localMunicipalitiesPlaceholder;
      case ElectionSourceType.local2025Round2:
        return Local2025PlaceholderData.localRound2MunicipalitiesPlaceholder;
    }
  }

  Future<List<CandidateResult>> fetchCandidateResults(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return Parliamentary2025CandidateData.results;
      case ElectionSourceType.parliamentary2021:
        return Parliamentary2021CandidateData.results;
      case ElectionSourceType.parliamentary2019:
        return Parliamentary2019CandidateData.results;
      case ElectionSourceType.parliamentary2017:
        return const <CandidateResult>[];
      case ElectionSourceType.parliamentary2014:
        return Parliamentary2014CandidateData.results;
      case ElectionSourceType.local2025:
        return Local2025PlaceholderData.localCandidatesPlaceholder;
      case ElectionSourceType.local2025Round2:
        return Local2025PlaceholderData.localRound2CandidatesPlaceholder;
    }
  }
}
