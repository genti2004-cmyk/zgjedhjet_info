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
      status: 'Importuar',
      sourceVerified: true,
      directFileVerified: true,
      importAllowed: true,
      nextAction:
          'Të dhënat e subjekteve 2017 janë importuar. Hapi tjetër: kandidatët ose komunat.',
      note:
          'Rezultatet e subjekteve 2017 janë importuar nga dokument zyrtar i KQZ.',
    ),
    ElectionDataImportPlan(
      id: 'b-2010-party-results',
      electionId: 'parliamentary-2010',
      title: '2010 – Rezultatet e subjekteve politike',
      category: 'B',
      officialUrl:
          'https://kqz-ks.org/wp-content/uploads/2018/04/1.-Rezultatet-e-p%C3%ABrgjithshme-sipas-Subjekteve-2010.pdf',
      status: 'Importuar',
      sourceVerified: true,
      directFileVerified: true,
      importAllowed: true,
      nextAction:
          'Të dhënat e subjekteve 2010 janë importuar. Hapi tjetër: kandidatët ose komunat.',
      note:
          'Rezultatet e subjekteve 2010 janë importuar nga dokument zyrtar i KQZ.',
    ),
    ElectionDataImportPlan(
      id: 'b-2010-elected-candidates',
      electionId: 'parliamentary-2010',
      title: '2010 – Kandidatët e zgjedhur sipas subjekteve',
      category: 'B',
      officialUrl:
          'https://kqz-ks.org/wp-content/uploads/2018/04/2.-Kandidat%C3%ABt-e-zgjedhur-sipas-Subjekteve-2010.pdf',
      status: 'Burim zyrtar i gjetur, import i bllokuar',
      sourceVerified: true,
      directFileVerified: false,
      importAllowed: false,
      nextAction:
          'Ngarko PDF-në zyrtare ose siguro qasje të plotë në dokument për të lexuar 120 kandidatët e zgjedhur dhe votat e tyre.',
      note:
          'Dokumenti zyrtar ekziston, por importi nuk bëhet pa lexim të plotë të tabelës. Nuk lejohen emra/vota të improvizuara.',
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
