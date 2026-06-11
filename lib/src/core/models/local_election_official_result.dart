class LocalMayorResult {
  final String id;
  final String electionId;
  final String roundId;
  final String municipalityId;
  final String municipalityName;
  final String candidateId;
  final String candidateName;
  final String subjectId;
  final String subjectName;
  final String subjectShortName;
  final int votes;
  final double percentage;
  final bool elected;
  final bool isOfficial;

  const LocalMayorResult({
    required this.id,
    required this.electionId,
    required this.roundId,
    required this.municipalityId,
    required this.municipalityName,
    required this.candidateId,
    required this.candidateName,
    required this.subjectId,
    required this.subjectName,
    required this.subjectShortName,
    required this.votes,
    required this.percentage,
    this.elected = false,
    this.isOfficial = true,
  });
}

class LocalAssemblySubjectResult {
  final String id;
  final String electionId;
  final String municipalityId;
  final String municipalityName;
  final String subjectId;
  final String subjectName;
  final String subjectShortName;
  final int votes;
  final double percentage;
  final int seats;
  final bool isOfficial;

  const LocalAssemblySubjectResult({
    required this.id,
    required this.electionId,
    required this.municipalityId,
    required this.municipalityName,
    required this.subjectId,
    required this.subjectName,
    required this.subjectShortName,
    required this.votes,
    required this.percentage,
    required this.seats,
    this.isOfficial = true,
  });
}

class LocalAssemblyCandidateResult {
  final String id;
  final String electionId;
  final String municipalityId;
  final String municipalityName;
  final String candidateId;
  final String candidateName;
  final String subjectId;
  final String subjectName;
  final int votes;
  final bool elected;
  final bool isOfficial;

  const LocalAssemblyCandidateResult({
    required this.id,
    required this.electionId,
    required this.municipalityId,
    required this.municipalityName,
    required this.candidateId,
    required this.candidateName,
    required this.subjectId,
    required this.subjectName,
    required this.votes,
    this.elected = false,
    this.isOfficial = true,
  });
}

class LocalElectionMunicipalitySummary {
  final String id;
  final String electionId;
  final String municipalityId;
  final String municipalityName;
  final int registeredVoters;
  final int votesCast;
  final int validVotes;
  final int invalidVotes;
  final double turnoutPercentage;
  final bool isOfficial;

  const LocalElectionMunicipalitySummary({
    required this.id,
    required this.electionId,
    required this.municipalityId,
    required this.municipalityName,
    required this.registeredVoters,
    required this.votesCast,
    required this.validVotes,
    required this.invalidVotes,
    required this.turnoutPercentage,
    this.isOfficial = true,
  });
}

class LocalElectionOfficialDataSet {
  final String electionId;
  final String sourceTitle;
  final String sourceUrl;
  final List<LocalElectionMunicipalitySummary> municipalitySummaries;
  final List<LocalMayorResult> mayorResults;
  final List<LocalAssemblySubjectResult> assemblySubjectResults;
  final List<LocalAssemblyCandidateResult> assemblyCandidateResults;

  const LocalElectionOfficialDataSet({
    required this.electionId,
    required this.sourceTitle,
    required this.sourceUrl,
    this.municipalitySummaries = const [],
    this.mayorResults = const [],
    this.assemblySubjectResults = const [],
    this.assemblyCandidateResults = const [],
  });

  bool get hasMunicipalitySummaries => municipalitySummaries.isNotEmpty;
  bool get hasMayorResults => mayorResults.isNotEmpty;
  bool get hasAssemblySubjectResults => assemblySubjectResults.isNotEmpty;
  bool get hasAssemblyCandidateResults => assemblyCandidateResults.isNotEmpty;

  bool get isEmpty {
    return municipalitySummaries.isEmpty &&
        mayorResults.isEmpty &&
        assemblySubjectResults.isEmpty &&
        assemblyCandidateResults.isEmpty;
  }
}
