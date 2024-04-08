import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/community.dart';

class CommunityRepository {
  static const String baseUrl = 'http://192.168.100.249:3000/communities';

  Future<void> createCommunity(String name,bool is18plus,String uid,CommunityType _type) async {
  final community = Community(
    id:'0',
    name: name,
    avatar: '', 
    banner:'',
    members: [uid], 
    mods: [uid], 
    type: _type, 
    nsfw: is18plus,
    rules:[]
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

Future<Community> fetchCommunity(String id) async {
  final response = await http.get(Uri.parse('http://192.168.100.249:3000/communities?id=${id}'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      return Community.fromJson(data.first);
    } else {
      throw Exception('Community not found');
    }
  } else {
    throw Exception('Failed to load community');
  }
}

Future<void> joinCommunity(String id, String userID) async {
  final community = await fetchCommunity(id);
  community.members.add(userID);
  await updateCommunity(community);
}

Future<void> unJoinCommunity(String id, String userID) async {
  final community = await fetchCommunity(id);
  community.members.remove(userID);
  await updateCommunity(community);
}

Future<void> updateCommunity(Community community) async {
  final String apiUrl = 'http://192.168.100.249:3000/communities/${community.id}';
  final Map<String, dynamic> data = community.toMap();

  final response = await http.patch(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print('Community updated successfully');
  } else {
    throw Exception('Failed to update community: ${response.reasonPhrase}');
  }
}


}