import '../../../core/models/local_election_official_result.dart';

class LocalElectionOfficialDataRegistry {
  const LocalElectionOfficialDataRegistry._();

  static const List<LocalElectionOfficialDataSet> dataSets = [];

  static LocalElectionOfficialDataSet? byElectionId(String electionId) {
    for (final dataSet in dataSets) {
      if (dataSet.electionId == electionId) {
        return dataSet;
      }
    }

    return null;
  }

  static bool hasOfficialLocalData(String electionId) {
    final dataSet = byElectionId(electionId);
    if (dataSet == null) return false;

    return !dataSet.isEmpty;
  }

  static bool hasMayorResults(String electionId) {
    return byElectionId(electionId)?.hasMayorResults ?? false;
  }

  static bool hasAssemblySubjectResults(String electionId) {
    return byElectionId(electionId)?.hasAssemblySubjectResults ?? false;
  }

  static bool hasAssemblyCandidateResults(String electionId) {
    return byElectionId(electionId)?.hasAssemblyCandidateResults ?? false;
  }

  static List<LocalElectionMunicipalitySummary> municipalitySummariesFor(
    String electionId,
  ) {
    return byElectionId(electionId)?.municipalitySummaries ??
        const <LocalElectionMunicipalitySummary>[];
  }

  static List<LocalMayorResult> mayorResultsFor(String electionId) {
    return byElectionId(electionId)?.mayorResults ?? const <LocalMayorResult>[];
  }

  static List<LocalAssemblySubjectResult> assemblySubjectResultsFor(
    String electionId,
  ) {
    return byElectionId(electionId)?.assemblySubjectResults ??
        const <LocalAssemblySubjectResult>[];
  }

  static List<LocalAssemblyCandidateResult> assemblyCandidateResultsFor(
    String electionId,
  ) {
    return byElectionId(electionId)?.assemblyCandidateResults ??
        const <LocalAssemblyCandidateResult>[];
  }
}
