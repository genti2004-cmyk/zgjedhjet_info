import '../../../core/models/election_official_file.dart';

class Parliamentary2014OfficialFiles {
  const Parliamentary2014OfficialFiles._();

  static const String electionId = 'parliamentary-2014';

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'parliamentary-2014-general-statistics',
      electionId: electionId,
      title: 'Statistikat e përgjithshme',
      description: 'Statistikat e përgjithshme për zgjedhjet parlamentare 2014.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/04/1.-Statistikat-e-p%C3%ABrgjithshme.pdf',
      fileType: 'PDF',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2014-statistics-by-municipality',
      electionId: electionId,
      title: 'Statistikat sipas komunave',
      description: 'Statistikat sipas komunave për zgjedhjet parlamentare 2014.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/04/2.-Statistikat-sipas-komunave.pdf',
      fileType: 'PDF',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2014-party-results',
      electionId: electionId,
      title: 'Rezultatet e përgjithshme sipas subjekteve',
      description: 'Rezultatet e certifikuara sipas subjekteve politike për zgjedhjet parlamentare 2014.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/04/1.-Rezultatet-e-p%C3%ABrgjithshme-sipas-Subjekteve-2014.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2014-elected-candidates-by-subject',
      electionId: electionId,
      title: 'Kandidatët e zgjedhur sipas subjekteve',
      description: 'Kandidatët e zgjedhur sipas subjekteve politike për zgjedhjet parlamentare 2014.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/04/2.-Kandidat%C3%ABt-e-zgjedhur-sipas-Subjekteve-2014.pdf',
      fileType: 'PDF',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2014-elected-candidates-by-votes',
      electionId: electionId,
      title: 'Rezultatet e kandidatëve të zgjedhur sipas numrit të votave',
      description: 'Kandidatët e zgjedhur të renditur sipas numrit të votave për zgjedhjet parlamentare 2014.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/04/5.-Rezultatet-e-kandidat%C3%ABve-t%C3%AB-zgjedhur-sipas-numrit-t%C3%AB-votave-2014.pdf',
      fileType: 'PDF',
      isResultData: false,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2014-party-results-by-municipality',
      electionId: electionId,
      title: 'Rezultatet e subjekteve sipas komunave',
      description: 'Rezultatet e subjekteve politike sipas komunave për zgjedhjet parlamentare 2014.',
      url: 'https://kqz-ks.org/wp-content/uploads/2018/04/6.-Rezultatet-e-subjekteve-sipas-komunave-2014.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
  ];
}
