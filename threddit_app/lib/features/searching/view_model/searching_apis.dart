import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/model/trends.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

const String urlAndroid = "http://10.0.2.2";
const String urlWindows = "http://localhost";
final searchInputProvider = StateProvider<String>((ref) => '');

final searchingApisProvider =
    StateNotifierProvider<SearchingApis, bool>((ref) => SearchingApis(ref));
final trendingFutureProvider = FutureProvider<List<Trend>>(
  (ref) async {
    final searchingApi = ref.watch(searchingApisProvider.notifier);
    final searchResult =
        searchingApi.getTrending(); // Assuming search returns SearchModel
    return searchResult;
  },
);

/// Api function for searching.
/// It takes the qury, the page, and sorting which is by default Top
/// Gets the token then calls the api and returns a SearchModel object which includes the search Results.
Future<SearchModel> searchTest(String query, int page,
    {String sorting = "Top"}) async {
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  print("TESSSSSSSSSSSSSSSST before");

  String? token = await getToken();
  http.Response response = await http.get(
    Uri.parse(
        "$url:8000/api/v1/homepage/search?q=$query&sort=$sorting&page=$page"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  final search = SearchModel.fromJson(jsonDecode(response.body));
  return SearchModel.fromJson(jsonDecode(response.body));
}
class SearchingApis extends StateNotifier<bool> {
  final Ref ref;
  SearchingApis(this.ref) : super(false);
  /// Api for getting the Trending list from the backend.
  /// It gets the token then calls the api and returns a List of [Trend]
  Future<List<Trend>> getTrending() async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    String? token = await getToken();

    final response = await http.get(
      Uri.parse('$url:8000/api/v1/homepage/trending'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> trendsData = data['data']['trends'];
    List<Trend> trends =
        trendsData.map((json) => Trend.fromJson(json)).toList();
    return trends;
  }

  /// Api function for searching.
  /// It takes the qury, the page, and sorting which is by default Top
  /// Gets the token then calls the api and returns a SearchModel object which includes the search Results.

  Future<SearchModel> search(String query, int page) async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    String? token = await getToken();
    http.Response response = await http.get(
      Uri.parse(
          "$url:8000/api/v1/homepage/search?q=$query&sort=Top&page=$page"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final search = SearchModel.fromJson(jsonDecode(response.body));
    return SearchModel.fromJson(jsonDecode(response.body));
  }
}
