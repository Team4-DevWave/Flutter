import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/app/pref_constants.dart';

SharedPreferences?pref;
final favouriteListProvider = StateProvider<List<String>>(
  (ref) => ref.watch(sharedPreferencesProvider)
      .getStringList(PrefConstants.favourites) ?? [],); 
