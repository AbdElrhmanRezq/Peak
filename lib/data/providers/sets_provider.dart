import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/set_model.dart';

class SetsNotifier extends StateNotifier<List<SetModel>> {
  SetsNotifier() : super([]);

  void addChangedSet(SetModel set) {
    if (!state.contains(set)) {
      state = [...state, set]; // replace with new list so Riverpod rebuilds
    }
  }

  void clear() {
    state = [];
  }
}

final setsProvider = StateNotifierProvider<SetsNotifier, List<SetModel>>(
  (ref) => SetsNotifier(),
);
