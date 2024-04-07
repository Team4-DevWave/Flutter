import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/chatting/view/screens/main_chat_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/add_post_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/community_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/notifications_screen.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/home_page/view_model/home_page_provider.dart';

class MainScreenLayout extends ConsumerStatefulWidget {
  const MainScreenLayout({super.key});
  @override
  ConsumerState<MainScreenLayout> createState() => _MainScreenLayout();
}

class _MainScreenLayout extends ConsumerState<MainScreenLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const HomeScreen(),
    const CommunityScreen(),
    const AddPostScreen(),
    const MainChatScreen(uid: 'user2'),
    const NotificationsScreen()
  ];

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
            label: 'Notification',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
