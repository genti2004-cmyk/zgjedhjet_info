import '../../features/historical_mayors/data/historical_mayor_2017_data.dart';
import '../../features/historical_mayors/data/historical_mayor_2021_data.dart';
import '../../features/historical_mayors/data/historical_mayor_party_data.dart';
import '../../features/parliamentary_2025_december/data/parliamentary_2025_december_party_data.dart';
import '../../features/parliamentary_2025_december/data/parliamentary_2025_december_candidate_data.dart';
import '../../features/parliamentary_2025_december/data/parliamentary_2025_december_municipality_data.dart';
import '../../features/parliamentary_2001/data/parliamentary_2001_municipality_data.dart';
import '../../features/parliamentary_2004/data/parliamentary_2004_municipality_data.dart';
import '../../features/parliamentary_2007/data/parliamentary_2007_municipality_data.dart';
import '../../features/local_2017/data/local_2017_assembly_subject_data.dart';
import '../../features/local_2017/data/local_2017_assembly_candidate_data.dart';
import '../../features/local_2025/data/local_2025_assembly_candidate_data.dart';
import '../../features/local_2025/data/local_2025_assembly_data.dart';
import '../../features/local_2025/data/local_2025_assembly_party_data.dart';
import '../../features/local_2025/data/local_2025_mayor_data.dart';
import '../../features/local_2025/data/local_2025_mayor_party_data.dart';
import '../../features/parliamentary_2010/data/parliamentary_2010_party_data.dart';
import '../../features/parliamentary_2010/data/parliamentary_2010_candidate_data.dart';
import '../../features/parliamentary_2010/data/parliamentary_2010_municipality_data.dart';
import '../../features/parliamentary_2014/data/parliamentary_2014_candidate_data.dart';
import '../../features/parliamentary_2014/data/parliamentary_2014_municipality_data.dart';
import '../../features/parliamentary_2014/data/parliamentary_2014_party_data.dart';
import '../../features/parliamentary_2017/data/parliamentary_2017_candidate_data.dart';
import '../../features/parliamentary_2017/data/parliamentary_2017_municipality_data.dart';
import '../../features/parliamentary_2017/data/parliamentary_2017_party_data.dart';
import '../../features/parliamentary_2019/data/parliamentary_2019_candidate_data.dart';
import '../../features/parliamentary_2019/data/parliamentary_2019_municipality_data.dart';
import '../../features/parliamentary_2019/data/parliamentary_2019_party_data.dart';
import '../../features/parliamentary_2021/data/parliamentary_2021_candidate_data.dart';
import '../../features/parliamentary_2021/data/parliamentary_2021_municipality_data.dart';
import '../../features/parliamentary_2021/data/parliamentary_2021_party_data.dart';
import '../../features/parliamentary_2025/data/parliamentary_2025_candidate_data.dart';
import '../../features/parliamentary_2025/data/parliamentary_2025_municipality_data.dart';
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
      case ElectionSourceType.parliamentary2025December:
        return Election(id: 'parliamentary-2025-december', title: source.title, type: 'Parlamentare', status: 'Rezultatet përfundimtare dhe kandidatët e zgjedhur nga dokumentet zyrtare të KQZ', date: DateTime(2025, 12, 28), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2025:
        return Election(id: 'parliamentary-2025', title: source.title, type: 'Parlamentare', status: 'Të dhëna nga dokumentet zyrtare të KQZ', date: DateTime(2025, 2, 9), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2021:
        return Election(id: 'parliamentary-2021', title: source.title, type: 'Parlamentare', status: 'Rezultatet dhe kandidatët nga dokumentet zyrtare të KQZ', date: DateTime(2021, 2, 14), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2019:
        return Election(id: 'parliamentary-2019', title: source.title, type: 'Parlamentare', status: 'Rezultatet dhe kandidatët nga dokumentet zyrtare të KQZ', date: DateTime(2019, 10, 6), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2017:
        return Election(id: 'parliamentary-2017', title: source.title, type: 'Parlamentare', status: 'Rezultatet e subjekteve nga dokument zyrtar i KQZ', date: DateTime(2017, 6, 11), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2014:
        return Election(id: 'parliamentary-2014', title: source.title, type: 'Parlamentare', status: 'Rezultatet dhe kandidatët nga dokumentet zyrtare të KQZ', date: DateTime(2014, 6, 8), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2007:
        return Election(id: 'parliamentary-2007', title: source.title, type: 'Parlamentare', status: 'Rezultatet komunale nga dokumentet zyrtare të OSBE/CEC', date: DateTime(2007, 11, 17), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2004:
        return Election(id: 'parliamentary-2004', title: source.title, type: 'Parlamentare', status: 'Rezultatet komunale nga dokumentet zyrtare të OSBE/CEC', date: DateTime(2004, 10, 23), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2001:
        return Election(id: 'parliamentary-2001', title: source.title, type: 'Parlamentare', status: 'Rezultatet komunale të certifikuara nga OSBE/OMiK', date: DateTime(2001, 11, 17), lastUpdated: DateTime.now());
      case ElectionSourceType.parliamentary2010:
        return Election(id: 'parliamentary-2010', title: source.title, type: 'Parlamentare', status: 'Rezultatet e subjekteve nga dokument zyrtar i KQZ', date: DateTime(2010, 12, 12), lastUpdated: DateTime.now());
      case ElectionSourceType.local2017:
        return Election(id: 'local-2017', title: source.title, type: 'Lokale - Kuvende Komunale', status: 'Rezultatet e subjekteve dhe kandidatët sipas komunave nga dokumentet zyrtare të KQZ', date: DateTime(2017, 10, 22), lastUpdated: DateTime.now());
      case ElectionSourceType.local2017Mayor:
        return Election(id: 'local-2017-mayor', title: source.title, type: 'Lokale - Kryetarë', status: 'Rezultatet zyrtare të raundit të parë; balotazhi 2017 ende i paplotësuar', date: DateTime(2017, 10, 22), lastUpdated: DateTime.now());
      case ElectionSourceType.local2021Mayor:
        return Election(id: 'local-2021-mayor', title: source.title, type: 'Lokale - Kryetarë', status: 'Rezultatet zyrtare të raundit të parë dhe balotazhit', date: DateTime(2021, 10, 17), lastUpdated: DateTime.now());
      case ElectionSourceType.local2025:
        return Election(id: 'local-2025', title: source.title, type: 'Lokale', status: 'Rezultatet e kuvendeve komunale, kandidatët dhe statistikat nga dokumentet zyrtare të KQZ', date: DateTime(2025, 10, 12), lastUpdated: DateTime.now());
      case ElectionSourceType.local2025Round2:
        return Election(id: 'local-2025-r2', title: source.title, type: 'Lokale - Raundi II', status: 'Rezultatet e raundit të parë dhe balotazhit nga dokumentet zyrtare të KQZ', date: DateTime(2025, 10, 12), lastUpdated: DateTime.now());
    }
  }

  Future<List<PartyResult>> fetchPartyResults(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    switch (source.type) {
      case ElectionSourceType.parliamentary2025December:
        return Parliamentary2025DecemberPartyData.results;
      case ElectionSourceType.parliamentary2025:
        return Parliamentary2025PartyData.results;
      case ElectionSourceType.parliamentary2021:
        return Parliamentary2021PartyData.results;
      case ElectionSourceType.parliamentary2019:
        return Parliamentary2019PartyData.results;
      case ElectionSourceType.parliamentary2017:
        return Parliamentary2017PartyData.results;
      case ElectionSourceType.parliamentary2014:
        return Parliamentary2014PartyData.results;
      case ElectionSourceType.parliamentary2010:
        return Parliamentary2010PartyData.results;
      case ElectionSourceType.parliamentary2007:
      case ElectionSourceType.parliamentary2004:
      case ElectionSourceType.parliamentary2001:
        return const <PartyResult>[];
      case ElectionSourceType.local2017:
        return Local2017AssemblySubjectData.results;
      case ElectionSourceType.local2017Mayor:
        return HistoricalMayorPartyData.results2017;
      case ElectionSourceType.local2021Mayor:
        return HistoricalMayorPartyData.results2021;
      case ElectionSourceType.local2025:
        return Local2025AssemblyPartyData.nationalResults;
      case ElectionSourceType.local2025Round2:
        return Local2025MayorPartyData.results;
    }
  }

  Future<List<MunicipalityResult>> fetchMunicipalityResults(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    switch (source.type) {
      case ElectionSourceType.parliamentary2025December:
        return Parliamentary2025DecemberMunicipalityData.results;
      case ElectionSourceType.parliamentary2025:
        return Parliamentary2025MunicipalityData.results;
      case ElectionSourceType.parliamentary2021:
        return Parliamentary2021MunicipalityData.results;
      case ElectionSourceType.parliamentary2019:
        return Parliamentary2019MunicipalityData.results;
      case ElectionSourceType.parliamentary2017:
        return Parliamentary2017MunicipalityData.results;
      case ElectionSourceType.parliamentary2014:
        return Parliamentary2014MunicipalityData.results;
      case ElectionSourceType.parliamentary2010:
        return Parliamentary2010MunicipalityData.results;
      case ElectionSourceType.parliamentary2007:
        return Parliamentary2007MunicipalityData.results;
      case ElectionSourceType.parliamentary2004:
        return Parliamentary2004MunicipalityData.results;
      case ElectionSourceType.parliamentary2001:
        return Parliamentary2001MunicipalityData.results;
      case ElectionSourceType.local2017:
        return const <MunicipalityResult>[];
      case ElectionSourceType.local2017Mayor:
        return HistoricalMayor2017Data.municipalityResults;
      case ElectionSourceType.local2021Mayor:
        return HistoricalMayor2021Data.municipalityResults;
      case ElectionSourceType.local2025:
        return Local2025AssemblyData.municipalities;
      case ElectionSourceType.local2025Round2:
        return Local2025MayorData.municipalityResults;
    }
  }

  Future<List<CandidateResult>> fetchCandidateResults(ElectionSource source) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    switch (source.type) {
      case ElectionSourceType.parliamentary2025December:
        return Parliamentary2025DecemberCandidateData.results;
      case ElectionSourceType.parliamentary2025:
        return Parliamentary2025CandidateData.results;
      case ElectionSourceType.parliamentary2021:
        return Parliamentary2021CandidateData.results;
      case ElectionSourceType.parliamentary2019:
        return Parliamentary2019CandidateData.results;
      case ElectionSourceType.parliamentary2017:
        return Parliamentary2017CandidateData.results;
      case ElectionSourceType.parliamentary2010:
        return Parliamentary2010CandidateData.results;
      case ElectionSourceType.parliamentary2014:
        return Parliamentary2014CandidateData.results;
      case ElectionSourceType.parliamentary2007:
      case ElectionSourceType.parliamentary2004:
      case ElectionSourceType.parliamentary2001:
        return const <CandidateResult>[];
      case ElectionSourceType.local2017:
        return Local2017AssemblyCandidateData.results;
      case ElectionSourceType.local2017Mayor:
        return HistoricalMayor2017Data.candidateResults;
      case ElectionSourceType.local2021Mayor:
        return HistoricalMayor2021Data.candidateResults;
      case ElectionSourceType.local2025:
        return Local2025AssemblyCandidateData.allCandidates;
      case ElectionSourceType.local2025Round2:
        return Local2025MayorData.candidateResults;
    }
  }
}
