import '../models/election_source.dart';

class KqzRemoteConfig {
  const KqzRemoteConfig._();

  static Uri platformUriFor(ElectionSource source) {
    return Uri.parse(source.officialUrl);
  }

  static String sourceNameFor(ElectionSource source) {
    switch (source.type) {
      case ElectionSourceType.parliamentary2025:
        return 'Rezultatet Parlamentare 2025';
      case ElectionSourceType.local2025:
        return 'Rezultatet Lokale 2025';
      case ElectionSourceType.local2025Round2:
        return 'Rezultatet Lokale 2025 - Raundi II';
    }
  }
}
