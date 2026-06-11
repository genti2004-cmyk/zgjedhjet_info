import '../../../core/models/election_official_file.dart';

class LocalElectionOfficialFileCatalog {
  const LocalElectionOfficialFileCatalog._();

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'local-2025-mayor-round-1-results',
      electionId: 'local-2025',
      title: 'Rezultatet për Kryetarë të Komunave – Raundi I',
      description:
          'Burim zyrtar i përgatitur për rezultatet e kryetarëve të komunave. Të dhënat numerike nuk janë importuar ende.',
      url: 'https://kqz-ks.org/rezultatet/',
      fileType: 'WEB',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'local-2025-mayor-round-2-results',
      electionId: 'local-2025-r2',
      title: 'Rezultatet për Kryetarë të Komunave – Raundi II',
      description:
          'Burim zyrtar i përgatitur për balotazhin. Të dhënat numerike nuk janë importuar ende.',
      url: 'https://kqz-ks.org/rezultatet/',
      fileType: 'WEB',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'local-2025-assembly-subject-results',
      electionId: 'local-2025',
      title: 'Rezultatet për Kuvende Komunale sipas Subjekteve',
      description:
          'Burim zyrtar i përgatitur për rezultatet e subjekteve në kuvende komunale. Të dhënat numerike nuk janë importuar ende.',
      url: 'https://kqz-ks.org/rezultatet/',
      fileType: 'WEB',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'local-2025-assembly-candidate-results',
      electionId: 'local-2025',
      title: 'Rezultatet për Kandidatë të Kuvendeve Komunale',
      description:
          'Burim zyrtar i përgatitur për kandidatët e kuvendeve komunale. Kandidatët nuk janë importuar ende.',
      url: 'https://kqz-ks.org/rezultatet/',
      fileType: 'WEB',
      isResultData: true,
      isCandidateData: true,
      isMunicipalityData: true,
    ),
  ];

  static List<ElectionOfficialFile> byElectionId(String electionId) {
    return files.where((file) => file.electionId == electionId).toList();
  }

  static bool hasFilesFor(String electionId) {
    return byElectionId(electionId).isNotEmpty;
  }
}
