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

/// Manages the state and operations related to user profiles, including data fetching,
/// updating, and synchronization with a backend server.
class UserProfileNotifier extends StateNotifier<UserProfile> {
  /// Initializes the notifier with default values for a new user profile.
  UserProfileNotifier()
      : super(
          UserProfile(
            about: "",
            nsfw: false,
            allowFollowers: true,
            contentVisibility: true,
            activeCommunitiesVisibility: true,
            socialLinks: [],
          ),
        );

  /// Updates the user's profile data by sending the current state to a backend endpoint.
  /// Returns a FutureEither instance that holds:
  ///
  /// boolean on the right upon success,
  ///
  ///Failure message that is displayed to the user at the appropriate screen
  /// on the left if the operation fails.
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
        final userProfileData =
            resBody['data']['settings']['userProfile'] as Map<String, dynamic>;
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

  /// Updates user's social links by sending them to the backend.
  /// This method eturns a FutureEither instance that holds:
  ///
  /// boolean on the right upon success,
  ///
  ///Failure message that is displayed to the user at the appropriate screen
  FutureEither<bool> updateUserLinks() async {
    String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    final token = await getToken();
    final url = "http://$local:8000/api/v1/users/me/settings";
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final List<Map<String, String>> mappedSocialLinks =
        state.socialLinks.map((link) {
      final Map<String, String> newLink = {
        'socialType': link[0].toLowerCase(),
        'username': link[1],
      };
      if (link.length == 3) {
        newLink['url'] = link[2];
      }
      return newLink;
    }).toList();

    final dataToSend = {
      "userProfile": {
        "socialLinks": mappedSocialLinks,
      }
    };

    final jsonBody = json.encode(dataToSend);

    try {
      final response =
          await http.patch(Uri.parse(url), headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
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

  /// Updates the about field of the user's profile.
  void updateAbout(String about) => state = state.copyWith(about: about);

  /// Updates the content visibility in the [UserProfile]
  void updateContetnVis(bool vis) =>
      state = state.copyWith(contentVisibility: vis);

  /// Updates the visibility of active communities of the [UserProfile]
  void updateActiveCom(bool active) =>
      state = state.copyWith(activeCommunitiesVisibility: active);
  void updateSocialLinks(List<List<String>>?social) =>
      state = state.copyWith(socialLinks: social);

  /// Adds a new social link to the user's profile.
  void addLink(List<String> link) => state.socialLinks.add(link);

  /// Replaces the entire user profile state with a new one.
  void setUser(UserProfile user) => state = user;
}

/// Provides access to the social links of the user profile asynchronously.
final socialLinksFutureProvider = FutureProvider((ref) async {
  return ref.read(userProfileProvider)?.socialLinks;
});

/// A Riverpod provider that creates and provides access to the UserProfileNotifier.
/// That is mainly used in user profile screens and controll the view and update of the user data
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
        (ref) => UserProfileNotifier());

/// Manages the user's image path
final imagePathProvider = StateProvider<File?>((ref) => null);
