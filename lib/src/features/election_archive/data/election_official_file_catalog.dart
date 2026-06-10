import '../../../core/models/election_official_file.dart';
import '../../parliamentary_2021/data/parliamentary_2021_official_files.dart';

class ElectionOfficialFileCatalog {
  const ElectionOfficialFileCatalog._();

  static const List<ElectionOfficialFile> all = [
    ...Parliamentary2021OfficialFiles.files,
  ];

  static List<ElectionOfficialFile> byElectionId(String electionId) {
    return all.where((file) => file.electionId == electionId).toList();
  }

  static List<ElectionOfficialFile> resultFilesFor(String electionId) {
    return all
        .where((file) => file.electionId == electionId && file.isResultData)
        .toList();
  }

  static List<ElectionOfficialFile> candidateFilesFor(String electionId) {
    return all
        .where((file) => file.electionId == electionId && file.isCandidateData)
        .toList();
  }

  static List<ElectionOfficialFile> municipalityFilesFor(String electionId) {
    return all
        .where((file) => file.electionId == electionId && file.isMunicipalityData)
        .toList();
  }
}
