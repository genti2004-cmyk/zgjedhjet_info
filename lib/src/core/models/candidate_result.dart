class CandidateResult {
  final String id;
  final String fullName;
  final String subjectName;
  final String municipalityName;
  final int votes;

  const CandidateResult({
    required this.id,
    required this.fullName,
    required this.subjectName,
    required this.municipalityName,
    required this.votes,
  });
}