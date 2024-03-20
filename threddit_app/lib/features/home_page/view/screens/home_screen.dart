import 'package:flutter/material.dart';

import 'package:threddit_app/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _openEndDrawer();
            },
            icon: const Icon(Icons.person_rounded),
          ),
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
          onSelected: (String? value) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Changed to tab $value')));
          },
        ),
      ),
      drawer: Drawer(
        elevation: double.maxFinite,
        backgroundColor: AppColors.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor.withOpacity(.5),
              ),
              child: const Text(
                'Your Communities',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text(
                'Item 1',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Update UI based on item selected
              },
            ),
            ListTile(
              title:
                  const Text('Item 2', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Update UI based on item selected
              },
            ),
            // Add more ListTile widgets for other items if needed
          ],
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: AppColors.backgroundColor,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 2 / 3),
        ),
      ),
    );
  }
}
