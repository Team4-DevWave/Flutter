import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

/// Provider for managing the description state.
final descriptionProvider = StateNotifierProvider<DescriptionNotifier, String>(
    (ref) => DescriptionNotifier());

/// State notifier responsible for managing the description state.
class DescriptionNotifier extends StateNotifier<String> {
  DescriptionNotifier() : super("");

  /// Updates the state with the provided description.
  void updateDescriptioState(String newDescription) {
    state = newDescription;
  }

  /// Fetches the description from the server.
  FutureEither<String> getDescription() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "description.json");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        state = json.decode(response.body)["-Nwbn2XqbG3VWBJcA3BA"];
        return right(state);
      } else {
        return left(Failure(
            'Somethig went wrong while trying to fetch your data, please try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  /// Updates the description on the server.
  FutureEither<String> updateDescription() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "description.json");
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "-Nwbn2XqbG3VWBJcA3BA": state,
          },
        ),
      );
      if (response.statusCode == 200) {
        return right("");
      } else {
        return left(Failure(
            'Somethig went wrong while trying to fetch your data, please try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }
}
