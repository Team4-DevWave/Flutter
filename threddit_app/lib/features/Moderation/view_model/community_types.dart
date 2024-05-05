import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/Moderation/model/community_types_model.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final communityTypesProvider = StateNotifierProvider<CommunityTypesNotifier, CommunityTypesModel>(
    (ref) => CommunityTypesNotifier());

class CommunityTypesNotifier extends StateNotifier<CommunityTypesModel> {
  CommunityTypesNotifier()
      : super(CommunityTypesModel(
            isAdult: false,
            restriction: 0
            ));

  

  void updateAdult(bool check) {
    state = state.copyWith(isAdult: check);
  }

  void updateRestrction(int value) {
    state = state.copyWith(restriction: value);
  }

  FutureEither<CommunityTypesModel> getCommunityTypes() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "communityType.json");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        state = CommunityTypesModel.fromJson(response.body);
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

  FutureEither<CommunityTypesModel> updateCommunityTypes() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "communityType.json");
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: state.toJson(),
      );
      if (response.statusCode == 200) {
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
}
