import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/view/add_post_screen.dart';
import 'package:threddit_app/theme/colors.dart';

class MainScreenLayout extends StatefulWidget {
  const MainScreenLayout({super.key});
  @override
  State<MainScreenLayout> createState() => _MainScreenLayout();
}

class _MainScreenLayout extends State<MainScreenLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {}
    if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => const AddPostScreen()));
    }
  }

  // void _closeEndDrawer() {
  //   Navigator.of(context).pop();
  // }

  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: const Icon(Icons.person_rounded),
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
          backgroundColor: AppColors.backgroundColor,
          child: ListView(
            padding: const EdgeInsets.all(2),
            children: const [
              DrawerHeader(child: Text('Your Communities')),
            ],
          )),
      endDrawer: Drawer(
        backgroundColor: AppColors.backgroundColor,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 2 / 3),
        ),
      ),
      bottomNavigationBar: BottomAppBar(

        color: AppColors.backgroundColor,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 255, 255, 255),
                  )),
                  const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.people_alt,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const Spacer(),
              
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const Spacer(),
              
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chat_outlined,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const Spacer(),
              
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ],
          ),
        ),  
      ),
    );
  }
}
