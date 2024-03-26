import 'package:threddit_app/features/commenting/model/comment.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_app/features/commenting/model/community.dart';

class CommunityRepository {
  static const String baseUrl = 'http://192.168.100.249:3000/communities';

  Future<void> createCommunity(String name,bool is18plus,String uid,CommunityType _type) async {
  final community = Community(
    name: name,
    avatar: '', 
    members: [uid], 
    mods: [uid], 
    type: _type, 
    is18plus: is18plus,
  );

  Map<String, dynamic> communityData = community.toMap();
  String jsonData = jsonEncode(communityData);
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonData,
  );

  if (response.statusCode == 200) {
    print('Community added successfully');
  } else {
    throw Exception('Failed to add community: ${response.statusCode}');
  }
}
}