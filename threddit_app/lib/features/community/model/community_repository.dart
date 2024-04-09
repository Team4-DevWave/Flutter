import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/fetch_community.dart';

class CommunityRepository {
  final url = Uri.parse('http://192.168.100.249:3000/communities');

  Future<void> createCommunity(String name,bool nsfw,String uid,String _type) async {

 final body = jsonEncode({
    'name': name,
    'srType': _type,
    'nsfw': nsfw,
  });

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    //token 
  };

  try {
    final response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 201) {
      jsonDecode(response.body);
      //final newCommunityData = responseData['data']['newCommunity'];
      print('community created successfully');
    } else {
      print('Failed to create community. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error creating community: $e');
  }
}

Future<FetchCommunity> fetchCommunity(String id) async {
  //final url = Uri.parse('http://localhost:8000/api/v1/r/$subreddit/info');
 final url = Uri.parse('http://192.168.100.249:3000/communities?subredditTitle=${id}');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        final Map<String, dynamic> communityData = responseData.first;
        return FetchCommunity.fromJson(communityData);
      } else {
        throw Exception('Community not found');
      }
    } else {
      print('Failed to fetch subreddit info. Status code: ${response.statusCode}');
      throw Exception('Community not found');
    }
  } catch (e) {
    print('Error fetching subreddit info: $e');
    throw Exception('Community not found');
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

Future<void> updateCommunity(FetchCommunity community) async {
  final String apiUrl = 'http://192.168.100.249:3000/communities?subredditTitle=${community.subredditTitle}';
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