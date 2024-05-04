import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;

final markAllNotificationsAsReadProvider = FutureProvider<void>((ref) async {
  try {
    final url =
        Uri.parse('http://10.0.2.2:8000/api/v1/notifications/mark_all_read');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final response = await http.patch(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('All messages marked as read');
    } else {
      print('Failed to mark all messages as read');
    }
  } catch (e) {
    print('Error marking all messages as read: $e');
    throw Exception('Failed to mark all messages as read: $e');
  }
});
