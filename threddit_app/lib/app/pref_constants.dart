import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefConstants {
  static String favourites = 'favourites';
  static String googleToken = 'googleToken';
  static String authToken = 'authToken';
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences provider is not implemented yet.');
});