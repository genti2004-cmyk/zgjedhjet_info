import '../models/election_source.dart';

class ElectionDataStatus {
  const ElectionDataStatus._();

  static bool hasOfficialPartyResults(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2014;
  }

  static bool hasOfficialElectedCandidates(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2014;
  }

  static bool hasOfficialMunicipalityResults(ElectionSource source) {
    return false;
  }

  static bool isParliamentary(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014;
  }
}
