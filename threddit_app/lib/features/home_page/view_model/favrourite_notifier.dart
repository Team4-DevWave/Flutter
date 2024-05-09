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

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, Favourite>(
    (ref) => FavouriteNotifier(ref));

class FavouriteNotifier extends StateNotifier<Favourite> {
  final Ref ref;

  FavouriteNotifier(this.ref) : super(Favourite("", "", ""));

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

final favouriteList = StateProvider<List<Favourite>>((state) => []);
