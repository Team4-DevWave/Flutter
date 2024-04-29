import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';

class ChatRoomScreen extends StatelessWidget {
  @override
  final Chatroom chatroom;
  const ChatRoomScreen({super.key, required this.chatroom});
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
        chatroom: chatroom,
      ),
    );
  }
}

class ChatBody extends StatefulWidget {
  @override
  const ChatBody({super.key, required this.chatroom});
  final Chatroom chatroom;
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Placeholder for chat messages
        Expanded(
          child: Container(
            color: const Color.fromARGB(199, 10, 10, 10),
            // Add your chat messages here
            child: Center(
                child: Column(
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
                        radius: 50.0, // Adjust radius for desired size
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 20.h,
                  child: Text(
                    widget.chatroom.chatroomMembers.length > 2
                        ? widget.chatroom.chatroomName
                        : widget.chatroom.chatroomMembers[0].username,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if(widget.chatroom.chatroomMembers.length > 2)
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        SizedBox(
                            width: 10.0.w), // Add spacing between icon and text
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
                      child: const Column(
                        children: [
                          Icon(
                            Icons.person_add_alt_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                              width: 10.0), // Add spacing between icon and text
                          Text(
                            'Invite',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ])
              ],
            )),
          ),
        ),

        // Text field for typing messages and icon buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  // Handle camera button press
                  // Add your logic here
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  onEditingComplete: () =>
                      FocusScope.of(context).nextFocus(), // Focus next field
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(199, 10, 10, 10),
                    filled: true,
                    hintText: 'Message',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0.w,
                      vertical: 10.0.h,
                    ), // Adjust padding as needed

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // Remove border
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.emoji_emotions),
                onPressed: () {
                  // Handle emoji button press
                  // Add your logic here
                },
              ),
              IconButton(
                icon: const Icon(Icons.gif),
                onPressed: () {
                  // Handle GIF button press
                  // Add your logic here
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Handle send button press
                  // You can access the typed message using _messageController.text
                  // Add your logic here
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
