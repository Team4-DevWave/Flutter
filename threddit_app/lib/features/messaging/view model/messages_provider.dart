import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/messaging/model/message_repository.dart';
import 'package:threddit_clone/models/message.dart';

final messageRepositoryProvider = Provider((ref) => MessageRepository());

final messagesProvider = FutureProvider<List<Message>>((ref) async {
  final repository = ref.watch(messageRepositoryProvider);
  return await repository.fetchUserMessages();
});
