class ElectionSourceVerification {
  final String id;
  final String electionId;
  final String title;
  final String officialUrl;
  final String status;
  final bool sourceVerified;
  final bool dataImportAllowed;
  final String note;

  const ElectionSourceVerification({
    required this.id,
    required this.electionId,
    required this.title,
    required this.officialUrl,
    required this.status,
    required this.sourceVerified,
    required this.dataImportAllowed,
    required this.note,
  });
}
