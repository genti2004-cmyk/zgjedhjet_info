import '../models/election_source.dart';

class ElectionDataStatus {
  const ElectionDataStatus._();

  static bool hasOfficialPartyResults(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014 ||
        source.type == ElectionSourceType.parliamentary2010 ||
        source.type == ElectionSourceType.local2017;
  }

  static bool hasOfficialElectedCandidates(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014 ||
        source.type == ElectionSourceType.parliamentary2010 ||
        source.type == ElectionSourceType.local2017;
  }

  static bool isSourceOnly(ElectionSource source) {
    return false;
  }

  static bool hasCandidateSourcesOnly(ElectionSource source) {
    return false;
  }

  static bool isParliamentary(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014 ||
        source.type == ElectionSourceType.parliamentary2010;
  }

  static bool hasRegisteredMunicipalitySources(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014 ||
        source.type == ElectionSourceType.parliamentary2010;
  }

  static bool hasOfficialMunicipalityResults(ElectionSource source) {
    return source.type == ElectionSourceType.parliamentary2025 ||
        source.type == ElectionSourceType.parliamentary2021 ||
        source.type == ElectionSourceType.parliamentary2019 ||
        source.type == ElectionSourceType.parliamentary2017 ||
        source.type == ElectionSourceType.parliamentary2014 ||
        source.type == ElectionSourceType.parliamentary2010;
  }

  static String resultEmptyMessage(ElectionSource source) {
    if (isSourceOnly(source)) {
      return 'Burimet zyrtare për ${source.shortTitle} janë regjistruar. Rezultatet do të shfaqen pasi skedarët e KQZ të verifikohen plotësisht.';
    }

    return 'Nuk ka ende rezultate për t’u shfaqur.';
  }

  static String candidateEmptyMessage(ElectionSource source) {
    if (hasCandidateSourcesOnly(source)) {
      return 'Burimet zyrtare për kandidatët e ${source.shortTitle} janë regjistruar. Kandidatët do të shfaqen pasi skedarët e KQZ të verifikohen plotësisht.';
    }

    return 'Nuk ka ende kandidatë për t’u shfaqur.';
  }
}
