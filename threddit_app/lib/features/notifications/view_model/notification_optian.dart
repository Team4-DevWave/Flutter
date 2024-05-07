import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;

/// A Riverpod provider for marking all notifications as read.
///
/// This file defines a `FutureProvider` that sends a PATCH request to an API to mark all notifications as read.
/// The API's URL is hardcoded.

/// A `FutureProvider` that marks all notifications as read.
///
/// This provider sends a PATCH request to an API to mark all notifications as read. The API's URL is hardcoded.
/// The request includes a 'Content-Type' header of 'application/json' and an 'Authorization' header with the user's token.
///
/// If the request is successful (i.e., the response status code is 200), the provider completes without throwing an exception.
/// If the request fails, the provider throws an exception.

final markAllNotificationsAsReadProvider = FutureProvider<void>((ref) async {
  try {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/notifications/mark_all_read');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    await http.patch(
      url,
      headers: headers,
    );
  } catch (e) {
    throw Exception('Failed to mark all messages as read: $e');
  }
});
