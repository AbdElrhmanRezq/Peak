import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/exercise_model.dart';
import 'package:repx/data/models/user_model.dart';

final bodyPartProvider = StateProvider<String>((ref) => "back");
