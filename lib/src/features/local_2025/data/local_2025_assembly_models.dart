class Local2025AssemblyPartyResult {
  final String municipalityName;
  final int subjectCode;
  final String subjectName;
  final int seats;
  final int votes;
  final double percentage;

  const Local2025AssemblyPartyResult({
    required this.municipalityName,
    required this.subjectCode,
    required this.subjectName,
    required this.seats,
    required this.votes,
    required this.percentage,
  });
}

class Local2025ElectedCandidate {
  final String municipalityName;
  final int subjectCode;
  final String subjectName;
  final int rank;
  final String fullName;
  final String gender;
  final int votes;

  const Local2025ElectedCandidate({
    required this.municipalityName,
    required this.subjectCode,
    required this.subjectName,
    required this.rank,
    required this.fullName,
    required this.gender,
    required this.votes,
  });
}

class Local2025MunicipalityStatistics {
  final String municipalityName;
  final int electorate;
  final int votersTotal;
  final int regularVoters;
  final int specialAndPostalVoters;
  final double turnout;
  final int validBallots;
  final int invalidAndBlankBallots;
  final int damagedBallots;
  final int assemblySeats;

  const Local2025MunicipalityStatistics({
    required this.municipalityName,
    required this.electorate,
    required this.votersTotal,
    required this.regularVoters,
    required this.specialAndPostalVoters,
    required this.turnout,
    required this.validBallots,
    required this.invalidAndBlankBallots,
    required this.damagedBallots,
    required this.assemblySeats,
  });
}
