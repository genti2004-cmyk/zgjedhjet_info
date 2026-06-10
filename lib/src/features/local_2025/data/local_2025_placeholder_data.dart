import '../../../core/models/candidate_result.dart';
import '../../../core/models/municipality_result.dart';
import '../../../core/models/party_result.dart';

class Local2025PlaceholderData {
  const Local2025PlaceholderData._();

  static const List<PartyResult> localPartyResults = [
    PartyResult(
      id: 'local-mayors',
      name: 'Rezultatet për Kryetarë Komunash',
      shortName: 'KRY',
      votes: 0,
      percentage: 0,
      seats: 0,
    ),
    PartyResult(
      id: 'local-assemblies',
      name: 'Rezultatet për Kuvende Komunale',
      shortName: 'KUV',
      votes: 0,
      percentage: 0,
      seats: 0,
    ),
    PartyResult(
      id: 'local-turnout',
      name: 'Pjesëmarrja sipas Komunave',
      shortName: 'DAL',
      votes: 0,
      percentage: 0,
      seats: 0,
    ),
  ];

  static const List<PartyResult> localRound2PartyResults = [
    PartyResult(
      id: 'local-r2-mayors',
      name: 'Rezultatet për Kryetarë Komunash - Raundi II',
      shortName: 'R2',
      votes: 0,
      percentage: 0,
      seats: 0,
    ),
    PartyResult(
      id: 'local-r2-turnout',
      name: 'Pjesëmarrja në Raundin II',
      shortName: 'DAL',
      votes: 0,
      percentage: 0,
      seats: 0,
    ),
  ];

  static const List<MunicipalityResult> parliamentaryMunicipalitiesPlaceholder = [
    MunicipalityResult(
      id: 'prishtine',
      name: 'Prishtinë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Në pritje nga KQZ',
    ),
    MunicipalityResult(
      id: 'prizren',
      name: 'Prizren',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Në pritje nga KQZ',
    ),
    MunicipalityResult(
      id: 'peje',
      name: 'Pejë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Në pritje nga KQZ',
    ),
    MunicipalityResult(
      id: 'mitrovice',
      name: 'Mitrovicë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Në pritje nga KQZ',
    ),
  ];

  static const List<MunicipalityResult> localMunicipalitiesPlaceholder = [
    MunicipalityResult(
      id: 'decan',
      name: 'Deçan',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Lokale 2025',
    ),
    MunicipalityResult(
      id: 'gjakove',
      name: 'Gjakovë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Lokale 2025',
    ),
    MunicipalityResult(
      id: 'gjilan',
      name: 'Gjilan',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Lokale 2025',
    ),
    MunicipalityResult(
      id: 'prishtine',
      name: 'Prishtinë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Lokale 2025',
    ),
    MunicipalityResult(
      id: 'prizren',
      name: 'Prizren',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Lokale 2025',
    ),
  ];

  static const List<MunicipalityResult> localRound2MunicipalitiesPlaceholder = [
    MunicipalityResult(
      id: 'gjakove',
      name: 'Gjakovë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Raundi II',
    ),
    MunicipalityResult(
      id: 'gjilan',
      name: 'Gjilan',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Raundi II',
    ),
    MunicipalityResult(
      id: 'prishtine',
      name: 'Prishtinë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Raundi II',
    ),
    MunicipalityResult(
      id: 'prizren',
      name: 'Prizren',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Raundi II',
    ),
    MunicipalityResult(
      id: 'peje',
      name: 'Pejë',
      voters: 0,
      votesCast: 0,
      turnoutPercentage: 0,
      leadingSubject: 'Raundi II',
    ),
  ];

  static const List<CandidateResult> localCandidatesPlaceholder = [
    CandidateResult(
      id: 'local-candidate-1',
      fullName: 'Kandidati për Kryetar Komune 1',
      subjectName: 'Zgjedhjet Lokale 2025',
      municipalityName: 'Prishtinë',
      votes: 0,
    ),
    CandidateResult(
      id: 'local-candidate-2',
      fullName: 'Kandidati për Kryetar Komune 2',
      subjectName: 'Zgjedhjet Lokale 2025',
      municipalityName: 'Prizren',
      votes: 0,
    ),
    CandidateResult(
      id: 'local-candidate-3',
      fullName: 'Kandidati për Kuvend Komunal 1',
      subjectName: 'Zgjedhjet Lokale 2025',
      municipalityName: 'Pejë',
      votes: 0,
    ),
  ];

  static const List<CandidateResult> localRound2CandidatesPlaceholder = [
    CandidateResult(
      id: 'local-r2-candidate-1',
      fullName: 'Kandidati Raundi II 1',
      subjectName: 'Raundi II',
      municipalityName: 'Prishtinë',
      votes: 0,
    ),
    CandidateResult(
      id: 'local-r2-candidate-2',
      fullName: 'Kandidati Raundi II 2',
      subjectName: 'Raundi II',
      municipalityName: 'Prizren',
      votes: 0,
    ),
  ];
}
