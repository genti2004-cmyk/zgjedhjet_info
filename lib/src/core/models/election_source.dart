enum ElectionSourceType {
  parliamentary2025December,
  parliamentary2025,
  parliamentary2021,
  parliamentary2019,
  parliamentary2017,
  parliamentary2014,
  parliamentary2010,
  parliamentary2007,
  parliamentary2004,
  parliamentary2001,
  local2017,
  local2025,
  local2025Round2,
}

class ElectionSource {
  final String id;
  final String title;
  final String shortTitle;
  final String description;
  final ElectionSourceType type;
  final String officialUrl;
  final DateTime date;

  const ElectionSource({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.type,
    required this.officialUrl,
    required this.date,
  });

  bool get isLocal =>
      type == ElectionSourceType.local2017 ||
      type == ElectionSourceType.local2025 ||
      type == ElectionSourceType.local2025Round2;

  bool get isParliamentary => !isLocal;

  String get dateLabel {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }


  static final ElectionSource parliamentary2025December = ElectionSource(
    id: 'parliamentary-2025-december',
    title: 'Zgjedhjet e parakohshme për Kuvendin e Kosovës - 28 Dhjetor 2025',
    shortTitle: 'Parlamentare 28 Dhjetor 2025',
    description: 'Rezultatet përfundimtare zyrtare të KQZ për zgjedhjet e parakohshme të 28 dhjetorit 2025.',
    type: ElectionSourceType.parliamentary2025December,
    officialUrl: 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/',
    date: DateTime(2025, 12, 28),
  );

  static final ElectionSource parliamentary2025 = ElectionSource(
    id: 'parliamentary-2025',
    title: 'Zgjedhjet për Kuvend të Kosovës 2025',
    shortTitle: 'Parlamentare 2025',
    description: 'Rezultatet zyrtare për zgjedhjet parlamentare 2025.',
    type: ElectionSourceType.parliamentary2025,
    officialUrl: 'https://resultsparliamentary2025.kqz-ks.org/',
    date: DateTime(2025, 2, 9),
  );

  static final ElectionSource parliamentary2021 = ElectionSource(
    id: 'parliamentary-2021',
    title: 'Zgjedhjet për Kuvend të Kosovës 2021',
    shortTitle: 'Parlamentare 2021',
    description: 'Rezultatet zyrtare për zgjedhjet parlamentare 2021.',
    type: ElectionSourceType.parliamentary2021,
    officialUrl:
        'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2021/',
    date: DateTime(2021, 2, 14),
  );

  static final ElectionSource parliamentary2019 = ElectionSource(
    id: 'parliamentary-2019',
    title: 'Zgjedhjet për Kuvend të Kosovës 2019',
    shortTitle: 'Parlamentare 2019',
    description: 'Rezultatet zyrtare për zgjedhjet parlamentare 2019.',
    type: ElectionSourceType.parliamentary2019,
    officialUrl:
        'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2019/',
    date: DateTime(2019, 10, 6),
  );

  static final ElectionSource parliamentary2017 = ElectionSource(
    id: 'parliamentary-2017',
    title: 'Zgjedhjet për Kuvend të Kosovës 2017',
    shortTitle: 'Parlamentare 2017',
    description: 'Rezultatet zyrtare për zgjedhjet parlamentare 2017.',
    type: ElectionSourceType.parliamentary2017,
    officialUrl:
        'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2017/',
    date: DateTime(2017, 6, 11),
  );

  static final ElectionSource parliamentary2014 = ElectionSource(
    id: 'parliamentary-2014',
    title: 'Zgjedhjet për Kuvend të Kosovës 2014',
    shortTitle: 'Parlamentare 2014',
    description: 'Rezultatet zyrtare për zgjedhjet parlamentare 2014.',
    type: ElectionSourceType.parliamentary2014,
    officialUrl:
        'https://kqz-ks.org/zgjedhjet-e-pergjithshme/zgjedhjet-per-kuvend-te-kosoves-2014/',
    date: DateTime(2014, 6, 8),
  );

  static final ElectionSource parliamentary2010 = ElectionSource(
    id: 'parliamentary-2010',
    title: 'Zgjedhjet për Kuvend të Kosovës 2010',
    shortTitle: 'Parlamentare 2010',
    description: 'Rezultatet zyrtare për zgjedhjet parlamentare 2010.',
    type: ElectionSourceType.parliamentary2010,
    officialUrl: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvend-te-kosoves/',
    date: DateTime(2010, 12, 12),
  );


  static final ElectionSource parliamentary2007 = ElectionSource(
    id: 'parliamentary-2007', title: 'Zgjedhjet për Kuvend të Kosovës 2007', shortTitle: 'Parlamentare 2007',
    description: 'Rezultatet zyrtare të OSBE/CEC për zgjedhjet parlamentare 2007.',
    type: ElectionSourceType.parliamentary2007, officialUrl: 'https://www.osce.org/mission-in-kosovo', date: DateTime(2007, 11, 17),
  );

  static final ElectionSource parliamentary2004 = ElectionSource(
    id: 'parliamentary-2004', title: 'Zgjedhjet për Kuvend të Kosovës 2004', shortTitle: 'Parlamentare 2004',
    description: 'Rezultatet zyrtare të OSBE/CEC për zgjedhjet parlamentare 2004.',
    type: ElectionSourceType.parliamentary2004, officialUrl: 'https://www.osce.org/mission-in-kosovo', date: DateTime(2004, 10, 23),
  );

  static final ElectionSource parliamentary2001 = ElectionSource(
    id: 'parliamentary-2001', title: 'Zgjedhjet për Kuvend të Kosovës 2001', shortTitle: 'Parlamentare 2001',
    description: 'Rezultatet e certifikuara të OSBE/OMiK për zgjedhjet parlamentare 2001.',
    type: ElectionSourceType.parliamentary2001, officialUrl: 'https://www.osce.org/mission-in-kosovo', date: DateTime(2001, 11, 17),
  );

  static final ElectionSource local2017 = ElectionSource(
    id: 'local-2017',
    title: 'Zgjedhjet Lokale 2017 – Kuvende Komunale',
    shortTitle: 'Lokale 2017',
    description:
        'Rezultatet për kuvende komunale dhe kandidatët sipas komunave nga dokumentet zyrtare të KQZ.',
    type: ElectionSourceType.local2017,
    officialUrl: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kuvende-komunale/',
    date: DateTime(2017, 10, 22),
  );

  static final ElectionSource local2025 = ElectionSource(
    id: 'local-2025',
    title: 'Zgjedhjet Lokale 2025',
    shortTitle: 'Lokale 2025',
    description: 'Burime zyrtare të përgatitura për zgjedhjet lokale 2025.',
    type: ElectionSourceType.local2025,
    officialUrl: 'https://kqz-ks.org/rezultatet/zgjedhjet-per-kryetare-te-komunave/',
    date: DateTime(2025, 10, 12),
  );

  static final ElectionSource local2025Round2 = ElectionSource(
    id: 'local-2025-r2',
    title: 'Zgjedhjet Lokale 2025 – Raundi II',
    shortTitle: 'Lokale 2025 R2',
    description:
        'Burime zyrtare të përgatitura për raundin e dytë të zgjedhjeve lokale 2025.',
    type: ElectionSourceType.local2025Round2,
    officialUrl: 'https://resultslocal2025r2.kqz-ks.org/',
    date: DateTime(2025, 11, 9),
  );

  static final List<ElectionSource> all = [
    parliamentary2025December,
    parliamentary2025,
    parliamentary2021,
    parliamentary2019,
    parliamentary2017,
    parliamentary2014,
    parliamentary2010,
  parliamentary2007,
  parliamentary2004,
  parliamentary2001,
    local2017,
    local2025,
    local2025Round2,
  ];

  static List<ElectionSource> get sources => all;

  static ElectionSource byType(ElectionSourceType type) {
    return all.firstWhere((source) => source.type == type);
  }

  static ElectionSource byId(String id) {
    return all.firstWhere(
      (source) => source.id == id,
      orElse: () => parliamentary2025,
    );
  }
}
