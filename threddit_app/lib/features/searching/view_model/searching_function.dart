import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
final histroyFutureProvider = FutureProvider<List<String>>(
  (ref) async {
    List<String>? history = await getSearchHistory();
    history ??= [];
    return history;
  },
);
Future<void> saveSearchHistory(String history) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? currentHistory = prefs.getStringList('searchHistory');
  currentHistory = addingHistory(history, currentHistory);
  await prefs.setStringList("searchHistory", currentHistory);
}

Future<List<String>?> getSearchHistory() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('searchHistory');
}

List<String> addingHistory(String history, List<String>? currentHistory) {
  if (currentHistory != null) {
    if (currentHistory.length > 3) {
      currentHistory.removeAt(1);
      currentHistory.add(history);
    } else {
      currentHistory.add(history);
    }
  } else {
    currentHistory = [];
    currentHistory.add(history);
  }
  return currentHistory;
}
