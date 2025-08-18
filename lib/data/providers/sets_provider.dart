import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/set_model.dart';

class SetsNotifier extends StateNotifier<List<SetModel>> {
  SetsNotifier() : super([]);

  void addSet(SetModel set) {
    if (!state.contains(set)) {
      state = [...state, set]; // replace with new list so Riverpod rebuilds
    }
  }

  void clear() {
    state = [];
  }
}

final changedSetsProvider = StateNotifierProvider<SetsNotifier, List<SetModel>>(
  (ref) => SetsNotifier(),
);

final deletedSetsProvider = StateNotifierProvider<SetsNotifier, List<SetModel>>(
  (ref) => SetsNotifier(),
);
