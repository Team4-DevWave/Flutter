import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';



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
