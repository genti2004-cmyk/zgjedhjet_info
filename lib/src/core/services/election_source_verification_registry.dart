import '../models/election_source_verification.dart';

class ElectionSourceVerificationRegistry {
  const ElectionSourceVerificationRegistry._();

  static const List<ElectionSourceVerification> items = [
    ElectionSourceVerification(
      id: 'parliamentary-municipalities-official-results-page',
      electionId: 'parliamentary',
      title: 'Rezultatet sipas komunave për zgjedhjet parlamentare',
      officialUrl: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvend-te-kosoves/',
      status: 'Burim zyrtar i verifikuar, import i bllokuar',
      sourceVerified: true,
      dataImportAllowed: false,
      note:
          'Faqja zyrtare e KQZ për rezultatet e Kuvendit përmban seksione për rezultate sipas komunave/kandidatëve. Importi i numrave bëhet vetëm pas verifikimit të plotë të skedarëve individualë.',
    ),
    ElectionSourceVerification(
      id: 'parliamentary-2017-official-page',
      electionId: 'parliamentary-2017',
      title: 'Zgjedhjet për Kuvend të Kosovës 2017',
      officialUrl:
          'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2017/',
      status: 'Burim zyrtar i verifikuar, import i bllokuar',
      sourceVerified: true,
      dataImportAllowed: false,
      note:
          'Faqja zyrtare e KQZ për 2017 është verifikuar. Numrat nuk importohen derisa PDF/XLS/XLSX zyrtarë të jenë të lexueshëm dhe të kontrolluar.',
    ),
    ElectionSourceVerification(
      id: 'parliamentary-2010-official-results-page',
      electionId: 'parliamentary-2010',
      title: 'Zgjedhjet për Kuvend të Kosovës 2010',
      officialUrl: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvend-te-kosoves/',
      status: 'Burim zyrtar i verifikuar, import i bllokuar',
      sourceVerified: true,
      dataImportAllowed: false,
      note:
          'Faqja zyrtare e rezultateve të Kuvendit përmban seksione për 2010, përfshirë rezultate të subjekteve, ulëse, kandidatët e zgjedhur dhe rezultate sipas komunave. Importi mbetet i bllokuar pa kontroll të skedarëve individualë.',
    ),
    ElectionSourceVerification(
      id: 'parliamentary-2010-official-report',
      electionId: 'parliamentary-2010',
      title: 'Raporti i Zgjedhjeve Parlamentare 2010',
      officialUrl:
          'https://kqz-ks.org/wp-content/uploads/2018/05/Raporti-i-Zgjedhjeve-Parlamentare-2010_FINAL_SHQ.pdf',
      status: 'Raport zyrtar i verifikuar, import i bllokuar',
      sourceVerified: true,
      dataImportAllowed: false,
      note:
          'Raporti zyrtar i KQZ për zgjedhjet parlamentare 2010 është burim mbështetës. Nuk përdoret për import automatik të numrave pa kontroll të tabelave.',
    ),
  ];

  static List<ElectionSourceVerification> byElectionId(String electionId) {
    return items.where((item) => item.electionId == electionId).toList();
  }

  static bool hasVerifiedSource(String electionId) {
    return byElectionId(electionId).any((item) => item.sourceVerified);
  }

  static bool dataImportAllowed(String electionId) {
    return byElectionId(electionId).any((item) => item.dataImportAllowed);
  }
}
