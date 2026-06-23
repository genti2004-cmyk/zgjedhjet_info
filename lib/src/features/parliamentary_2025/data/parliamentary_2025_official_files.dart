import '../../../core/models/election_official_file.dart';

class Parliamentary2025OfficialFiles {
  const Parliamentary2025OfficialFiles._();

  static const String electionId = 'parliamentary-2025';

  static const List<ElectionOfficialFile> files = [
    ElectionOfficialFile(
      id: 'parliamentary-2025-detailed-results-by-municipality',
      electionId: electionId,
      title: 'Rezultatet e detajuara sipas komunës dhe vendvotimit',
      description:
          'Skedari zyrtar i KQZ me rezultate sipas kategorisë, komunës, qendrës së votimit, vendvotimit dhe subjektit politik.',
      url:
          'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2025/',
      fileType: 'XLS',
      isResultData: true,
      isCandidateData: false,
      isMunicipalityData: true,
    ),
  ];
}
