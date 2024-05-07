// ignore_for_file: invalid_use_of_protected_member

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';
import 'package:threddit_clone/features/chatting/model/chat_notifier.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/chatting/view/widgets/chat_item.dart';

String _formatDate(DateTime dateTime) {
  final now = DateTime.now();
  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return 'Today';
  } else if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day - 1) {
    return 'Yesterday';
  } else {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

// ignore: must_be_immutable
class ChatRoomScreen extends StatelessWidget {
  Chatroom chatroom;
  final String username;
  @override
  ChatRoomScreen({super.key, required this.chatroom, required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(199, 10, 10, 10),
      appBar: AppBar(
        title: Text(
          chatroom.chatroomName != "New Chat"
              ? chatroom.chatroomName
              : (chatroom.chatroomMembers[0].username != username
                  ? chatroom.chatroomMembers[0].username
                  : chatroom.chatroomMembers[1].username),
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RouteClass.chatRoomOptions,
                arguments: {
                  'chatroom': chatroom,
                  'username': username,
                },
              );
            },
          ),
        ],
      ),
      body: ChatBody(
        username: username,
        chatroom: chatroom,
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatBody extends ConsumerStatefulWidget {
  @override
  ChatBody({super.key, required this.chatroom, required this.username});
  final String username;
  Chatroom chatroom;

  @override
  // ignore: library_private_types_in_public_api
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends ConsumerState<ChatBody> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> messages = [];
  void sendChat() {
    ref.read(chatNotifierProvider.notifier).sendMessage(
        _messageController.text, widget.chatroom.id, widget.username);
    _messageController.clear();
  }

  @override
  void initState() {
    super.initState();
    ref
        .read(chatNotifierProvider.notifier)
        .fetchRoomMessages(widget.chatroom.id);
  }

  @override
  Widget build(BuildContext context) {
    final chatReceiver=widget.chatroom.chatroomMembers[0].username==widget.username?widget.chatroom.chatroomMembers[1]:widget.chatroom.chatroomMembers[0];
    // ignore: invalid_use_of_visible_for_testing_member
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView(
            reverse: true,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          child:widget.chatroom.chatroomName != "New Chat"? const CircleAvatar(
                          radius: 58.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/group-avatars.png'),
                        )
                      :  chatReceiver.profilePicture!=null && chatReceiver.profilePicture!=''? CircleAvatar(
                          radius: 58.0,
                          backgroundColor: const Color.fromARGB(255, 76, 175, 172),
                          backgroundImage:
                              NetworkImage(
                              chatReceiver.profilePicture!),
                        ):const CircleAvatar(
                          radius: 58.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
                        ),
                        ),
                      ],
                    ),
                    Text(
                      widget.chatroom.chatroomName != "New Chat"
                          ? widget.chatroom.chatroomName
                          : (widget.chatroom.chatroomMembers[0].username !=
                                  widget.username
                              ? widget.chatroom.chatroomMembers[0].username
                              : widget.chatroom.chatroomMembers[1].username),
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.chatroom.chatroomName != "New Chat")
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteClass.chatMembers,
                                  arguments: {
                                    'chatroom': widget.chatroom,
                                    'username': widget.username,
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10.0.w),
                                  const Text(
                                    'Members',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0.w),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteClass.inviteMembers,
                                    arguments: {
                                      'chatroom': widget.chatroom,
                                      'username': widget.username,
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.person_add_alt_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10.0.w),
                                    const Text(
                                      'Invite',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    SizedBox(
                      height: 60.h,
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final messages = ref.watch(chatNotifierProvider);
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final DateTime messageDate =
                                DateTime.parse(message.dateSent);
                            final bool isFirstMessage = index == 0 ||
                                messageDate.day !=
                                    DateTime.parse(
                                            messages[index - 1].dateSent)
                                        .day;
                        
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isFirstMessage)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      _formatDate(messageDate), // Helper method to format date
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ChatItem(
                                  message: message,
                                  username: widget.username,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  // Handle camera button press
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(199, 10, 10, 10),
                    filled: true,
                    hintText: 'Message',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0.w,
                      vertical: 10.0.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.emoji_emotions),
                onPressed: () => _showEmojiPicker(context),
              ),
              IconButton(
                icon: const Icon(Icons.gif),
                onPressed: () {
                  // Handle GIF button press
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: _messageController.text != ''
                      ? const Color.fromARGB(235, 243, 51, 3)
                      : Colors.white,
                ),
                onPressed: () {
                  if (_messageController.text != '') {
                    sendChat();
                    _messageController
                        .clear(); // Clear the text field after sending message
                  } else {
                    return;
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.5, // Adjust the height as needed
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                _messageController.text += emoji.emoji;
              });
              Navigator.pop(
                  context); // Close the bottom sheet after selecting an emoji
            },
          ),
        );
      },
      backgroundColor: Colors.transparent, // Set transparent background color
      barrierColor:
          Colors.black.withOpacity(0.5), // Adjust the barrier color and opacity
      isScrollControlled:
          true, // Allow bottom sheet to take up entire screen height
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
