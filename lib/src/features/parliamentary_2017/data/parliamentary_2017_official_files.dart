import '../../../core/models/election_official_file.dart';

class Parliamentary2017OfficialFiles {
  const Parliamentary2017OfficialFiles._();

  static const String electionId = 'parliamentary-2017';

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'parliamentary-2017-general-statistics',
      electionId: electionId,
      title: 'Statistikat e përgjithshme',
      description: 'Statistikat e përgjithshme për zgjedhjet parlamentare 2017.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/01/1.-Statistikat-e-p%C3%ABrgjithshme.xlsx',
      fileType: 'XLSX',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2017-statistics-by-municipality',
      electionId: electionId,
      title: 'Statistikat sipas komunave',
      description: 'Statistikat sipas komunave për zgjedhjet parlamentare 2017.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/01/2.-Statistikat-sipas-Komunave.xlsx',
      fileType: 'XLSX',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2017-party-results',
      electionId: electionId,
      title: 'Rezultatet e përgjithshme sipas subjekteve',
      description: 'Rezultatet e përgjithshme sipas subjekteve politike për zgjedhjet parlamentare 2017.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/03/1.-Rezultatet-e-p%C3%ABrgjithshme-sipas-Subjekteve.xlsx',
      fileType: 'XLSX',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2017-elected-candidates-by-subject',
      electionId: electionId,
      title: 'Kandidatët e zgjedhur sipas subjekteve',
      description: 'Kandidatët e zgjedhur sipas subjekteve politike për zgjedhjet parlamentare 2017.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/03/2.-Kandidat%C3%ABt-e-zgjedhur-sipas-Subjekteve.xlsx',
      fileType: 'XLSX',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2017-all-candidates',
      electionId: electionId,
      title: 'Rezultatet e të gjithë kandidatëve',
      description: 'Rezultatet e të gjithë kandidatëve për zgjedhjet parlamentare 2017.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/03/3.-Rezultatet-e-t%C3%AB-gjith%C3%AB-kandidat%C3%ABve.xlsx',
      fileType: 'XLSX',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2017-elected-candidates-by-votes',
      electionId: electionId,
      title: 'Rezultatet e kandidatëve të zgjedhur sipas numrit të votave',
      description: 'Kandidatët e zgjedhur të renditur sipas numrit të votave për zgjedhjet parlamentare 2017.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/03/5.-Rezultatet-e-kandidat%C3%ABve-t%C3%AB-zgjedhur-sipas-numrit-t%C3%AB-votave.xlsx',
      fileType: 'XLSX',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2017-party-results-by-municipality',
      electionId: electionId,
      title: 'Rezultatet e subjekteve sipas komunave',
      description: 'Rezultatet e subjekteve politike sipas komunave për zgjedhjet parlamentare 2017.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/01/6.-Rezultatet-e-subjekteve-sipas-komunave-2.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
  ];
}
