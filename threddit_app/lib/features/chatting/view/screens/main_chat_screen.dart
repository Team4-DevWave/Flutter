import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/chatting/view%20model/chat_provider.dart';
import 'package:threddit_clone/features/chatting/view/widgets/chat_item.dart';
import 'package:threddit_clone/features/home_page/view/widgets/left_drawer.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/models/message.dart';

class MainChatScreen extends ConsumerStatefulWidget {
  const MainChatScreen({super.key, required this.uid});
  final String uid;
  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends ConsumerState<MainChatScreen> {
  bool isMessagesButtonPressed = true;
  bool isRequestsButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    Message message = Message(
        id: '1',
        sender: 'user1',
        recipient: 'user2',
        timestamp: DateTime.now(),
        text: 'Hello');
    ChatItem chat = ChatItem(message: message, uid: 'user2');
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          title: const Text(
            'Chat',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_comment_sharp),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.filter_alt_sharp)),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.person_rounded),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
        drawer: const LeftDrawer(),
        endDrawer: const RightDrawer(),
        body: Consumer(
          builder: (context, watch, child) {
            var userMessages = ref.watch(chatProvider(widget.uid));
            return userMessages.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
                data: (userMessages) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: isMessagesButtonPressed
                                  ? Colors.white
                                  : const Color.fromARGB(56, 255, 255, 255),
                            ),
                            onPressed: () {
                              setState(() {
                                isMessagesButtonPressed = true;
                                isRequestsButtonPressed = false;
                              });
                            },
                            child: const Text(
                              'Messages',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: isRequestsButtonPressed
                                  ? Colors.white
                                  : const Color.fromARGB(58, 255, 255, 255),
                            ),
                            onPressed: () {
                              setState(() {
                                isRequestsButtonPressed = true;
                                isMessagesButtonPressed = false;
                              });
                            },
                            child: const Text(
                              'Requests',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      if (isMessagesButtonPressed)
                        if (userMessages != [])
                          ...userMessages.map((message) => ChatItem(
                                message: message,
                                uid: widget.uid,
                              )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: 220.w,
                            child: const Text(
                              'Chat with other Redditors about your favourite topics.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: FilledButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Color.fromARGB(255, 4, 44, 77))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.travel_explore),
                                    Text(
                                      'Explore Channels',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
