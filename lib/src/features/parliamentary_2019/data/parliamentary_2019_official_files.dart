import '../../../core/models/election_official_file.dart';

class Parliamentary2019OfficialFiles {
  const Parliamentary2019OfficialFiles._();

  static const String electionId = 'parliamentary-2019';

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'parliamentary-2019-party-results',
      electionId: electionId,
      title: 'Rezultatet sipas subjekteve politike',
      description:
          'Rezultatet e përgjithshme sipas subjekteve politike për zgjedhjet parlamentare 2019.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/2.Rezultatet-sipas-subjekteve-politike.xls',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2019-seat-allocation',
      electionId: electionId,
      title: 'Ndarja e ulëseve në Kuvend',
      description:
          'Ndarja e ulëseve në Kuvend sipas subjekteve dhe kandidatëve të zgjedhur.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/3.Ndarja-e-ul%C3%ABseve-n%C3%AB-Kuvend-Subjektet-dhe-kandidat%C3%ABt-e-zgjedhur.xls',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2019-elected-candidates',
      electionId: electionId,
      title: 'Kandidatët e zgjedhur',
      description:
          'Lista e kandidatëve të zgjedhur sipas subjekteve politike për zgjedhjet parlamentare 2019.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/4.Kandidat%C3%ABt-e-zgjedhur.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2019-all-candidates',
      electionId: electionId,
      title: 'Rezultatet e të gjithë kandidatëve',
      description:
          'Rezultatet e të gjithë kandidatëve sipas subjekteve, me renditje si në fletëvotim.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/5.Rezultatet-e-t%C3%AB-gjith%C3%AB-kandidat%C3%ABve-sipas-subjekteve-renditja-si-n%C3%AB-flet%C3%ABvotim.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2019-party-results-by-municipality',
      electionId: electionId,
      title: 'Rezultatet e subjekteve sipas komunave',
      description:
          'Rezultatet e subjekteve politike sipas komunave për zgjedhjet parlamentare 2019.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/7.Rezultatet-e-subjekteve-sipas-komunave.xls',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2019-candidate-results-by-municipality',
      electionId: electionId,
      title: 'Rezultatet e kandidatëve sipas komunave',
      description:
          'Rezultatet e kandidatëve sipas komunave për zgjedhjet parlamentare 2019.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/8.Rezultatet-e-kandidat%C3%ABve-sipas-komunave.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2019-general-statistics',
      electionId: electionId,
      title: 'Statistikat e përgjithshme',
      description:
          'Statistikat e përgjithshme të zgjedhjeve parlamentare 2019.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/1.Statistikat-e-p%C3%ABrgjithshme.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2019-statistics-by-municipality',
      electionId: electionId,
      title: 'Statistikat sipas komunave',
      description:
          'Statistikat sipas komunave për zgjedhjet parlamentare 2019.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2019/11/6.Statistikat-sipas-komunave.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
  ];
}
