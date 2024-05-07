import 'dart:io';

class PrefConstants {
  static String favourites = 'favourites';
  static String googleToken = 'googleToken';
  static String authToken = 'authToken';
  static String userName = 'username';
  static String userId = '_id';
  static String imagePath = 'imagePath';
  static String recentlyVisitied = 'recentlyVisited';
  static String subredditType = 'subreddit';
  static String userType = 'user';
}

class AppConstants {
  static String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';
}
