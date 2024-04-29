import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/chatting/view/widgets/chat_item.dart';
import 'package:threddit_clone/theme/theme.dart';

class ChatRoomScreen extends StatelessWidget {
  final Chatroom chatroom;
  final String username;
  @override
  const ChatRoomScreen(
      {super.key, required this.chatroom, required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(199, 10, 10, 10),
      appBar: AppBar(
        title: Text(
          chatroom.chatroomMembers.length > 2
              ? chatroom.chatroomName
              : chatroom.chatroomMembers[0].username,
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
            onPressed: () {},
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

class ChatBody extends ConsumerStatefulWidget {
  @override
  const ChatBody({super.key, required this.chatroom, required this.username});
  final String username;
  final Chatroom chatroom;
  @override
  // ignore: library_private_types_in_public_api
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends ConsumerState<ChatBody> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          child: CircleAvatar(
                            backgroundImage:
                                widget.chatroom.chatroomMembers.length > 2
                                    ? const AssetImage(
                                        'assets/images/group-avatars.png')
                                    : const AssetImage(
                                        'assets/images/Default_Avatar.png'),
                            backgroundColor: Colors.transparent,
                            radius: 50.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.chatroom.chatroomMembers.length > 2
                          ? widget.chatroom.chatroomName
                          : widget.chatroom.chatroomMembers[0].username,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.chatroom.chatroomMembers.length > 2)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
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
                                onPressed: () {},
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
                          SizedBox(height: 60.h,),
                    Consumer(
                      builder: (context, watch, child) {
                        final messagesAsyncValue =
                            ref.watch(getChatMessages(widget.chatroom.id));
                
                        return messagesAsyncValue.when(
                          data: (messages) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    return ChatItem(
                                      message: message,
                                      username: widget.username,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                          loading: () => const Loading(),
                          error: (error, stack) => Text('Error: $error'),
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
                onPressed: () {
                  // Handle emoji button press
                },
              ),
              IconButton(
                icon: const Icon(Icons.gif),
                onPressed: () {
                  // Handle GIF button press
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Handle send button press
                  _messageController
                      .clear(); // Clear the text field after sending message
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
