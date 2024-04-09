import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view/widgets/left_drawer.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/listing/view/widgets/feed_widget.dart';

import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String feedID = 'Best';
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
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteClass.searchScreen);
            },
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
          textStyle: AppTextStyles.primaryTextStyle,
          dropdownMenuEntries:
              tabs.map<DropdownMenuEntry<String>>((String string) {
            return DropdownMenuEntry(value: string, label: string);
          }).toList(),
          width: 150,
          initialSelection: tabs[0],
          onSelected: (String? value) {
            setState(() {
              feedID = value!;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Changed to tab $value'),
              duration: Durations.short1,
            ));
          },
        ),
      ),
      drawer: const LeftDrawer(),
      endDrawer: const RightDrawer(),
      body: FeedWidget(feedID: feedID),
    );
  }
}
