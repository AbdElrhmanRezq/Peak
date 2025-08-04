import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final exerciseImageCacheManager = CacheManager(
  Config(
    'exerciseImageCache',
    stalePeriod: Duration(days: 3),
    maxNrOfCacheObjects: 200,
  ),
);
