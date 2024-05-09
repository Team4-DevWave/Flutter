import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_community_screen.dart';
import 'package:threddit_clone/features/messaging/view/screens/Inbox.dart';

import 'package:threddit_clone/features/post/view/add_post_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/home_screen.dart';

import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/home_page/view_model/home_page_provider.dart';
import 'package:threddit_clone/features/chatting/view/screens/main_chat_screen.dart';

class MainScreenLayout extends ConsumerStatefulWidget {
  const MainScreenLayout({super.key});
  @override
  ConsumerState<MainScreenLayout> createState() => _MainScreenLayout();
}

class _MainScreenLayout extends ConsumerState<MainScreenLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const HomeScreen(),
    const MainCommunityScreen(),
    const AddPostScreen(),
    const MainChatScreen(),
    const MainInboxScreen()
  ];

  Future<void> _setData() async {
    await ref.read(settingsFetchProvider.notifier).getMe();
  }

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(currentScreenProvider);

    void onItemTapped(int index) {
      ref.read(currentScreenProvider.notifier).updateCurrentScreen(index);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppColors.realWhiteColor,
        selectedItemColor: AppColors.redditOrangeColor,
        backgroundColor: AppColors.backgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline_outlined,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            label: 'Inbox',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
