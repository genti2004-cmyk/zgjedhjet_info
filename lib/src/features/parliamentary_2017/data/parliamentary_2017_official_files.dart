import '../../../core/models/election_official_file.dart';

class Parliamentary2017OfficialFiles {
  const Parliamentary2017OfficialFiles._();

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'parliamentary-2017-party-results',
      electionId: 'parliamentary-2017',
      title: 'Rezultatet e përgjithshme sipas Subjekteve 2017',
      description:
          'Dokument zyrtar i KQZ me rezultatet e subjekteve politike për zgjedhjet parlamentare 2017.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2018/03/1.-Rezultatet-e-p%C3%ABrgjithshme-sipas-Subjekteve.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2017-elected-candidates',
      electionId: 'parliamentary-2017',
      title: 'Kandidatët e zgjedhur sipas Subjekteve 2017',
      description:
          'Dokument zyrtar i KQZ me kandidatët e zgjedhur sipas subjekteve për zgjedhjet parlamentare 2017.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2018/03/2.-Kandidat%C3%ABt-e-zgjedhur-sipas-Subjekteve.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
  ];
}
