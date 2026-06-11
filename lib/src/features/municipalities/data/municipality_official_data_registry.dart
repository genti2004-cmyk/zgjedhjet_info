import '../../../core/models/municipality_official_result.dart';

class MunicipalityOfficialDataRegistry {
  const MunicipalityOfficialDataRegistry._();

  static const List<MunicipalityOfficialDataSet> dataSets = [];

  static MunicipalityOfficialDataSet? byElectionId(String electionId) {
    for (final dataSet in dataSets) {
      if (dataSet.electionId == electionId) {
        return dataSet;
      }
    }

    return null;
  }

  static bool hasOfficialMunicipalityData(String electionId) {
    final dataSet = byElectionId(electionId);
    if (dataSet == null) return false;

    return !dataSet.isEmpty;
  }

  static List<MunicipalityOfficialSummary> summariesFor(String electionId) {
    return byElectionId(electionId)?.summaries ?? const <MunicipalityOfficialSummary>[];
  }

  static List<MunicipalityPartyResult> partyResultsFor(String electionId) {
    return byElectionId(electionId)?.partyResults ?? const <MunicipalityPartyResult>[];
  }

  static List<MunicipalityCandidateResult> candidateResultsFor(String electionId) {
    return byElectionId(electionId)?.candidateResults ?? const <MunicipalityCandidateResult>[];
  }
}
