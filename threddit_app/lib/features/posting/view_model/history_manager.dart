import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

class HistoryManager {
  static const String _historyKey = 'postHistory';

  static Future<void> addPostToHistory(Post postData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];

    final existingIndex = history.indexWhere((postJson) {
      final post = Post.fromJson(jsonDecode(postJson));
      return post.id == postData.id;
    });

    if (existingIndex != -1) {
      // If the post exists, remove it
      history.removeAt(existingIndex);
    }

    history.add(json.encode(postData.toJson()));

    await prefs.setStringList(_historyKey, history);
  }

  static Future<List<Post>> getHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history
        .map((e) => Post.fromJson(json.decode(e) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  static Future<void> removePostFromHistory(String postId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    history.removeWhere((postJson) {
      final post = Post.fromJson(jsonDecode(postJson));
      return post.id == postId;
    });
    await prefs.setStringList(_historyKey, history);
  }
}
