import '../../../core/models/official_source.dart';

class OfficialSourcesRepository {
  const OfficialSourcesRepository();

  List<OfficialSource> getSources() {
    return const [
      OfficialSource(
        id: 'kqz-main',
        title: 'KQZ Kosova',
        description:
        'Faqja zyrtare e Komisionit Qendror të Zgjedhjeve të Kosovës.',
        url: 'https://kqz-ks.org/',
        type: 'Faqe zyrtare',
      ),
      OfficialSource(
        id: 'kqz-results',
        title: 'Rezultatet - KQZ',
        description:
        'Faqja zyrtare ku KQZ publikon rezultatet dhe dokumentet zgjedhore.',
        url: 'https://kqz-ks.org/rezultatet/',
        type: 'Rezultate',
      ),
      OfficialSource(
        id: 'parliamentary-2025-december',
        title: 'Parlamentare 28 Dhjetor 2025',
        description:
        'Dokumentet dhe rezultatet zyrtare të KQZ për zgjedhjet e parakohshme të 28 dhjetorit 2025.',
        url: 'https://kqz-ks.org/zgjedhjet-e-pergjithshme/',
        type: 'Dokumente zyrtare',
      ),
      OfficialSource(
        id: 'parliamentary-2025-february',
        title: 'Parlamentare 9 Shkurt 2025',
        description:
        'Platforma elektronike e KQZ për rezultatet e zgjedhjeve të 9 shkurtit 2025.',
        url: 'https://resultsparliamentary2025.kqz-ks.org/',
        type: 'Platformë rezultatesh',
      ),
      OfficialSource(
        id: 'local-2025',
        title: 'Rezultatet Lokale 2025',
        description:
        'Platforma elektronike e KQZ për rezultatet preliminare dhe statistikat e zgjedhjeve lokale 2025.',
        url: 'https://resultslocal2025.kqz-ks.org/',
        type: 'Platformë rezultatesh',
      ),
      OfficialSource(
        id: 'local-2025-round-2',
        title: 'Rezultatet Lokale 2025 - Raundi II',
        description:
        'Platforma elektronike e KQZ për rezultatet dhe statistikat e raundit të dytë të zgjedhjeve lokale 2025.',
        url: 'https://resultslocal2025r2.kqz-ks.org/',
        type: 'Platformë rezultatesh',
      ),
    ];
  }
}