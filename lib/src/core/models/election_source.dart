enum ElectionSourceType {
  parliamentary2025,
  parliamentary2021,
  parliamentary2019,
  parliamentary2017,
  parliamentary2014,
  parliamentary2010,
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

  static const ElectionSource parliamentary2025 = ElectionSource(type: ElectionSourceType.parliamentary2025, title: 'Zgjedhjet për Kuvendin e Kosovës 2025', shortTitle: 'Parlamentare 2025', description: 'Rezultatet për subjektet politike, kandidatët dhe statistikat e zgjedhjeve parlamentare.', officialUrl: 'https://resultsparliamentary2025.kqz-ks.org/', dateLabel: '09.02.2025');
  static const ElectionSource parliamentary2021 = ElectionSource(type: ElectionSourceType.parliamentary2021, title: 'Zgjedhjet për Kuvendin e Kosovës 2021', shortTitle: 'Parlamentare 2021', description: 'Rezultatet e përgjithshme sipas subjekteve politike dhe ndarja e mandateve nga dokumentet zyrtare të KQZ.', officialUrl: 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2021/', dateLabel: '14.02.2021');
  static const ElectionSource parliamentary2019 = ElectionSource(type: ElectionSourceType.parliamentary2019, title: 'Zgjedhjet për Kuvendin e Kosovës 2019', shortTitle: 'Parlamentare 2019', description: 'Rezultatet e përgjithshme sipas subjekteve politike dhe ndarja e mandateve nga dokumentet zyrtare të KQZ.', officialUrl: 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2019/', dateLabel: '06.10.2019');
  static const ElectionSource parliamentary2017 = ElectionSource(type: ElectionSourceType.parliamentary2017, title: 'Zgjedhjet për Kuvendin e Kosovës 2017', shortTitle: 'Parlamentare 2017', description: 'Burimet zyrtare të KQZ janë regjistruar. Rezultatet numerike do të vendosen vetëm pas verifikimit të plotë të skedarëve.', officialUrl: 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2017/', dateLabel: '11.06.2017');
  static const ElectionSource parliamentary2014 = ElectionSource(type: ElectionSourceType.parliamentary2014, title: 'Zgjedhjet për Kuvendin e Kosovës 2014', shortTitle: 'Parlamentare 2014', description: 'Rezultatet dhe kandidatët e zgjedhur nga dokumentet zyrtare të KQZ.', officialUrl: 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2014/', dateLabel: '08.06.2014');
  static const ElectionSource parliamentary2010 = ElectionSource(type: ElectionSourceType.parliamentary2010, title: 'Zgjedhjet për Kuvendin e Kosovës 2010', shortTitle: 'Parlamentare 2010', description: 'Burimet zyrtare të KQZ janë regjistruar. Rezultatet numerike do të vendosen vetëm pas verifikimit të plotë të skedarëve.', officialUrl: 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2010/', dateLabel: '12.12.2010');
  static const ElectionSource local2025 = ElectionSource(type: ElectionSourceType.local2025, title: 'Zgjedhjet Lokale 2025', shortTitle: 'Lokale 2025', description: 'Rezultatet për kryetarë komunash, kuvende komunale dhe pjesëmarrje sipas komunave.', officialUrl: 'https://resultslocal2025.kqz-ks.org/', dateLabel: '12.10.2025');
  static const ElectionSource local2025Round2 = ElectionSource(type: ElectionSourceType.local2025Round2, title: 'Zgjedhjet Lokale 2025 - Raundi II', shortTitle: 'Lokale R2', description: 'Rezultatet e raundit të dytë për kryetarë komunash në komunat përkatëse.', officialUrl: 'https://resultslocal2025r2.kqz-ks.org/', dateLabel: '09.11.2025');

  static const List<ElectionSource> all = [
    parliamentary2025,
    parliamentary2021,
    parliamentary2019,
    parliamentary2017,
    parliamentary2014,
    parliamentary2010,
    local2025,
    local2025Round2,
  ];
}
