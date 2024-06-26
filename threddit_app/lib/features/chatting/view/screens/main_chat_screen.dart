import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/chatting/view/widgets/chat_room_preview.dart';
import 'package:threddit_clone/features/chatting/view/widgets/new_chat.dart';
import 'package:threddit_clone/features/home_page/view/widgets/left_drawer.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/theme/theme.dart';

/// This file contains the implementation of the main chat screen.
/// The main chat screen is responsible for displaying the chat interface
/// and handling user interactions related to chatting.

/// function to sort the chats in the main chatrooms screen
List<Chatroom> sortChatroomsByLatestMessage(List<Chatroom> chatrooms) {
  chatrooms.sort((a, b) {
    final latestMessageA = a.latestMessage;
    final latestMessageB = b.latestMessage;

    if (latestMessageA == null && latestMessageB == null) {
      // If both chatrooms have no latest messages, sort by creation date
      return b.dateCreated.compareTo(a.dateCreated);
      // To sort by ascending order, swap a.dateCreated and b.dateCreated
    } else if (latestMessageA == null) {
      return 1; // A has no latest message, so it should come after B
    } else if (latestMessageB == null) {
      return -1; // B has no latest message, so it should come after A
    }

    // Compare the date of the latest message
    return latestMessageB.dateSent.compareTo(latestMessageA.dateSent);
    // To sort by ascending order, swap latestMessageA and latestMessageB
  });

  return chatrooms;
}


class MainChatScreen extends ConsumerStatefulWidget {
  const MainChatScreen({super.key});

  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends ConsumerState<MainChatScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
   
  }

 
  

  @override
  void dispose() {
    _tabController?.dispose();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String uid = ref.read(userModelProvider)!.username!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          title: const Text(
            'Chat',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
           
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
            SizedBox(width: 5.w),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: const Color.fromARGB(255, 221, 106, 24),
                    labelColor: Colors.white,
                    tabs: const [
                      Tab(text: 'Messages'),
                      Tab(text: 'Requests'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: const LeftDrawer(),
        endDrawer: const RightDrawer(),
        floatingActionButton: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              scrollControlDisabledMaxHeightRatio: double.infinity,
              backgroundColor: const Color.fromARGB(255, 56, 56, 56),
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: NewChat(uid: uid),
                );
              },
            );
          },
          icon: const Icon(
            Icons.add_comment,
            color: Color.fromARGB(255, 163, 151, 239),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Center(
              child: Consumer(
                builder: (context, watch, child) {
                  final chatroomsAsyncValue = ref.watch(fetchChatRooms);

                  return chatroomsAsyncValue.when(
                    data: (chatrooms) {
                      return ListView.builder(
                        itemCount: chatrooms.length,
                        itemBuilder: (context, index) {
                          List<Chatroom> sortedChatrooms = sortChatroomsByLatestMessage(chatrooms);

                          final chatroom = sortedChatrooms[index];
                          return chatrooms.isNotEmpty
                              ? Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, RouteClass.chatRoom,
                                              arguments: {
                                                'chatroom': chatroom,
                                                'username': uid
                                              });
                                        },
                                        child: ChatPreview(
                                          chat: chatroom,
                                          username: uid,
                                        )),
                                   
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          'assets/images/thinking-snoo.png'),
                                      height: 180.h,
                                    ),
                                    Text(
                                        'No open chatrooms,\n    Start Chatting?',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                );
                        },
                      );
                    },
                    loading: () => const Loading(),
                    error: (error, stack) => Text('Error: $error'),
                  );
                },
              ),
            ),
            const Center(child: Text('Requests Page')),
          ],
        ),
      ),
    );
  }
}
