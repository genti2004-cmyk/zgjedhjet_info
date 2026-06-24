import '../models/election_source.dart';

class KqzRemoteConfig {
  const KqzRemoteConfig._();

  static Uri platformUriFor(ElectionSource source) {
    return Uri.parse(endpointFor(source.type));
  }

  static String sourceNameFor(ElectionSource source) {
    switch (source.type) {
      case ElectionSourceType.parliamentary2025December:
        return 'KQZ Parlamentare 28 Dhjetor 2025';
      case ElectionSourceType.parliamentary2025:
        return 'KQZ Parlamentare 9 Shkurt 2025';
      case ElectionSourceType.parliamentary2021:
        return 'KQZ Parlamentare 2021';
      case ElectionSourceType.parliamentary2019:
        return 'KQZ Parlamentare 2019';
      case ElectionSourceType.parliamentary2017:
        return 'KQZ Parlamentare 2017';
      case ElectionSourceType.parliamentary2014:
        return 'KQZ Parlamentare 2014';
      case ElectionSourceType.parliamentary2010:
        return 'KQZ Parlamentare 2010';
      case ElectionSourceType.parliamentary2007:
        return 'OSBE/CEC Parlamentare 2007';
      case ElectionSourceType.parliamentary2004:
        return 'OSBE/CEC Parlamentare 2004';
      case ElectionSourceType.parliamentary2001:
        return 'OSBE/OMiK Parlamentare 2001';
      case ElectionSourceType.local2017:
        return 'KQZ Lokale 2017';
      case ElectionSourceType.local2025:
        return 'KQZ Lokale 2025';
      case ElectionSourceType.local2025Round2:
        return 'KQZ Lokale 2025 Raundi II';
    }
  }

  static String endpointFor(ElectionSourceType type) {
    switch (type) {
      case ElectionSourceType.parliamentary2025December:
        return 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/';
      case ElectionSourceType.parliamentary2025:
        return 'https://resultsparliamentary2025.kqz-ks.org/';
      case ElectionSourceType.parliamentary2021:
        return 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2021/';
      case ElectionSourceType.parliamentary2019:
        return 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2019/';
      case ElectionSourceType.parliamentary2017:
        return 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2017/';
      case ElectionSourceType.parliamentary2014:
        return 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2014/';
      case ElectionSourceType.parliamentary2010:
        return 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvend-te-kosoves/';
      case ElectionSourceType.parliamentary2007:
      case ElectionSourceType.parliamentary2004:
      case ElectionSourceType.parliamentary2001:
        return 'https://www.osce.org/mission-in-kosovo';
      case ElectionSourceType.local2017:
        return 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvende-komunale/';
      case ElectionSourceType.local2025:
        return 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kryetare-te-komunave/';
      case ElectionSourceType.local2025Round2:
        return 'https://resultslocal2025r2.kqz-ks.org/';
    }
  }
}
