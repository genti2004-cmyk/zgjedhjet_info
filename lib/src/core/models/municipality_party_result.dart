class MunicipalityPartyResult {
  final String id;
  final String municipalityName;
  final String subjectCode;
  final String subjectName;
  final String shortName;
  final int votes;
  final double percentage;
  final int rank;

  const MunicipalityPartyResult({
    required this.id,
    required this.municipalityName,
    required this.subjectCode,
    required this.subjectName,
    required this.shortName,
    required this.votes,
    required this.percentage,
    required this.rank,
  });
}
