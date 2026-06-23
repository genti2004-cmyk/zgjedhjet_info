class MunicipalityResult {
  final String id;
  final String name;
  final int voters;
  final int votesCast;
  final double turnoutPercentage;
  final String leadingSubject;
  final bool hasVoterStatistics;

  const MunicipalityResult({
    required this.id,
    required this.name,
    required this.voters,
    required this.votesCast,
    required this.turnoutPercentage,
    required this.leadingSubject,
    this.hasVoterStatistics = true,
  });
}