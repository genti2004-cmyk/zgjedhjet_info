import '../../../core/models/election_official_file.dart';

class Parliamentary2021OfficialFiles {
  const Parliamentary2021OfficialFiles._();

  static const String electionId = 'parliamentary-2021';

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'parliamentary-2021-party-results',
      electionId: electionId,
      title: 'Rezultatet sipas subjekteve politike',
      description:
          'Rezultatet e përgjithshme sipas subjekteve politike për zgjedhjet parlamentare 2021.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/2.Rezultatet-sipas-subjekteve-politike.xls',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2021-seat-allocation',
      electionId: electionId,
      title: 'Ndarja e ulëseve në Kuvend',
      description:
          'Ndarja e ulëseve në Kuvend sipas subjekteve dhe kandidatëve të zgjedhur.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/3.Ndarja-e-uleseve-ne-Kuvend-Subjektet-dhe-kandidatet-e-zgjedhur.xls',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2021-elected-candidates',
      electionId: electionId,
      title: 'Kandidatët e zgjedhur',
      description:
          'Lista e kandidatëve të zgjedhur në zgjedhjet parlamentare 2021.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/4.Kandidatet-e-zgjedhur-1.pdf',
      fileType: 'PDF',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2021-all-candidates',
      electionId: electionId,
      title: 'Rezultatet e të gjithë kandidatëve',
      description:
          'Rezultatet e të gjithë kandidatëve sipas subjekteve, me renditje si në fletëvotim.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/5.Rezultatet-e-te-gjithe-kandidateve-sipas-subjekteve-renditja-si-ne-fletevotim.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2021-party-results-by-municipality',
      electionId: electionId,
      title: 'Rezultatet e subjekteve sipas komunave',
      description:
          'Rezultatet e subjekteve politike sipas komunave për zgjedhjet parlamentare 2021.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/7.Rezultatet-e-subjekteve-sipas-komunave.xls',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2021-candidate-results-by-municipality',
      electionId: electionId,
      title: 'Rezultatet e kandidatëve sipas komunave',
      description:
          'Rezultatet e kandidatëve sipas komunave për zgjedhjet parlamentare 2021.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/8.Rezultatet-e-kandidateve-sipas-komunave.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2021-general-statistics',
      electionId: electionId,
      title: 'Statistikat e përgjithshme',
      description:
          'Statistikat e përgjithshme të zgjedhjeve parlamentare 2021.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/1.Statistikat-e-pergjithshme.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2021-statistics-by-municipality',
      electionId: electionId,
      title: 'Statistikat sipas komunave',
      description:
          'Statistikat sipas komunave për zgjedhjet parlamentare 2021.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2021/03/6.Statistikat-sipas-komunave.xls',
      fileType: 'XLS',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
  ];
}
