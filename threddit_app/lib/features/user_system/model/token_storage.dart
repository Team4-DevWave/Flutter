import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/features/user_system/view/screens/text_size_screen.dart';
import 'package:threddit_clone/app/pref_constants.dart';

SharedPreferences? prefs;
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

final textSizeProvider =
    StateNotifierProvider<TextSize, bool>((ref) => TextSize(ref));

class TextSize extends StateNotifier<bool> {
  final Ref ref;
  TextSize(this.ref) : super(false);

  Future<double?> getTextSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double? size = prefs.getDouble('textSize');
    if (size != null) {
      ref.watch(sliderProvider.notifier).update((state) => size);
    }
    return prefs.getDouble('textSize');
  }

  Future<bool?> getFontOption() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isOn = prefs.getBool('textOn');
    if (isOn != null) {
      ref.watch(enableResizeProvider.notifier).update((state) => isOn);
    }
    return prefs.getBool('textOn');
  }
}

Future<void> saveFontOption(bool fontOption) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('textOn', fontOption);
}

Future<void> saveTextSize(double fontSize) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('textSize', fontSize);
}
