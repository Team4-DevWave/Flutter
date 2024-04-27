import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/models/message.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());
