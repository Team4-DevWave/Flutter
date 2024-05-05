import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view/widgets/left_drawer.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/messaging/model/message_repository.dart';
import 'package:threddit_clone/features/messaging/view%20model/messages_provider.dart';
import 'package:threddit_clone/features/messaging/view/widgets/message_item.dart';
import 'package:threddit_clone/features/messaging/view/widgets/options_bottom_sheet.dart';
import 'package:threddit_clone/features/notifications/view/widgets/nottification_feed.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/theme.dart';

class MainInboxScreen extends ConsumerStatefulWidget {
  const MainInboxScreen({super.key});

  @override
  _MainInboxScreenState createState() => _MainInboxScreenState();
}

class _MainInboxScreenState extends ConsumerState<MainInboxScreen>
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
    String uid = ref.read(userModelProvider)!.id!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          title: const Text(
            'Inbox',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: AppColors.backgroundColor,
                      builder: (context) {
                        return const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [InboxOptionsBotttomSheet()]);
                      });
                },
                icon: const Icon(Icons.more_horiz_outlined)),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
            SizedBox(width: 5.w),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color.fromARGB(255, 221, 106, 24),
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'Activity'),
              Tab(text: 'Messages'),
            ],
          ),
        ),
        drawer: const LeftDrawer(),
        endDrawer: const RightDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            NotificationFeed(userID: uid),
            Center(
              child: Consumer(
                builder: (context, watch, child) {
                  final messagesAsyncValue = ref.watch(messagesProvider);

                  return messagesAsyncValue.when(
                    data: (messages) {
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    if (!message.read) {
                                      ref.read(toggleRead(message.id));
                                    }
                                    Navigator.pushNamed(
                                      context,
                                      RouteClass.messageScreen,
                                      arguments: {
                                        'message': message,
                                        'uid': uid,
                                      },
                                    );
                                  },
                                  child:
                                      MessageItem(message: message, uid: uid)),
                              const Divider(
                                color: Colors.grey,
                                thickness: 0.3,
                              ),
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
          ],
        ),
      ),
    );
  }
}
