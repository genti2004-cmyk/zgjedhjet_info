import '../../../core/models/election_official_file.dart';

class LocalElectionOfficialFileCatalog {
  const LocalElectionOfficialFileCatalog._();

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'local-2017-assembly-subject-results',
      electionId: 'local-2017',
      title: 'Rezultatet e komunave – ndarja e vendeve 2017',
      description:
          'Dokument zyrtar i KQZ me rezultatet për kuvende komunale sipas komunave, subjekteve, votave, përqindjes dhe ndarjes së vendeve.',
      url: 'local-file:1.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'local-2017-assembly-candidate-results',
      electionId: 'local-2017',
      title: 'Rezultatet e kandidatëve nëpër komuna 2017',
      description:
          'Dokument zyrtar i KQZ me listën totale të kandidatëve për kuvende komunale sipas komunave në zgjedhjet lokale 2017.',
      url: 'local-file:2017-Komunal-3.xls',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: true,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'local-2025-mayor-round-1-results',
      electionId: 'local-2025',
      title: 'Rezultatet për Kryetarë të Komunave – Raundi I',
      description:
          'Faqja zyrtare e KQZ për rezultatet e zgjedhjeve për kryetarë të komunave. Të dhënat numerike nuk janë importuar ende.',
      url: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kryetare-te-komunave/',
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
          'Platforma zyrtare e KQZ për rezultatet/statistikat preliminare të raundit të dytë. Të dhënat numerike nuk janë importuar ende.',
      url: 'https://resultslocal2025r2.kqz-ks.org/',
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
          'Faqja zyrtare e KQZ për rezultatet e zgjedhjeve për kuvende komunale. Të dhënat numerike nuk janë importuar ende.',
      url: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvende-komunale/',
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
          'Faqja zyrtare e KQZ për zgjedhjet për kuvende komunale. Kandidatët nuk janë importuar ende.',
      url: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvende-komunale/',
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
