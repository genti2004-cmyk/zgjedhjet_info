enum ElectionSourceType {
  parliamentary2025,
  parliamentary2021,
  local2025,
  local2025Round2,
}

class ElectionSource {
  final ElectionSourceType type;
  final String title;
  final String shortTitle;
  final String description;
  final String officialUrl;
  final String dateLabel;

  const ElectionSource({
    required this.type,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.officialUrl,
    required this.dateLabel,
  });

  static const ElectionSource parliamentary2025 = ElectionSource(
    type: ElectionSourceType.parliamentary2025,
    title: 'Zgjedhjet për Kuvendin e Kosovës 2025',
    shortTitle: 'Parlamentare 2025',
    description:
        'Rezultatet për subjektet politike, kandidatët dhe statistikat e zgjedhjeve parlamentare.',
    officialUrl: 'https://resultsparliamentary2025.kqz-ks.org/',
    dateLabel: '09.02.2025',
  );

  static const ElectionSource parliamentary2021 = ElectionSource(
    type: ElectionSourceType.parliamentary2021,
    title: 'Zgjedhjet për Kuvendin e Kosovës 2021',
    shortTitle: 'Parlamentare 2021',
    description:
        'Rezultatet e përgjithshme sipas subjekteve politike dhe ndarja e mandateve nga dokumentet zyrtare të KQZ.',
    officialUrl:
        'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2021/',
    dateLabel: '14.02.2021',
  );

  static const ElectionSource local2025 = ElectionSource(
    type: ElectionSourceType.local2025,
    title: 'Zgjedhjet Lokale 2025',
    shortTitle: 'Lokale 2025',
    description:
        'Rezultatet për kryetarë komunash, kuvende komunale dhe pjesëmarrje sipas komunave.',
    officialUrl: 'https://resultslocal2025.kqz-ks.org/',
    dateLabel: '12.10.2025',
  );

  static const ElectionSource local2025Round2 = ElectionSource(
    type: ElectionSourceType.local2025Round2,
    title: 'Zgjedhjet Lokale 2025 - Raundi II',
    shortTitle: 'Lokale R2',
    description:
        'Rezultatet e raundit të dytë për kryetarë komunash në komunat përkatëse.',
    officialUrl: 'https://resultslocal2025r2.kqz-ks.org/',
    dateLabel: '09.11.2025',
  );

  static const List<ElectionSource> all = [
    parliamentary2025,
    parliamentary2021,
    local2025,
    local2025Round2,
  ];
}
