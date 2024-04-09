import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/chatting/view%20model/chat_provider.dart';
import 'package:threddit_clone/features/chatting/view/widgets/chat_item.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer_buttons.dart';
import 'package:threddit_clone/models/message.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

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
        drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: AppColors.mainColor),
          child: Drawer(
            elevation: double.maxFinite,
            backgroundColor: AppColors.mainColor,
            shadowColor: AppColors.mainColor,
            surfaceTintColor: AppColors.mainColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'Recently Visited',
                    style: AppTextStyles.primaryTextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const CommunitiesTiles(title: "Communities"),
                const FollowingTiles(title: "Following"),
              ],
            ),
          ),
        ),
        endDrawer: Drawer(
          backgroundColor: AppColors.mainColor,
          child: Column(
            children: [
              SizedBox(
                height: 150.h,
                child: DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteClass.userProfileScreen);
                        },
                        child: Image.asset(
                          Photos.snoLogo,
                          width: 50.w,
                          height: 50.h,
                        ),
                      ),
                      Text(
                        "u/UserName",
                        style: AppTextStyles.primaryTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              RightDrawerButtons(
                  icon: const Icon(
                    Icons.person_outline,
                    color: AppColors.whiteColor,
                  ),
                  title: "My profile",
                  onTap: () {
                    Navigator.pushNamed(context, RouteClass.postScreen);
                  }),
              RightDrawerButtons(
                  icon: const Icon(
                    Icons.group_add_outlined,
                    color: AppColors.whiteColor,
                  ),
                  title: "Create a community",
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteClass.createCommunityScreen);
                  }),
              RightDrawerButtons(
                  icon: const Icon(
                    Icons.bookmarks_outlined,
                    color: AppColors.whiteColor,
                  ),
                  title: "Saved",
                  onTap: () {}),
              RightDrawerButtons(
                  icon: const Icon(
                    Icons.history_toggle_off_rounded,
                    color: AppColors.whiteColor,
                  ),
                  title: "History",
                  onTap: () {}),
              RightDrawerButtons(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.whiteColor,
                  ),
                  title: "Settings",
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteClass.accountSettingScreen);
                  }),
            ],
          ),
        ),
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
                          const SizedBox(
                            width: 220,
                            child: Text(
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
