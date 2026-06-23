class MunicipalityNameHelper {
  const MunicipalityNameHelper._();

  static const Map<String, List<String>> aliases = {
    'Deçan': ['DEÇAN', 'DEČANE', 'Deçan', 'Dečane'],
    'Dragash': ['DRAGASH', 'DRAGAŠ', 'Dragash', 'Dragaš'],
    'Ferizaj': ['FERIZAJ', 'Ferizaj', 'UROŠEVAC', 'Uroševac'],
    'Fushë Kosovë': ['FUSHË KOSOVË', 'Fushë Kosovë', 'KOSOVO POLJE', 'Kosovo Polje'],
    'Gjakovë': ['GJAKOVË', 'Gjakovë', 'ĐAKOVICA', 'Đakovica'],
    'Gjilan': ['GILAN', 'GJILAN', 'GNJILANE', 'Gjilan', 'Gnjilane'],
    'Gllogoc': ['GLLOGOVC', 'GLOGOVAC', 'Gllogoc', 'Gllogovc', 'Glogovac'],
    'Graçanicë': ['GRAÇANICË', 'GRAČANICA', 'Graçanicë', 'Gračanica'],
    'Hani i Elezit': ['ELEZ HAN', 'Elez Han', 'HANI I ELEZIT', 'Hani Elezit', 'Hani i Elezit'],
    'Istog': ['ISTOG', 'ISTOK', 'Istog', 'Istok'],
    'Junik': ['JUNIK', 'Junik'],
    'Kamenicë': ['KAMENICA', 'KAMENICË', 'Kamenica', 'Kamenicë'],
    'Kaçanik': ['KAÇANIK', 'KAČANIK', 'Kaçanik', 'Kačanik'],
    'Klinë': ['KLINA', 'KLINË', 'Klina', 'Klinë'],
    'Kllokot': ['KLLOKOT', 'KLOKOT', 'Kllokot', 'Klokot'],
    'Leposaviq': ['LEPOSAVIQ', 'LEPOSAVIĆ', 'Leposaviq', 'Leposavić'],
    'Lipjan': ['LIPJAN', 'LIPLJAN', 'Lipjan', 'Lipljan'],
    'Malishevë': ['MALISHEVË', 'MALIŠEVO', 'Malishevë', 'Mališevo'],
    'Mamushë': ['MAMUSHË', 'MAMUŞA', 'MAMUŠA', 'Mamushë', 'Mamuša'],
    'Mitrovicë e Jugut': ['GÜNEY MITROVIÇA', 'JUŽNA MITROVICA', 'Južna Mitrovica', 'MITROVICË E JUGUT', 'Mitrovicë E Jugut', 'Mitrovicë e Jugut'],
    'Mitrovicë e Veriut': ['MITROVICË E VERIUT', 'Mitrovicë E Veriut', 'Mitrovicë e Veriut', 'SEVERNA MITROVICA', 'Severna Mitrovica'],
    'Novobërdë': ['NOVO BRDO', 'NOVOBËRDË', 'Novo Brdo', 'Novobërdë'],
    'Obiliq': ['OBILIQ', 'OBILIĆ', 'Obiliq', 'Obilić'],
    'Partesh': ['PARTESH', 'PARTEŠ', 'Partesh', 'Parteš'],
    'Pejë': ['PEJË', 'PEĆ', 'Pejë', 'Peć'],
    'Podujevë': ['PODUJEVO', 'PODUJEVË', 'Podujevo', 'Podujevë'],
    'Prishtinë': ['PRISHTINË', 'PRIŞTINE', 'PRIŠTINA', 'Prishtinë', 'Priština'],
    'Prizren': ['PRIZREN', 'Prizren'],
    'Rahovec': ['ORAHOVAC', 'Orahovac', 'RAHOVEC', 'Rahovec'],
    'Ranillug': ['RANILLUG', 'RANILLUK', 'Ranillug', 'Ranilug'],
    'Shtime': ['SHTIME', 'Shtime', 'ŠTIMLJE', 'Štimlje'],
    'Shtërpcë': ['SHTËRPCË', 'Shtërpcë', 'ŠTRPCE', 'Štrpce'],
    'Skenderaj': ['SKENDERAJ', 'SRBICA', 'Skenderaj', 'Srbica'],
    'Suharekë': ['SUHAREKË', 'SUVA REKA', 'Suharekë', 'Suvareka'],
    'Viti': ['VITI', 'VITINA', 'Viti', 'Vitina'],
    'Vushtrri': ['VIÇITIRIN', 'VUSHTRRI', 'VUČITRN', 'Vushtrri', 'Vučitrn'],
    'Zubin Potok': ['ZUBIN POTOK', 'Zubin Potok'],
    'Zveçan': ['ZVEÇAN', 'ZVEČAN', 'Zveçan', 'Zvečan'],
  };

  static String searchableText(String municipalityName) {
    final values = aliases[municipalityName] ?? [municipalityName];
    return values.join(' ');
  }
}
