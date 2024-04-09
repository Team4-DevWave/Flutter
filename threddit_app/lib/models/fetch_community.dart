

import 'package:threddit_clone/features/post/model/post_model.dart';

class FetchCommunity {
  late String subredditTitle;
  late String subredditDescription;
  late String numJoinedMembers;
  late String numOnlineMembers;
  late FetchCommunitySettings communitySettings;
  late List<String> moderators;
  late List<String> members;
  late List<String> rules;
  late List<PostData> posts;
  

  FetchCommunity({
    required this.subredditTitle,
    required this.subredditDescription,
    required this.numJoinedMembers,
    required this.numOnlineMembers,
    required this.communitySettings,
    required this.moderators,
    required this.members,
    required this.rules,
    required this.posts,
  });

  factory FetchCommunity.fromJson(Map<String, dynamic> json) {
    return FetchCommunity(
      subredditTitle: json['subredditTitle'],
      subredditDescription: json['subredditDescription'],
      numJoinedMembers: json['numJoinedMembers'],
      numOnlineMembers: json['numOnlineMembers'],
      communitySettings: FetchCommunitySettings.fromJson(json['communitySettings']),
      moderators: List<String>.from(json['moderators']),
      members: List<String>.from(json['members']),
      rules: List<String>.from(json['rules']),
      posts: List<PostData>.from(json['posts']),
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'subredditTitle': subredditTitle,
      'subredditDescription': subredditDescription,
      'numJoinedMembers': numJoinedMembers,
      'numOnlineMembers': numOnlineMembers,
      'communitySettings': communitySettings.toJson(),
      'moderators': moderators,
      'members': members,
      'rules': rules,
      'posts': posts,
    };
  }
    Map<String, dynamic> toMap() {
    return {
      'subredditTitle': subredditTitle,
      'subredditDescription': subredditDescription,
      'numJoinedMembers': numJoinedMembers,
      'numOnlineMembers': numOnlineMembers,
      'communitySettings': communitySettings.toMap(),
      'moderators': moderators,
      'members': members,
      'rules': rules,
      'posts': posts,
    };
  }
}


class FetchCommunitySettings {
  late String subredditImage;
  late String subredditBanner;
  late String keyColor;
  late String baseColor;
  late String stickyPostColor;

  FetchCommunitySettings({
    this.subredditImage='https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg',
    this.subredditBanner='https://htmlcolorcodes.com/assets/images/colors/bright-blue-color-solid-background-1920x1080.png',
    required this.keyColor,
    required this.baseColor,
    required this.stickyPostColor,
  });

  factory FetchCommunitySettings.fromJson(Map<String, dynamic> json) {
    return FetchCommunitySettings(
      subredditImage: json['subredditImage'],
      subredditBanner: json['subredditBanner'],
      keyColor: json['keyColor'],
      baseColor: json['baseColor'],
      stickyPostColor: json['stickyPostColor'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'subredditImage': subredditImage,
      'subredditBanner': subredditBanner,
      'keyColor': keyColor,
      'baseColor': baseColor,
      'stickyPostColor': stickyPostColor,
    };
    
  }
  Map<String, dynamic> toMap() {
    return {
      'subredditImage': subredditImage,
      'subredditBanner': subredditBanner,
      'keyColor': keyColor,
      'baseColor': baseColor,
      'stickyPostColor': stickyPostColor,
    };
  }
}