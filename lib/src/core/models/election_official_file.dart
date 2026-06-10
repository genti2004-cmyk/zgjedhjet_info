class ElectionOfficialFile {
  final String id;
  final String electionId;
  final String title;
  final String description;
  final String url;
  final String fileType;
  final bool isResultData;
  final bool isCandidateData;
  final bool isMunicipalityData;

  const ElectionOfficialFile({
    required this.id,
    required this.electionId,
    required this.title,
    required this.description,
    required this.url,
    required this.fileType,
    required this.isResultData,
    required this.isCandidateData,
    required this.isMunicipalityData,
  });
}
