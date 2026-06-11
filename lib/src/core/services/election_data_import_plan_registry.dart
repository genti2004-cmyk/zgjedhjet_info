import '../models/election_data_import_plan.dart';

class ElectionDataImportPlanRegistry {
  const ElectionDataImportPlanRegistry._();

  static const List<ElectionDataImportPlan> plans = [
    ElectionDataImportPlan(
      id: 'a-2017-party-results',
      electionId: 'parliamentary-2017',
      title: '2017 – Rezultatet e subjekteve politike',
      category: 'A',
      officialUrl:
          'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2017/',
      status: 'Burim zyrtar i gjetur, import i bllokuar',
      sourceVerified: true,
      directFileVerified: false,
      importAllowed: false,
      nextAction:
          'Gjej dhe kontrollo skedarin konkret PDF/XLS/XLSX të rezultateve sipas subjekteve për 2017.',
      note:
          'Faqja zyrtare e KQZ për 2017 është verifikuar. Numrat nuk importohen derisa skedari konkret i rezultateve të jetë plotësisht i lexueshëm dhe i kontrolluar.',
    ),
    ElectionDataImportPlan(
      id: 'b-2010-party-results',
      electionId: 'parliamentary-2010',
      title: '2010 – Rezultatet e subjekteve politike',
      category: 'B',
      officialUrl: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvend-te-kosoves/',
      status: 'Burim zyrtar i gjetur, import i bllokuar',
      sourceVerified: true,
      directFileVerified: false,
      importAllowed: false,
      nextAction:
          'Hap skedarin konkret "Rezultatet e përgjithshme sipas Subjekteve 2010" dhe kontrollo tabelat para importit.',
      note:
          'Faqja zyrtare e rezultateve të Kuvendit përmban seksionin 2010 dhe dokumente për subjektet, ulëset, kandidatët dhe komunat. Importi mbetet i bllokuar pa skedarin konkret.',
    ),
    ElectionDataImportPlan(
      id: 'b-2010-official-report',
      electionId: 'parliamentary-2010',
      title: '2010 – Raporti zyrtar mbështetës',
      category: 'B',
      officialUrl:
          'https://kqz-ks.org/wp-content/uploads/2018/05/Raporti-i-Zgjedhjeve-Parlamentare-2010_FINAL_SHQ.pdf',
      status: 'Raport zyrtar i gjetur, import i bllokuar',
      sourceVerified: true,
      directFileVerified: true,
      importAllowed: false,
      nextAction:
          'Përdor raportin vetëm si burim verifikues; importi i rezultateve bëhet nga tabelat zyrtare të rezultateve nëse janë plotësisht të lexueshme.',
      note:
          'Raporti është PDF zyrtar i KQZ, por nuk zëvendëson kontrollin e tabelave të rezultateve për import të saktë.',
    ),
    ElectionDataImportPlan(
      id: 'c-parliamentary-municipality-results',
      electionId: 'parliamentary',
      title: 'Komunat – rezultatet sipas komunave për zgjedhjet parlamentare',
      category: 'C',
      officialUrl: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvend-te-kosoves/',
      status: 'Burim zyrtar i gjetur, import i bllokuar',
      sourceVerified: true,
      directFileVerified: false,
      importAllowed: false,
      nextAction:
          'Zgjidh një vit dhe një skedar konkret për rezultatet sipas komunave; importo vetëm pas kontrollit të plotë.',
      note:
          'Faqja zyrtare për rezultatet e Kuvendit përmban seksione për rezultate të kandidatëve/subjekteve sipas komunave. Importi mbetet i bllokuar pa skedar konkret.',
    ),
  ];

  static List<ElectionDataImportPlan> byCategory(String category) {
    return plans.where((plan) => plan.category == category).toList();
  }

  static List<ElectionDataImportPlan> byElectionId(String electionId) {
    return plans.where((plan) => plan.electionId == electionId).toList();
  }

  static bool hasVerifiedSource(String electionId) {
    return byElectionId(electionId).any((plan) => plan.sourceVerified);
  }

  static bool hasImportAllowed(String electionId) {
    return byElectionId(electionId).any((plan) => plan.importAllowed);
  }

  static List<ElectionDataImportPlan> blockedPlans() {
    return plans.where((plan) => !plan.importAllowed).toList();
  }
}
