import 'package:flutter/material.dart';

//import 'package:threddit_app/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> tabs = ['Home', 'Popular', 'Watch', 'Latest'];
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
            actions: [
              SafeArea(
                child: Row(
                  children: [
                    Theme(
                      data: ThemeData.from(
                          colorScheme: ColorScheme.fromSeed(
                              seedColor: Colors.grey.shade700)),
                      child: DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            outlineBorder:
                                const BorderSide(color: Colors.transparent)),
                        textStyle: const TextStyle(color: Colors.white),
                        dropdownMenuEntries: tabs
                            .map<DropdownMenuEntry<String>>((String string) {
                          return DropdownMenuEntry(
                              value: string, label: string);
                        }).toList(),
                        initialSelection: tabs[0],
                      ),
                    ),
                    const SizedBox(width: 150),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    const DrawerButton()
                  ],
                ),
              )
            ],
          ),
          drawer: Drawer(
              child: ListView(
            padding: const EdgeInsets.all(2),
            children: const [
              DrawerHeader(child: Text('Recently Visited')),
            ],
          )),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                  icon: Icon(
                    Icons.people_alt,
                    color: Colors.white,
                  ),
                  label: 'Communities'),
              NavigationDestination(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: 'Create'),
              NavigationDestination(
                  icon: Icon(
                    Icons.chat_bubble_outline_outlined,
                    color: Colors.white,
                  ),
                  label: 'Chat'),
              NavigationDestination(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  label: 'Notification'),
            ],
            backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          ),
        ),
      ),
    );
  }
}
