class HistoricalMayorCandidate {
  final String municipalityCode;
  final String municipalityName;
  final String fullName;
  final String subjectName;
  final int votes;
  final double percentage;
  final int round;

  const HistoricalMayorCandidate({
    required this.municipalityCode,
    required this.municipalityName,
    required this.fullName,
    required this.subjectName,
    required this.votes,
    required this.percentage,
    required this.round,
  });
}

class HistoricalMayorMunicipality {
  final String code;
  final String name;
  final int year;
  final List<HistoricalMayorCandidate> firstRound;
  final List<HistoricalMayorCandidate> secondRound;
  final HistoricalMayorCandidate? winner;
  final bool decidedInRunoff;
  final bool finalResultComplete;

  const HistoricalMayorMunicipality({
    required this.code,
    required this.name,
    required this.year,
    required this.firstRound,
    required this.secondRound,
    required this.winner,
    required this.decidedInRunoff,
    required this.finalResultComplete,
  });

  int get firstRoundVotes =>
      firstRound.fold<int>(0, (sum, candidate) => sum + candidate.votes);

  int get finalRoundVotes => secondRound.isEmpty
      ? firstRoundVotes
      : secondRound.fold<int>(0, (sum, candidate) => sum + candidate.votes);
}
