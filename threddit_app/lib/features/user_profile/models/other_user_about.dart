import 'package:flutter_riverpod/flutter_riverpod.dart';

final userModelAboutProvider =
    StateProvider<UserModelAbout?>((ref) => UserModelAbout());

class UserModelAbout {
  final int? postKarma;
  final int? commentKarma;
  final DateTime? cakeDay;

  UserModelAbout({
    this.postKarma,
    this.commentKarma,
    this.cakeDay,
  });

  factory UserModelAbout.fromJson(Map<String, dynamic> json) {
    final userData = json['data'] as Map<String, dynamic>?;

    if (userData == null) {
      return UserModelAbout(); // Handle null user data
    }

    final postKarma = userData['postKarma'] as int? ?? 0;
    final commentKarma = userData['commentKarma'] as int? ?? 0;
    final cakeDayString = userData['cakeDay'] as String?;

    DateTime? cakeDay;
    if (cakeDayString != null) {
      cakeDay = DateTime.parse(cakeDayString);
    }

    return UserModelAbout(
      postKarma: postKarma,
      commentKarma: commentKarma,
      cakeDay: cakeDay,
    );
  }
}