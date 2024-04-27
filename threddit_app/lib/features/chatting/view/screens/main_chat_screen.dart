import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/home_page/view/widgets/left_drawer.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
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
                    indicatorColor: Color.fromARGB(255, 221, 106, 24),
                    labelColor: Colors.white,
                    tabs: const [
                      Tab(text: 'Messages'),
                      Tab(text: 'Threads'),
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
          onPressed: () {},
          icon: const Icon(
            Icons.chat_bubble,
            color: Color.fromARGB(255, 163, 151, 239),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            Center(child: Text('Messages Page')),
            Center(child: Text('Threads Page')),
            Center(child: Text('Requests Page')),
          ],
        ),
      ),
    );
  }
}
