import 'package:flutter_riverpod/flutter_riverpod.dart';

final userModelNotMeProvider =
    StateProvider<UserModelNotMe?>((ref) => UserModelNotMe());

class UserModelNotMe {
  final int? postKarma;
  final int? commentKarma;
  final DateTime? cakeDay;

  UserModelNotMe({
    this.postKarma,
    this.commentKarma,
    this.cakeDay,
  });

  factory UserModelNotMe.fromJson(Map<String, dynamic> json) {
    final userData = json['data'] as Map<String, dynamic>?;

    if (userData == null) {
      return UserModelNotMe(); // Handle null user data
    }

    final postKarma = userData['postKarma'] as int? ?? 0;
    final commentKarma = userData['commentKarma'] as int? ?? 0;
    final cakeDayString = userData['cakeDay'] as String?;

    DateTime? cakeDay;
    if (cakeDayString != null) {
      cakeDay = DateTime.parse(cakeDayString);
    }

    return UserModelNotMe(
      postKarma: postKarma,
      commentKarma: commentKarma,
      cakeDay: cakeDay,
    );
  }
}
