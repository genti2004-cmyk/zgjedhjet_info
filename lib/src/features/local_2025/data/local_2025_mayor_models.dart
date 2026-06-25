class Local2025MayorCandidate {
  final String municipalityCode;
  final String municipalityName;
  final String fullName;
  final String subjectName;
  final int votes;
  final double percentage;
  final int round;

  const Local2025MayorCandidate({
    required this.municipalityCode,
    required this.municipalityName,
    required this.fullName,
    required this.subjectName,
    required this.votes,
    required this.percentage,
    required this.round,
  });
}

class Local2025MayorMunicipality {
  final String code;
  final String name;
  final List<Local2025MayorCandidate> firstRound;
  final List<Local2025MayorCandidate> secondRound;
  final Local2025MayorCandidate winner;
  final bool decidedInRunoff;

  const Local2025MayorMunicipality({
    required this.code,
    required this.name,
    required this.firstRound,
    required this.secondRound,
    required this.winner,
    required this.decidedInRunoff,
  });

  int get firstRoundVotes =>
      firstRound.fold<int>(0, (sum, candidate) => sum + candidate.votes);

  int get finalRoundVotes => secondRound.isEmpty
      ? firstRoundVotes
      : secondRound.fold<int>(0, (sum, candidate) => sum + candidate.votes);
}
