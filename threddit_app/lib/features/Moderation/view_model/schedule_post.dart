import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/Moderation/model/schedule_post.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final schedulePostProvider =
    StateNotifierProvider<ScheduleNotifier, SchedulePostModel>(
        (ref) => ScheduleNotifier());

class ScheduleNotifier extends StateNotifier<SchedulePostModel> {
  ScheduleNotifier()
      : super(SchedulePostModel(
            body: "",
            date: null,
            time: null,
            title: "",
            realDate: DateTime.now(),
            realTime: TimeOfDay.now()));

  FutureEither<SchedulePostModel> updateSchPost() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "post.json");
    try {
      final response = await http.post(
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

  FutureEither<List<SchedulePostModel>> getSchPosts() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "post.json");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final List<SchedulePostModel> loadedPosts = [];

        extractedData.forEach((postId, postData) {
          loadedPosts
              .add(SchedulePostModel.fromMap(postData as Map<String, dynamic>));
        });
        return right(loadedPosts);
      } else {
        return left(Failure(
            'Something went wrong while trying to fetch your data, please try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  void updateBody(String newBody) {
    state = state.copyWith(body: newBody);
  }

  void updateTime(String newTime) {
    state = state.copyWith(time: newTime);
  }

  void updateDate(String newDate) {
    state = state.copyWith(date: newDate);
  }

  void updateRealTime(TimeOfDay newTime) {
    state = state.copyWith(realTime: newTime);
  }

  void updateRealDate(DateTime newDate) {
    state = state.copyWith(realDate: newDate);
  }

  void updateTitle(String newTitle) {
    state = state.copyWith(title: newTitle);
  }

  void resetDateAndTime() {
    state = state.copyWith(realDate: DateTime.now(), realTime: TimeOfDay.now());
  }
}
