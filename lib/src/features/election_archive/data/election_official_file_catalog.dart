import '../../../core/models/election_official_file.dart';
import '../../local_elections/data/local_election_official_file_catalog.dart';
import '../../parliamentary_2010/data/parliamentary_2010_official_files.dart';
import '../../parliamentary_2014/data/parliamentary_2014_official_files.dart';
import '../../parliamentary_2017/data/parliamentary_2017_official_files.dart';
import '../../parliamentary_2019/data/parliamentary_2019_official_files.dart';
import '../../parliamentary_2025_december/data/parliamentary_2025_december_official_files.dart';
import '../../parliamentary_2025/data/parliamentary_2025_official_files.dart';
import '../../parliamentary_2021/data/parliamentary_2021_official_files.dart';

class ElectionOfficialFileCatalog {
  const ElectionOfficialFileCatalog._();

  static const List<ElectionOfficialFile> all = [
    ...Parliamentary2025DecemberOfficialFiles.files,
    ...Parliamentary2025OfficialFiles.files,
    ...Parliamentary2021OfficialFiles.files,
    ...Parliamentary2019OfficialFiles.files,
    ...Parliamentary2017OfficialFiles.files,
    ...Parliamentary2014OfficialFiles.files,
    ...Parliamentary2010OfficialFiles.files,
    ...LocalElectionOfficialFileCatalog.files,
  ];

  static List<ElectionOfficialFile> byElectionId(String electionId) {
    return all.where((file) => file.electionId == electionId).toList();
  }

  static List<ElectionOfficialFile> resultFilesFor(String electionId) {
    return all.where((file) => file.electionId == electionId && file.isResultData).toList();
  }

  static List<ElectionOfficialFile> candidateFilesFor(String electionId) {
    return all.where((file) => file.electionId == electionId && file.isCandidateData).toList();
  }

  static List<ElectionOfficialFile> municipalityFilesFor(String electionId) {
    return all.where((file) => file.electionId == electionId && file.isMunicipalityData).toList();
  }
}
