import '../models/election_source.dart';

class ElectionDataStatus {
  const ElectionDataStatus._();

  static bool hasOfficialPartyResults(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025December ||
        source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014 ||
        source.type == ElectionSourceType.parliamentary2010 ||
        source.type == ElectionSourceType.local2017 ||
        source.type == ElectionSourceType.local2017Mayor ||
        source.type == ElectionSourceType.local2021Mayor ||
        source.type == ElectionSourceType.local2025 ||
        source.type == ElectionSourceType.local2025Round2;
  }

  static bool hasOfficialElectedCandidates(ElectionSource source) {
    return hasOfficialPartyResults(source);
  }

  static bool isSourceOnly(ElectionSource source) => false;

  static bool hasCandidateSourcesOnly(ElectionSource source) => false;

  static bool isParliamentary(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025December ||
        source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014 ||
        source.type == ElectionSourceType.parliamentary2010 ||
        source.type == ElectionSourceType.parliamentary2007 ||
        source.type == ElectionSourceType.parliamentary2004 ||
        source.type == ElectionSourceType.parliamentary2001;
  }

  static bool hasRegisteredMunicipalitySources(ElectionSource source) {
    return isParliamentary(source) &&
        source.type != ElectionSourceType.parliamentary2025December &&
        source.type != ElectionSourceType.parliamentary2025;
  }

  static bool hasOfficialMunicipalityResults(ElectionSource source) {
    return isParliamentary(source) ||
        source.type == ElectionSourceType.local2017Mayor ||
        source.type == ElectionSourceType.local2021Mayor ||
        source.type == ElectionSourceType.local2025 ||
        source.type == ElectionSourceType.local2025Round2;
  }

  static String resultEmptyMessage(ElectionSource source) {
    return 'Nuk ka ende rezultate për t’u shfaqur.';
  }

  static String candidateEmptyMessage(ElectionSource source) {
    return 'Nuk ka ende kandidatë për t’u shfaqur.';
  }
}
