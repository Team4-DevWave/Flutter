import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';

/// This file contains the implementation of the message bottom sheet.
/// A widget that represents the bottom sheet for displaying messages in a chat.
/// This widget is typically used within a chat screen to show a list of messages
/// at the bottom of the screen.



class MessageBottomSheet extends ConsumerStatefulWidget {
  const MessageBottomSheet({
    required this.username,
    required this.message,
    super.key,
  });
  final String username;
  final ChatMessage message;

  @override
  _MessageBottomSheetState createState() => _MessageBottomSheetState();
}

class _MessageBottomSheetState extends ConsumerState<MessageBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
      ],
    );
  }
}
