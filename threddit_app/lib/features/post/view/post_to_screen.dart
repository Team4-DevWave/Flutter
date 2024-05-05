import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_list.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A StatefulWidget responsible for displaying the screen for posting to communities.
///
/// This widget allows users to search for communities they want to post to.
/// It includes a search bar for querying communities, and displays a list of
/// search results.
class PostToScreen extends ConsumerStatefulWidget {
  /// Constructs a new [PostToScreen].
  const PostToScreen({super.key});
  @override
  ConsumerState<PostToScreen> createState() => _PostToScreenState();
}

class _PostToScreenState extends ConsumerState<PostToScreen> {
  late TextEditingController _communityText;
  late List<List<String>> searchResults;

  @override
  void initState() {
    /// Initializes the state of the widget.
    _communityText = TextEditingController();
    searchResults = [];
    super.initState();
  }

  @override
  void dispose() {
    /// Disposes of resources used by the widget.
    _communityText.dispose();
    super.dispose();
  }

  /// Handles the change in query for community search.
  ///
  /// When the user types in the search bar, this method is triggered to
  /// fetch and update the list of search results based on the query.
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
