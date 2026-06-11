import '../../../core/models/election_official_file.dart';

class Parliamentary2010OfficialFiles {
  const Parliamentary2010OfficialFiles._();

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'parliamentary-2010-party-results',
      electionId: 'parliamentary-2010',
      title: 'Rezultatet e përgjithshme sipas Subjekteve 2010',
      description:
          'Dokument zyrtar i KQZ me rezultatet e subjekteve politike për zgjedhjet parlamentare 2010.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2018/04/1.-Rezultatet-e-p%C3%ABrgjithshme-sipas-Subjekteve-2010.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2010-elected-candidates',
      electionId: 'parliamentary-2010',
      title: 'Kandidatët e zgjedhur sipas Subjekteve 2010',
      description:
          'Dokument zyrtar i KQZ për kandidatët e zgjedhur në zgjedhjet parlamentare 2010. Importi i kandidatëve mbetet i bllokuar derisa PDF të jetë plotësisht i lexueshëm dhe i kontrolluar.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2018/04/2.-Kandidat%C3%ABt-e-zgjedhur-sipas-Subjekteve-2010.pdf',
      fileType: 'PDF',
      isResultData: true,
      isCandidateData: true,
      isMunicipalityData: false,
    ),
    ElectionOfficialFile(
      id: 'parliamentary-2010-official-report',
      electionId: 'parliamentary-2010',
      title: 'Raporti i Zgjedhjeve Parlamentare 2010',
      description:
          'Raporti zyrtar i KQZ për zgjedhjet parlamentare 2010. Përdoret si burim verifikues, jo si import automatik i tabelave.',
      url:
          'https://kqz-ks.org/wp-content/uploads/2018/05/Raporti-i-Zgjedhjeve-Parlamentare-2010_FINAL_SHQ.pdf',
      fileType: 'PDF',
      isResultData: false,
      isCandidateData: false,
      isMunicipalityData: false,
    ),
  ];
}
