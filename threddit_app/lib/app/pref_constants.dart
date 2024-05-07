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
  static String communitiesState = 'communitiesState';
  static String favouritesState = 'favouritesState';
  static String followingState = 'followingState';
}

class AppConstants {
  static String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';
}
