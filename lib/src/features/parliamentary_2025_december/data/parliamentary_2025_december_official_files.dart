import '../../../core/models/election_official_file.dart';

class Parliamentary2025DecemberOfficialFiles {
  const Parliamentary2025DecemberOfficialFiles._();

  static const String electionId = 'parliamentary-2025-december';
  static const String sourceUrl = 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/';

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(id: 'parliamentary-2025-december-party-results', electionId: electionId, title: 'Rezultatet e përgjithshme sipas subjekteve politike', description: 'Rezultatet përfundimtare zyrtare të subjekteve politike për zgjedhjet e parakohshme të 28 dhjetorit 2025.', url: sourceUrl, fileType: 'PDF', isResultData: true, isCandidateData: false, isMunicipalityData: false),
    ElectionOfficialFile(id: 'parliamentary-2025-december-elected-candidates', electionId: electionId, title: 'Ndarja e ulëseve dhe kandidatët e zgjedhur', description: 'Dokumenti zyrtar i KQZ me 120 ulëset dhe kandidatët e zgjedhur.', url: sourceUrl, fileType: 'PDF', isResultData: true, isCandidateData: true, isMunicipalityData: false),
    ElectionOfficialFile(id: 'parliamentary-2025-december-all-candidates', electionId: electionId, title: 'Rezultatet e të gjithë kandidatëve', description: 'Lista zyrtare e kandidatëve dhe votat e tyre.', url: sourceUrl, fileType: 'PDF', isResultData: false, isCandidateData: true, isMunicipalityData: false),
    ElectionOfficialFile(id: 'parliamentary-2025-december-detailed-parties', electionId: electionId, title: 'Rezultatet e detajuara për subjektet politike', description: 'Rezultatet sipas kategorisë, komunës, qendrës së votimit dhe vendvotimit.', url: sourceUrl, fileType: 'XLSX', isResultData: true, isCandidateData: false, isMunicipalityData: true),
    ElectionOfficialFile(id: 'parliamentary-2025-december-detailed-candidates', electionId: electionId, title: 'Rezultatet e detajuara për kandidatët', description: 'Votat e kandidatëve sipas kategorisë, komunës, qendrës së votimit dhe vendvotimit.', url: sourceUrl, fileType: 'XLSX', isResultData: false, isCandidateData: true, isMunicipalityData: true),
    ElectionOfficialFile(id: 'parliamentary-2025-december-seat-formula', electionId: electionId, title: 'Formula e ndarjes së vendeve në Kuvend', description: 'Dokumenti zyrtar i KQZ për llogaritjen dhe ndarjen e ulëseve.', url: sourceUrl, fileType: 'PDF', isResultData: true, isCandidateData: false, isMunicipalityData: false),
  ];
}
