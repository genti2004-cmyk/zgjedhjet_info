class ElectionArchiveItem {
  final String id;
  final String title;
  final String shortTitle;
  final String type;
  final String dateLabel;
  final String statusLabel;
  final String sourceUrl;
  final bool hasOfficialResultsInApp;
  final bool hasCandidateDataInApp;
  final bool hasMunicipalityDataInApp;

  const ElectionArchiveItem({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.type,
    required this.dateLabel,
    required this.statusLabel,
    required this.sourceUrl,
    required this.hasOfficialResultsInApp,
    required this.hasCandidateDataInApp,
    required this.hasMunicipalityDataInApp,
  });
}
