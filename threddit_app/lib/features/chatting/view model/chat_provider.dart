import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/models/message.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());
final chatProvider = FutureProvider.autoDispose
    .family<List<Message>, String>((ref, uid) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.fetchMessages(uid);
});