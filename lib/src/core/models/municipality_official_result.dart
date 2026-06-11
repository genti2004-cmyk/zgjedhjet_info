class MunicipalityPartyResult {
  final String id;
  final String municipalityId;
  final String municipalityName;
  final String electionId;
  final String subjectId;
  final String subjectName;
  final String subjectShortName;
  final int votes;
  final double percentage;
  final bool isOfficial;

  const MunicipalityPartyResult({
    required this.id,
    required this.municipalityId,
    required this.municipalityName,
    required this.electionId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectShortName,
    required this.votes,
    required this.percentage,
    this.isOfficial = true,
  });
}

class MunicipalityCandidateResult {
  final String id;
  final String municipalityId;
  final String municipalityName;
  final String electionId;
  final String candidateId;
  final String candidateName;
  final String subjectId;
  final String subjectName;
  final int votes;
  final bool isOfficial;

  const MunicipalityCandidateResult({
    required this.id,
    required this.municipalityId,
    required this.municipalityName,
    required this.electionId,
    required this.candidateId,
    required this.candidateName,
    required this.subjectId,
    required this.subjectName,
    required this.votes,
    this.isOfficial = true,
  });
}

class MunicipalityOfficialSummary {
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

  const MunicipalityOfficialSummary({
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

class MunicipalityOfficialDataSet {
  final String electionId;
  final String sourceTitle;
  final String sourceUrl;
  final List<MunicipalityOfficialSummary> summaries;
  final List<MunicipalityPartyResult> partyResults;
  final List<MunicipalityCandidateResult> candidateResults;

  const MunicipalityOfficialDataSet({
    required this.electionId,
    required this.sourceTitle,
    required this.sourceUrl,
    this.summaries = const [],
    this.partyResults = const [],
    this.candidateResults = const [],
  });

  bool get hasSummaries => summaries.isNotEmpty;
  bool get hasPartyResults => partyResults.isNotEmpty;
  bool get hasCandidateResults => candidateResults.isNotEmpty;
  bool get isEmpty => summaries.isEmpty && partyResults.isEmpty && candidateResults.isEmpty;
}
