import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/home_page/model/favourite_model.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

/// A [StateNotifierProvider] that manages the current favorite item.
///
/// This provider holds a [Favourite] object, which represents the currently
/// selected item for favoriting or unfavoriting actions. The [FavouriteNotifier]
/// is responsible for interacting with the backend to update the user's favorites.
final favouriteProvider = StateNotifierProvider<FavouriteNotifier, Favourite>(
    (ref) => FavouriteNotifier(ref));

class FavouriteNotifier extends StateNotifier<Favourite> {
  final Ref ref;

  /// Creates a [FavouriteNotifier] with an initial empty [Favourite] object.
  FavouriteNotifier(this.ref) : super(Favourite("", "", ""));

  /// Retrieves the user's list of favorites from the backend.
  ///
  /// This method makes a GET request to the `/api/v1/users/me/favorites` endpoint
  /// to retrieve the user's favorites. If successful, it updates the
  /// `favouriteList` provider with the fetched favorites.
  ///
  /// Returns a [right(true)] on success, or a [left(Failure)] on failure.
  FutureEither<bool> getFavourite() async {
    final url =
        Uri.parse("https://www.threadit.tech/api/v1/users/me/favorites");

    final token = await getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data']['favorites'] as List;

        ref.read(favouriteList.notifier).update((state) =>
            jsonData.map((item) => Favourite.fromMap(item)).toList());

        return right(true);
      } else {
        return left(Failure('Failed to fetch favourites.'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  /// Removes the current favorite item from the user's favorites.
  ///
  /// This method makes a DELETE request to the `/api/v1/users/me/favorites`
  /// endpoint to remove the favorite item represented by the notifier's state.
  /// If successful, it updates the `favouriteList` provider with the updated
  /// favorites.
  ///
  /// Returns a [right(true)] on success, or a [left(Failure)] on failure.
  FutureEither<bool> removeItem() async {
    final url =
        Uri.parse("https://www.threadit.tech/api/v1/users/me/favorites");

    final token = await getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      "name": state.username,
      "type": state.type,
    });

    try {
      final response = await http.delete(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data']['favorites'] as List;

        ref.read(favouriteList.notifier).update((state) =>
            jsonData.map((item) => Favourite.fromMap(item)).toList());

        return right(true);
      } else {
        return left(Failure('Failed to fetch favourites.'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  /// Adds the current favorite item to the user's favorites.
  ///
  /// This method makes a PATCH request to the `/api/v1/users/me/favorites`
  /// endpoint to add the favorite item represented by the notifier's state.
  /// If successful, it updates the `favouriteList` provider with the updated
  /// favorites.
  ///
  /// Returns a [right(true)] on success, or a [left(Failure)] on failure.
  FutureEither<bool> addItem() async {
    final url =
        Uri.parse("https://www.threadit.tech/api/v1/users/me/favorites");

    final token = await getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      "name": state.username,
      "type": state.type,
    });

    try {
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data']['favorites'] as List;

        ref.read(favouriteList.notifier).update((state) =>
            jsonData.map((item) => Favourite.fromMap(item)).toList());

        return right(true);
      } else {
        return left(Failure('Failed to fetch favourites.'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  void updateItem(Favourite favItem) => state = favItem;
}

/// A [StateProvider] that holds the list of the user's favorite items.
///
/// This provider provides the list of [Favourite] objects representing the user's
/// current favorites.
final favouriteList = StateProvider<List<Favourite>>((state) => []);
