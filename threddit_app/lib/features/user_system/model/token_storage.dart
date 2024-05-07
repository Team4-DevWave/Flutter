import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/features/home_page/model/visited_item.dart';
import 'package:threddit_clone/features/user_system/view/screens/text_size_screen.dart';
import 'package:threddit_clone/app/pref_constants.dart';

SharedPreferences? prefs;

///[saveToken] function is a function that takes a [String] type [token]
///this [token] was collected after the login process and the [token] is considered
///the main way to authenticate the user with the backend server for any kind of request.
///This function get the [token] and stores it in the applications's shared prefrences.
///this shared prefrences is the local cache memory of the applicaiton.
///and the built in saving function is an asynchronus function
Future<void> saveToken(String token) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setString(PrefConstants.authToken, token);
}

Future<void> saveUserName(String username) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setString(PrefConstants.userName, username);
}

Future<void> saveUserId(String userid) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setString(PrefConstants.userId, userid);
}

Future<String?> getUserName() async {
  prefs = await SharedPreferences.getInstance();
  return prefs?.getString(PrefConstants.userName);
}

Future<String?> getUserId() async {
  prefs = await SharedPreferences.getInstance();
  return prefs?.getString(PrefConstants.userId);
}

Future<void> saveGoogleToken(String token) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setString(PrefConstants.googleToken, token);
}

///[getToken] function gets the user's saved authenticated token
///in the shared prefrences (local cache memory) this function can be used whenever
///we need to send the token in any needed authenticated request
Future<String?> getToken() async {
  prefs = await SharedPreferences.getInstance();
  return prefs?.getString(PrefConstants.authToken);
}

///The [deleteToken] function is responsible for deleting the token from the shared memory
///and this function could be useful for scenarios of logging use out of the application
Future<void> deleteToken() async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.remove(PrefConstants.authToken);
}

Future<void> saveRecentlyVisited() async {}

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

Future<List<VisitedItem>> getRecentVisits() async {
  prefs = await SharedPreferences.getInstance();
  final List<String>? storedData =
      prefs?.getStringList(PrefConstants.recentlyVisitied);
  if (storedData == null) return [];
  return storedData
      .map((item) => VisitedItem.fromMap(jsonDecode(item)))
      .toList();
}

Future<void> addVisit(VisitedItem item) async {
  prefs = await SharedPreferences.getInstance();

  final currentVisits = await getRecentVisits();

  // Check if item already exists and remove it to move it to the top
  currentVisits
      .removeWhere((existingItem) => existingItem.username == item.username);
  currentVisits.insert(0, item);

  // Limit the list size
  if (currentVisits.length > 10) currentVisits.removeLast();
  await prefs?.setStringList(
    PrefConstants.recentlyVisitied,
    currentVisits.map((item) => jsonEncode(item.toMap())).toList(),
  );
}

Future<void> deleteAll() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(PrefConstants.recentlyVisitied);
}

Future<void> saveCommunitiesState(bool state) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setBool(PrefConstants.communitiesState, state);
}

Future<bool?> getCommunitiesState(WidgetRef ref) async {
  prefs = await SharedPreferences.getInstance();
  return ref
      .read(communityStateProvider.notifier)
      .update((state) => prefs?.getBool(PrefConstants.communitiesState));
}

Future<void> saveFollowingState(bool state) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setBool(PrefConstants.followingState, state);
}

Future<bool?> getFollowingState(WidgetRef ref) async {
  prefs = await SharedPreferences.getInstance();
  return ref
      .read(followingStateProvider.notifier)
      .update((state) => prefs?.getBool(PrefConstants.followingState));
}

Future<void> saveFavouritesState(bool state) async {
  prefs = await SharedPreferences.getInstance();
  await prefs?.setBool(PrefConstants.favouritesState, state);
}

Future<bool?> getFavouritesState(WidgetRef ref) async {
  prefs = await SharedPreferences.getInstance();
  return ref
      .read(favouritesStateProvider.notifier)
      .update((state) => prefs?.getBool(PrefConstants.favouritesState));
}

final communityStateProvider = StateProvider<bool?>((ref) => null);
final favouritesStateProvider = StateProvider<bool?>((ref) => null);
final followingStateProvider = StateProvider<bool?>((ref) => null);
