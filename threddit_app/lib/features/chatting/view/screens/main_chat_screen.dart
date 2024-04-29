import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/chatting/view/widgets/new_chat.dart';
import 'package:threddit_clone/features/home_page/view/widgets/left_drawer.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

class MainChatScreen extends ConsumerStatefulWidget {
  const MainChatScreen({super.key});

  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends ConsumerState<MainChatScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Chatroom> _chatrooms = [];
  Socket? socket;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchChatrooms();
  }

  Future<void> _fetchChatrooms() async {
    String? token = await getToken();
    final url = Uri.parse('http://${AppConstants.local}/api/v1/chatrooms/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final chatrooms = data['chatrooms'] as List;
      setState(() {
        _chatrooms = chatrooms.map((json) => Chatroom.fromJson(json)).toList();
      });
    } else {
      print('Error fetching chatrooms: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    socket?.disconnect(); // Disconnect from socket on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String uid = ref.read(userModelProvider)!.id!;

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
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.filter_alt_sharp)),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
            SizedBox(width: 5.w),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(110.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  const Text("Discover Channels",
                      style: TextStyle(
                          color: Color.fromARGB(126, 255, 255, 255),
                          fontSize: 16)),
                  // Add more widgets or placeholders here for future content
                  const SizedBox(height: 70),
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
              backgroundColor: Color.fromARGB(255, 56, 56, 56),
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: const NewChat(),
                );
              },
            );
          },
          icon: const Icon(
            Icons.chat_bubble,
            color: Color.fromARGB(255, 163, 151, 239),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _chatrooms.isEmpty
                ? const Center(child: Text('No chatrooms found'))
                : ListView.builder(
                    itemCount: _chatrooms.length,
                    itemBuilder: (context, index) {
                      final chatroom = _chatrooms[index];
                      return ListTile(
                        title: Text(chatroom
                            .chatroomName), //to be modified to the actual chatroom
                        subtitle: chatroom.latestMessage == null
                            ? const Text('No messages yet')
                            : Text(chatroom.latestMessage),
                        onTap: () {
                          // Navigate to chat screen with chatroom details
                        },
                      );
                    },
                  ),
            Center(child: Text('Requests Page')),
          ],
        ),
      ),
    );
  }
}
