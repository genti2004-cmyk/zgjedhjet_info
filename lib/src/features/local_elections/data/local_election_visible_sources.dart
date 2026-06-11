import '../../../core/models/election_official_file.dart';
import 'local_election_official_file_catalog.dart';

class LocalElectionVisibleSources {
  const LocalElectionVisibleSources._();

  static List<ElectionOfficialFile> all() {
    return LocalElectionOfficialFileCatalog.files;
  }

  static List<ElectionOfficialFile> byElectionId(String electionId) {
    return LocalElectionOfficialFileCatalog.byElectionId(electionId);
  }

  static bool hasVisibleSources(String electionId) {
    return LocalElectionOfficialFileCatalog.hasFilesFor(electionId);
  }
}
