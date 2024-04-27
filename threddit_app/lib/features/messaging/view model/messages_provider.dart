import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/messaging/model/message_repository.dart';
import 'package:threddit_clone/models/message.dart';

final messageRepositoryProvider = Provider((ref) => MessageRepository());

final messagesProvider =
    StreamProvider<List<Message>>((ref) {
  final repository = ref.watch(messageRepositoryProvider);
  return repository.getMessagesStream();
});
typedef parameters = ({String recipient, String subject, String message});
final addMessageProvider = FutureProvider.autoDispose.family<void, parameters>((
  ref,
  arguments,
) async {
  final repository = ref.watch(messageRepositoryProvider);
  repository.createMessage(arguments.recipient, arguments.subject,arguments.message);
});