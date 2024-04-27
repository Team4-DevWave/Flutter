import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
      : super(
          UserProfile(
            displayName: "",
            about: "",
            nsfw: false,
            allowFollowers: true,
            contentVisibility: true,
            activeCommunitiesVisibility: true,
            profilePicture: "",
            socialLinks: [],
          ),
        );

  ///this function sends the current state of the user data
  ///if the request is successfull, the data will be updated in the provider
  FutureEither<bool> updateUserData() async {

    String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    final token = await getToken();
    final url = "http://$local:8000/api/v1/users/me/settings";
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final jsonBody = state.toJson();
    try {
      final response =
          await http.patch(Uri.parse(url), headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body) as Map<String, dynamic>;
        final userProfileData = resBody['data']['settings']['userProfile'] as Map<String, dynamic>;
        final updatedProfile = UserProfile.fromJson(userProfileData);
        state = updatedProfile;
        return right(true);
      } else {
        return left(Failure("Can't submit changes, please try again later"));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

FutureEither<bool> updateUserLinks() async {

    String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    final token = await getToken();
    final url = "http://$local:8000/api/v1/users/me/settings";
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final jsonBody = state.toJson();
    try {
      final response =
          await http.patch(Uri.parse(url), headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body) as Map<String, dynamic>;
        final userProfileData = resBody['data']['settings']['userProfile'] as Map<String, dynamic>;
        final updatedProfile = UserProfile.fromJson(userProfileData);
        state = updatedProfile;
        return right(true);
      } else {
        return left(Failure("Can't submit changes, please try again later"));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  
  void updateDiplayName(String disName) =>
      state = state.copyWith(displayName: disName);
  void updateAbout(String about) => state = state.copyWith(about: about);
  void updateContetnVis(bool vis) =>
      state = state.copyWith(contentVisibility: vis);
  void updateActiveCom(bool active) =>
      state = state.copyWith(activeCommunitiesVisibility: active);
  void updateProfilePic(String pic) =>
      state = state.copyWith(profilePicture: pic);
  void updateImagePath(File?imgePath) =>
      state = state.copyWith(imagePath: imgePath);
  void updateSocialLinks(List<String> social) =>
      state = state.copyWith(socialLinks: social);
  void addLink(String link) => state.socialLinks.add(link);
  void setUser(UserProfile user) => state = user;
  
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
        (ref) => UserProfileNotifier());

final imagePathProvider = StateProvider<File?>((ref) => null);
