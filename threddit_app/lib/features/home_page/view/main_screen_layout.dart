import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/view/add_post_screen.dart';
import 'package:threddit_app/features/home_page/view/chat_screen.dart';
import 'package:threddit_app/features/home_page/view/community_screen.dart';
import 'package:threddit_app/features/home_page/view/home_screen.dart';
import 'package:threddit_app/features/home_page/view/notifications_screen.dart';
import 'package:threddit_app/theme/colors.dart';

class MainScreenLayout extends StatefulWidget {
  const MainScreenLayout({super.key});
  @override
  State<MainScreenLayout> createState() => _MainScreenLayout();
}

class _MainScreenLayout extends State<MainScreenLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const HomeScreen(),
    const CommunityScreen(),
    const AddPostScreen(),
    const ChatScreen(),
    const NotificationsScreen()
  ];

  int _selectedIndex = 0;

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      body: _screens[_selectedIndex],
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
