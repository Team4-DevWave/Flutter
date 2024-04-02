import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', token);
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

Future<void> deleteToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken');
}