  import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/app/pref_constants.dart';

SharedPreferences?prefs;

Future<void> saveToken(String token) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setString(PrefConstants.authToken, token);
}
Future<void> saveGoogleToken(String token) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setString(PrefConstants.googleToken, token);
}
Future<String?> getToken() async {
  prefs = await SharedPreferences.getInstance();
  return prefs?.getString(PrefConstants.authToken);
}

Future<void> deleteToken() async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.remove(PrefConstants.authToken);
}
Future<String?> getGoogleToken() async {
  prefs = await SharedPreferences.getInstance();
  return prefs?.getString(PrefConstants.googleToken);
}

Future<void> deleteGoogleToken() async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.remove(PrefConstants.googleToken);
}