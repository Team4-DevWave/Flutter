import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // void _closeEndDrawer() {
  //   Navigator.of(context).pop();
  // }

  final List<String> tabs = ['Home', 'Popular', 'Watch', 'Latest'];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Row(
            children: [
              const SizedBox(width: 150),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  _openEndDrawer();
                },
                icon: const Icon(Icons.circle_sharp),
              ),
            ],
          )
        ],
        title: DropdownMenu<String>(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
          textStyle: const TextStyle(color: Colors.white),
          dropdownMenuEntries:
              tabs.map<DropdownMenuEntry<String>>((String string) {
            return DropdownMenuEntry(value: string, label: string);
          }).toList(),
          initialSelection: tabs[0],
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.all(2),
        children: const [
          DrawerHeader(child: Text('Recently Visited')),
        ],
      )),
      endDrawer: Drawer(
        backgroundColor: AppColors.backgroundColor,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 2 / 3),
        ),
      ),
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
