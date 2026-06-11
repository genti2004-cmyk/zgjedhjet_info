class ElectionDataImportPlan {
  final String id;
  final String electionId;
  final String title;
  final String category;
  final String officialUrl;
  final String status;
  final bool sourceVerified;
  final bool directFileVerified;
  final bool importAllowed;
  final String nextAction;
  final String note;

  const ElectionDataImportPlan({
    required this.id,
    required this.electionId,
    required this.title,
    required this.category,
    required this.officialUrl,
    required this.status,
    required this.sourceVerified,
    required this.directFileVerified,
    required this.importAllowed,
    required this.nextAction,
    required this.note,
  });
}
