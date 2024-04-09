import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

final searchStateNotifierProvider = StateNotifierProvider<SearchStateNotifier, AsyncValue<List<String>>>((ref) {
  return SearchStateNotifier(http.Client());
});

class SearchStateNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final http.Client _client;

  SearchStateNotifier(this._client) : super(AsyncValue.loading()) {
    searchUsers('');
  }

  Future<void> searchUsers(String query) async {
    state = AsyncValue.loading();
    final response = await _client.get(Uri.parse("http://10.0.2.2:3001/api/search-user?query=$query"));
    if (response.statusCode == 200) {
      state = AsyncValue.data(List<String>.from(jsonDecode(response.body)));
    } 
  }
}