import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_list.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class PostToScreen extends ConsumerStatefulWidget {
  const PostToScreen({super.key});
  @override
  ConsumerState<PostToScreen> createState() => _PostToScreenState();
}

class _PostToScreenState extends ConsumerState<PostToScreen> {
  late TextEditingController _communityText;
  late List<List<String>> searchResults;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _communityText = TextEditingController();
    searchResults = [];
    super.initState();
  }

  @override
  void dispose() {
    _communityText.dispose();
    super.dispose();
  }

  Future<void> _onQueryChanged(String query) async {
    final comm =
        await ref.watch(userCommunitisProvider.notifier).searchResults(query);
    setState(() {
      comm.fold((l) => showSnackBar(navigatorKey.currentContext!, l.message),
          (r) => searchResults = r);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        title: const Text(
          'Post to',
          style: TextStyle(
              color: AppColors.realWhiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchBar(
              hintText: "Search for a community",
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 200),
              side: const MaterialStatePropertyAll(BorderSide(
                  style: BorderStyle.none, color: Colors.transparent)),
              backgroundColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 30, 30, 30)),
              surfaceTintColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 30, 30, 30)),
              leading: const Icon(
                Icons.search,
                color: AppColors.realWhiteColor,
              ),
              shadowColor: null,
              textStyle:
                  MaterialStatePropertyAll(AppTextStyles.primaryTextStyle),
              onChanged: (text) {
                _onQueryChanged(text);
              },
            ),
            CommunityList(searchRes: searchResults),
          ],
        ),
      ),
    );
  }
}
