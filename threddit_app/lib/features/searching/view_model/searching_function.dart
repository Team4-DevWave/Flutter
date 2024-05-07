import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// Future provider for the search history
final histroyFutureProvider = FutureProvider<List<String>>(
  (ref) async {
    List<String>? history = await getSearchHistory();
    history ??= [];
    return history;
  },
);
/// Function for saving the search history
/// Uses Shared preferences to save it.
Future<void> saveSearchHistory(String history) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? currentHistory = prefs.getStringList('searchHistory');
  currentHistory = addingHistory(history, currentHistory);
  await prefs.setStringList("searchHistory", currentHistory);
}
/// Function for getting the search history
/// Uses Shared preferences to get the list of strings.
Future<List<String>?> getSearchHistory() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('searchHistory');
}
/// Function for removing the search history 
/// gets the list then removes the element then saves it to the shared preferences.
Future<void> removeSearchHistory(String historyToDelete) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? currentHistory = prefs.getStringList('searchHistory');
  currentHistory!.remove(historyToDelete);
  await prefs.setStringList("searchHistory", currentHistory);
}
/// Function to add a search history
/// We can only have 3 search histories at once
/// so we have 3 cases:
/// 
/// 1-If the list is empty, so we simply make a new list and insert it.
/// 
/// 2-If the list has one or two elements then we insert the history normally.
/// 
/// 3-If the list has three elements then we remove one and insert the new one.
List<String> addingHistory(String history, List<String>? currentHistory) {
  if (currentHistory != null) {
    if (currentHistory.length >= 3) {
      currentHistory.removeAt(2);
      currentHistory.insert(0, history);
    } else {
      currentHistory.insert(0, history);
    }
  } else {
    currentHistory = [];
    currentHistory.insert(0, history);
  }
  return currentHistory;
}
