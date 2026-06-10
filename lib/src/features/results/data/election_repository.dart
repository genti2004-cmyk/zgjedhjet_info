import '../../../core/models/candidate_result.dart';
import '../../../core/models/election.dart';
import '../../../core/models/election_source.dart';
import '../../../core/models/kqz_remote_status.dart';
import '../../../core/models/municipality_result.dart';
import '../../../core/models/party_result.dart';
import '../../../core/services/kqz_remote_client.dart';
import '../../../core/services/kqz_results_service.dart';
import '../../../core/services/selected_election_controller.dart';

class ElectionRepository {
  final KqzResultsService _service;
  final KqzRemoteClient _remoteClient;

  const ElectionRepository({
    KqzResultsService service = const KqzResultsService(),
    KqzRemoteClient? remoteClient,
  })  : _service = service,
        _remoteClient = remoteClient ?? const _NoopRemoteClient();

  factory ElectionRepository.withRemote() {
    return ElectionRepository(
      remoteClient: KqzRemoteClient.create(),
    );
  }

  ElectionSource get selectedElection {
    return SelectedElectionController.selectedElection.value;
  }

  Future<Election> getCurrentElection() {
    return _service.fetchCurrentElection(selectedElection);
  }

  Future<List<PartyResult>> getPartyResults() {
    return _service.fetchPartyResults(selectedElection);
  }

  Future<List<MunicipalityResult>> getMunicipalityResults() {
    return _service.fetchMunicipalityResults(selectedElection);
  }

  Future<List<CandidateResult>> getCandidateResults() {
    return _service.fetchCandidateResults(selectedElection);
  }

  Future<KqzRemoteStatus> checkSelectedSource() {
    return _remoteClient.checkSource(selectedElection);
  }
}

class _NoopRemoteClient implements KqzRemoteClient {
  const _NoopRemoteClient();

  @override
  Future<KqzRemoteStatus> checkSource(ElectionSource source) async {
    return KqzRemoteStatus(
      isReachable: false,
      statusCode: null,
      sourceName: source.shortTitle,
      url: source.officialUrl,
      checkedAt: DateTime.now(),
      errorMessage: 'Remote client is not enabled.',
    );
  }
}