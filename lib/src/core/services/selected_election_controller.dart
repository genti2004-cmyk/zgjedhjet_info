import 'package:flutter/foundation.dart';

import '../models/election_source.dart';

class SelectedElectionController {
  SelectedElectionController._();

  static final ValueNotifier<ElectionSource> selectedElection =
  ValueNotifier<ElectionSource>(ElectionSource.parliamentary2025);

  static void select(ElectionSource source) {
    selectedElection.value = source;
  }
}