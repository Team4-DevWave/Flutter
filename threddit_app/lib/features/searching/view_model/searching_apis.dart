import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/searching/model/trends.dart';

const String urlAndroid = "http://10.0.2.2:3001";
const String urlWindows = "http://localhost:3001";
final queryProvider = StateProvider<String>((ref) => "");
final searchingApisProvider =
    StateNotifierProvider<SearchingApis, bool>((ref) => SearchingApis(ref));
final futureSearchProvide = FutureProvider((ref) async {
  final query = ref.watch(queryProvider);
  final results = await ref.read(searchingApisProvider.notifier).search(query);
  return results;
});
class SearchingApis extends StateNotifier<bool> {
  final Ref ref;
  SearchingApis(this.ref) : super(false);
  Future<Trends> getTrending() async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }

    final response = await http.get(
      Uri.parse('$url/api/v1/homepage/trending'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return Trends.fromJson(jsonDecode(response.body));
  }

  Future<List<String>> search(String query) async {
    http.Response response = await http.get(
      Uri.parse("http://10.0.2.2:3001/api/search-user?query=$query"),
    );
    List<dynamic> data = jsonDecode(response.body.toString());
    List<String> searchResults = [];
    for (var searchData in data) {
      String result = searchData['result'] as String;
      searchResults.add(result);
    }
    return searchResults;
  }
}
